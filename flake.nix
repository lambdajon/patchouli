{
  description = "Telegram bot assistant for @haskell-uz community";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }: flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs { localSystem = { inherit system; }; };
    in
    {
      devShells.default = pkgs.mkShell ({
        buildInputs = with pkgs;
          let
            hpkgs = haskell.packages.ghc94;
          in
          [
            haskell.compiler.ghc94
            hpkgs.haskell-language-server
            hpkgs.hls-cabal-plugin
            hpkgs.hls-cabal-fmt-plugin
            hpkgs.hls-eval-plugin
            hpkgs.cabal-fmt
            hpkgs.fourmolu
            hpkgs.hlint
            cabal-install
            zlib
          ];
      });
    }
  );
}
