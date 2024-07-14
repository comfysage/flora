[private]
default:
  @just --list --unsorted

boot *args: (builder "boot" args)
test *args: (builder "test" args)
switch *args: (builder "switch" args)

build pkg:
  nix build .#{{pkg}} --log-format internal-json -v |& nom --json

iso image: (build "images.{{image}} -o {{image}}")

[private]
verify *args:
  nix-store --verify {{args}}

repair: (verify "--check-contents --repair")

clean:
  @sudo true
  nix-collect-garbage --delete-older-than 3d
  nix store optimise

check:
  nix flake check

update *input:
  nix flake update {{input}} --refresh

# setup our nixos and darwin builder
[private]
[macos]
builder command *args: verify
  darwin-rebuild {{command}} --flake . {{args}} |& nom

[private]
[linux]
builder command *args: verify
  sudo nixos-rebuild {{command}} --flake . {{args}} |& nom
