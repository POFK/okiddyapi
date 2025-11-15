{
  config,
  lib,
  pkgs,
  ...
}:
let
  pname = "okiddyapi";
  version = "0.1.3";
  npmDepsHash = "sha256-I24pThx/Pial+/jx7iMUOrk5t32+eHJ8pyhOgDD1xZs=";
  node = pkgs.nodejs_22;
in
pkgs.buildNpmPackage {
  inherit pname version npmDepsHash;

  src = ./.;
  npmLockfile = "package-lock.json"; # 或者 "package-lock.json" / "pnpm-lock.yaml"
  # Strapi 通常需要一个构建步骤来编译 Admin UI，
  # 即使你主要使用 API。这是 buildNpmPackage 的 build 脚本。
  # 确保你的 package.json 中有 "build" 脚本（通常是 strapi build）。
  npmBuildScript = "build";

  postInstall = ''
    mkdir -p $out/bin
    exe="$out/bin/${pname}"
    lib="$out/lib/node_modules/${pname}"
    cp -r ./dist $lib
    touch $exe
    chmod +x $exe
    echo "
        #!/usr/bin/env bash
        cd $lib
        ${node}/bin/npm run start" > $exe
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
}
