{
  lib,
  pkgs,
  config,
  dream2nix,
  nodejsVersion ? 20,
  ...
}:
let
  tag = "v${config.version}";
  nodejs = (pkgs."nodejs_${toString nodejsVersion}");
in
{
  imports = [
    dream2nix.modules.dream2nix.nodejs-package-lock-v3
    dream2nix.modules.dream2nix.nodejs-granular-v3
  ];

  mkDerivation.src = lib.cleanSource ./.;

  deps =
    { nixpkgs, ... }:
    {
      inherit (nixpkgs) stdenv fetchFromGitHub;
      nodejs = nodejs;
      # Strapi 的 sharp 依赖通常需要这些系统库
      vips = nixpkgs.vips;
      pkg-config = nixpkgs.pkg-config;
      python3 = nixpkgs.python3;
      gcc = nixpkgs.gcc;
    };

  mkDerivation = {
    nativeBuildInputs = [
      config.deps.pkg-config
      config.deps.python3
    ];
    buildInputs = [
      config.deps.vips
      config.deps.gcc
    ];
  };

  nodejs-package-lock-v3 = {
    packageLockFile = "${config.mkDerivation.src}/package-lock.json";
  };

  mkDerivation.postInstall = ''
    mkdir -p $out/bin
    exe="$out/bin/${config.name}"
    lib="$out/lib/node_modules/${config.name}"
    touch $exe
    echo "#!/usr/bin/env ${pkgs.bash}/bin/bash
    cd $lib
    exec ${nodejs}/bin/npm start" > $exe
    chmod +x $exe
  '';

  mkDerivation.meta = {
    description = "A strapi based api backend for my website";
    homepage = "https://github.com/POFK/okiddyapi";
    license = lib.licenses.mit;
    maintainers = [ "txmao" ];
    platforms = lib.platforms.all;
  };

}
