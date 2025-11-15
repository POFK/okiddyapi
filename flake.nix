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
        strapiBackend = pkgs.buildNpmPackage {
          pname = "okiddyapi";
          version = "0.1.3";
          npmDepsHash = "sha256-I24pThx/Pial+/jx7iMUOrk5t32+eHJ8pyhOgDD1xZs=";

          src = ./.;
          npmLockfile = "package-lock.json"; # 或者 "package-lock.json" / "pnpm-lock.yaml"

          # Strapi 通常需要一个构建步骤来编译 Admin UI，
          # 即使你主要使用 API。这是 buildNpmPackage 的 build 脚本。
          # 确保你的 package.json 中有 "build" 脚本（通常是 strapi build）。
          npmBuildScript = "build";

          # Strapi 在运行时需要访问其配置文件、数据库和上传文件。
          # 'installPhase' 确保所有必需的文件（包括 Admin UI build 产物）
          # 被复制到输出目录（$out）。
          installPhase = ''
            # 复制 Node.js 模块（已经由 buildNpmPackage 处理）
            # 复制 Strapi 源代码和配置
            mkdir -p $out
            cp -r * $out/
          '';

          # 运行时依赖，Strapi 运行需要 Node.js
          runtimeDependencies = with pkgs; [
            nodejs_22
          ];

          # 打包完成后，你可能需要一个包装脚本来启动服务
          # 这将创建一个可执行的脚本 $out/bin/strapi-backend
          # 运行 'npm start' 或 'node server.js' (取决于你的 Strapi 配置)
          # 对于标准的 Strapi 项目，它会查找 package.json 中的 "start" 脚本
          doJailbreak = true; # 可能需要，以防止 Node.js 内部路径引用问题

          # 环境变量：Strapi 需要知道它在生产环境中运行
          NODE_ENV = "production";
        };

      in
      {
        packages.okiddyapi = strapiBackend;
        defaultPackage = strapiBackend;

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
