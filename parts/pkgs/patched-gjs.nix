# taken from upstream and altered
{
  fetchurl,
  lib,
  stdenv,
  meson,
  mesonEmulatorHook,
  ninja,
  pkg-config,
  gnome,
  gtk3,
  atk,
  gobject-introspection,
  spidermonkey_102,
  pango,
  cairo,
  readline,
  libsysprof-capture,
  glib,
  libxml2,
  dbus,
  gdk-pixbuf,
  networkmanager,
  harfbuzz,
  makeWrapper,
  wrapGAppsHook,
  which,
  xvfb-run,
  nixosTests,
  upower,
  glib-networking,
  gtk-layer-shell,
}:
let
  testDeps = [
    gtk3
    atk
    pango.out
    gdk-pixbuf
    harfbuzz
  ];
in
stdenv.mkDerivation rec {
  pname = "gjs";
  version = "1.76.2";

  outputs = [
    "out"
    "dev"
    "installedTests"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/gjs/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "sha256-99jJ1lPqb9eK/kpQcg4EaqK/wHj9pjXdEwZ90ZnGJdQ=";
  };

  patches = [
    # Hard-code various paths
    ./patches/gjs-fix-paths.patch

    # Allow installing installed tests to a separate output.
    ./patches/gjs-installed-tests-path.patch
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    makeWrapper
    wrapGAppsHook
    which # for locale detection
    libxml2 # for xml-stripblanks
    dbus # for dbus-run-session
    gobject-introspection
  ] ++ lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [ mesonEmulatorHook ];

  buildInputs = [
    cairo
    upower
    gnome.gnome-bluetooth
    glib-networking
    gtk-layer-shell
    networkmanager
    readline
    libsysprof-capture
    spidermonkey_102
  ];

  nativeCheckInputs = [ xvfb-run ] ++ testDeps;

  propagatedBuildInputs = [ glib ];

  mesonFlags = [
    "-Dinstalled_test_prefix=${placeholder "installedTests"}"
  ] ++ lib.optionals (!stdenv.isLinux || stdenv.hostPlatform.isMusl) [ "-Dprofiler=disabled" ];

  doCheck = !stdenv.isDarwin;

  postPatch =
    ''
      patchShebangs build/choose-tests-locale.sh
      substituteInPlace installed-tests/debugger-test.sh --subst-var-by gjsConsole $out/bin/gjs-console
    ''
    + lib.optionalString stdenv.hostPlatform.isMusl ''
      substituteInPlace installed-tests/js/meson.build \
        --replace "'Encoding'," "#'Encoding',"
    '';

  preCheck = ''
    # Our gobject-introspection patches make the shared library paths absolute
    # in the GIR files. When running tests, the library is not yet installed,
    # though, so we need to replace the absolute path with a local one during build.
    # We are using a symlink that will be overridden during installation.
    mkdir -p $out/lib $installedTests/libexec/installed-tests/gjs
    ln -s $PWD/libgjs.so.0 $out/lib/libgjs.so.0
    ln -s $PWD/installed-tests/js/libgimarshallingtests.so $installedTests/libexec/installed-tests/gjs/libgimarshallingtests.so
    ln -s $PWD/installed-tests/js/libgjstesttools/libgjstesttools.so $installedTests/libexec/installed-tests/gjs/libgjstesttools.so
    ln -s $PWD/installed-tests/js/libregress.so $installedTests/libexec/installed-tests/gjs/libregress.so
    ln -s $PWD/installed-tests/js/libwarnlib.so $installedTests/libexec/installed-tests/gjs/libwarnlib.so
  '';

  postInstall = ''
    installedTestsSchemaDatadir="$installedTests/share/gsettings-schemas/${pname}-${version}"
    mkdir -p "$installedTestsSchemaDatadir"
    mv "$installedTests/share/glib-2.0" "$installedTestsSchemaDatadir"
  '';

  postFixup = ''
    wrapProgram "$installedTests/libexec/installed-tests/gjs/minijasmine" \
      --prefix XDG_DATA_DIRS : "$installedTestsSchemaDatadir" \
      --prefix GI_TYPELIB_PATH : "${lib.makeSearchPath "lib/girepository-1.0" testDeps}"
  '';

  checkPhase = ''
    runHook preCheck
    xvfb-run -s '-screen 0 800x600x24' \
      meson test --print-errorlogs
    runHook postCheck
  '';

  separateDebugInfo = stdenv.isLinux;

  passthru = {
    tests = {
      installed-tests = nixosTests.installed-tests.gjs;
    };

    updateScript = gnome.updateScript {
      packageName = "gjs";
      versionPolicy = "odd-unstable";
    };
  };

  meta = {
    description = "JavaScript bindings for GNOME";
    homepage = "https://gitlab.gnome.org/GNOME/gjs/blob/master/doc/Home.md";
    license = lib.licenses.lgpl2Plus;
    maintainers = lib.teams.gnome.members;
    platforms = lib.platforms.unix;
  };
}
