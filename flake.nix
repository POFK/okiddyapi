{
  description = "A Strapi API backend packaged with Nix Flake";

  inputs = {
    #nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        lib = pkgs.lib;
        strapiApp = pkgs.callPackage ./. {
          inherit pkgs lib;
        };

      in
      {
        packages.okiddyapi = strapiApp;
        defaultPackage = strapiApp;

        # 可选：一个开发 shell，包含 Node.js、yarn/npm 等工具
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            nodejs_22
            yarn
            pnpm
          ];
        };
      }
    );
}
