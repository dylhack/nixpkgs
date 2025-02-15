{ buildPackages, callPackage, stdenv, runCommand }@prev:

{ rustc, cargo, stdenv ? prev.stdenv, ... }:

rec {
  rust = {
    inherit rustc cargo;
  };

  fetchCargoTarball = buildPackages.callPackage ../../../build-support/rust/fetch-cargo-tarball {
    git = buildPackages.gitMinimal;
    inherit cargo;
  };

  buildRustPackage = callPackage ../../../build-support/rust/build-rust-package {
    git = buildPackages.gitMinimal;
    inherit stdenv cargoBuildHook cargoCheckHook cargoInstallHook cargoNextestHook cargoSetupHook
      fetchCargoTarball importCargoLock rustc;
  };

  importCargoLock = buildPackages.callPackage ../../../build-support/rust/import-cargo-lock.nix { inherit cargo; };

  rustcSrc = callPackage ./rust-src.nix {
    inherit runCommand rustc;
  };

  rustLibSrc = callPackage ./rust-lib-src.nix {
    inherit runCommand rustc;
  };

  # Hooks
  inherit (callPackage ../../../build-support/rust/hooks {
    inherit stdenv cargo rustc;
  }) cargoBuildHook cargoCheckHook cargoInstallHook cargoNextestHook cargoSetupHook maturinBuildHook bindgenHook;
}
