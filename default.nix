{
  config,
  lib,
  pkgs,
  nodejs-version ? 22,
  pname ? "okiddyapi",
  version ? "0.0.0",
  npmDepsHash ? "",
  ...
}:
let
  tag = "v${version}";
  nodejs = (pkgs."nodejs_${toString nodejs-version}");
  buildInputs = [
    nodejs
    pkgs.nodePackages_latest.pnpm
  ];
  nativeBuildInputs = buildInputs;
in
pkgs.buildNpmPackage {
  inherit
    pname
    version
    npmDepsHash
    buildInputs
    nativeBuildInputs
    ;

  src = ./.;
  npmLockfile = "package-lock.json"; # 或者 "package-lock.json" / "pnpm-lock.yaml"

  postInstall = ''
    mkdir -p $out/bin
    exe="$out/bin/${pname}"
    lib="$out/lib/node_modules/${pname}"
    cp -r ./dist $lib
    touch $exe
    echo "#!/usr/bin/env ${pkgs.bash}/bin/bash
    cd $lib
    exec ${nodejs}/bin/npm start" > $exe
    chmod +x $exe
  '';

  meta = {
    description = "A strapi based api backend for my website";
    changelog = "https://github.com/POFK/okiddyapi/releases/tag/${tag}";
    homepage = "https://github.com/POFK/okiddyapi";
    license = lib.licenses.mit;
    maintainers = "txmao";
    platforms = lib.platforms.all;
  };
}
