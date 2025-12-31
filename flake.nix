{
  description = "A Strapi API backend packaged with Nix Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    dream2nix.url = "github:nix-community/dream2nix";
    flake-utils.url = "github:numtide/flake-utils";

  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      dream2nix,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        nodejsVersion = 20;
        pname = "okiddyapi";
        version = "0.1.3";
        pkgs = nixpkgs.legacyPackages.${system};
        lib = pkgs.lib;
        strapiApp = dream2nix.lib.evalModules {
          packageSets.nixpkgs = nixpkgs.legacyPackages.${system};
          specialArgs = {
            nodejsVersion = nodejsVersion;
          };
          modules = [
            # Import our actual package definiton as a dream2nix module from ./default.nix
            ./default.nix
            {
              name = pname;
              version = version;
            }
            {
              # Aid dream2nix to find the project root. This setup should also works for mono
              # repos. If you only have a single project, the defaults should be good enough.
              paths.projectRoot = ./.;
              # can be changed to ".git" or "flake.nix" to get rid of .project-root
              paths.projectRootFile = "flake.nix";
              paths.package = ./.;
            }
          ];
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
        #packages.docker-image = pkgs.dockerTools.buildImage {
        #  name = pname;
        #  tag = "v${version}";
        #  copyToRoot = pkgs.buildEnv {
        #    name = "image-root";
        #    paths = [
        #      self.packages.${system}.okiddyapi
        #      pkgs.bash
        #      pkgs.coreutils-full
        #    ];
        #    pathsToLink = [
        #      "/bin"
        #      "/lib"
        #      "/share"
        #    ];
        #  };
        #};

        # 可选：一个开发 shell，包含 Node.js、yarn/npm 等工具
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            (pkgs."nodejs_${toString nodejsVersion}")
            yarn
            pnpm
          ];
        };
      }
    );
}
