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
        nodejs-version = 22;
        pname = "okiddyapi";
        version = "0.1.3";
        npmDepsHash = "sha256-I24pThx/Pial+/jx7iMUOrk5t32+eHJ8pyhOgDD1xZs=";
        pkgs = nixpkgs.legacyPackages.${system};
        lib = pkgs.lib;
        strapiApp = pkgs.callPackage ./. {
          inherit
            pkgs
            lib
            nodejs-version
            pname
            version
            npmDepsHash
            ;
        };

      in
      {
        defaultPackage = strapiApp;
        packages.okiddyapi = strapiApp;

        # Note: Don not use it, use the Dockerfile. The following docker
        # image is not optimized
        # The .#docker-image package for 'nix build'. This makes sense if the
        # flake provides only one package or there is a clear "main"
        # package.
        packages.docker-image = pkgs.dockerTools.buildImage {
          name = pname;
          tag = "v${version}";
          copyToRoot = pkgs.buildEnv {
            name = "image-root";
            paths = [
              self.packages.${system}.okiddyapi
              pkgs.bash
              pkgs.coreutils-full
            ];
            pathsToLink = [
              "/bin"
              "/lib"
              "/share"
            ];
          };
        };

        # 可选：一个开发 shell，包含 Node.js、yarn/npm 等工具
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            (pkgs."nodejs_${toString nodejs-version}")
            yarn
            pnpm
          ];
        };
      }
    );
}
