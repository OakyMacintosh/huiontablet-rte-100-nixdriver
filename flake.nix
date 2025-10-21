{
  description = "Flake to package Huion Inspiroy RTE-100 driver from Huion .deb";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in {
      packages.${system}.huion-driver = pkgs.stdenv.mkDerivation rec {
        pname = "huion-driver";
        version = "15.0.0.162";

        src = pkgs.fetchurl {
          url = "https://driverdl.huion.com/driver/Linux/HuionTablet_LinuxDriver_v15.0.0.162.x86_64.deb";
          sha256 = "041h2znz9x32h5f9bgrbp5fg66q04d85945al2jbwq2l8q39nfqm";
        };

        nativeBuildInputs = [ pkgs.dpkg pkgs.autoPatchelfHook ];

        buildInputs = [
          pkgs.libusb1
          pkgs.xorg.libX11
          pkgs.xorg.libXtst
          pkgs.xorg.libXrandr
          pkgs.gtk3
          pkgs.libgcrypt
          pkgs.libgpg-error
          pkgs.e2fsprogs    # for libcom_err.so.2
          pkgs.krb5         # for libkrb5.so.3, libgssapi_krb5.so.2
        ];

        unpackPhase = ''
          mkdir extract
          dpkg-deb -x $src extract
        '';

        installPhase = ''
          mkdir -p $out
          cp -r extract/* $out/
        '';

        dontPatchELF = false;
        dontStrip = true;

        meta = with pkgs.lib; {
          description = "Huion Inspiroy RTE-100 driver (Huion official .deb)";
          homepage = "https://www.huion.com";
          license = licenses.unfreeRedistributable;
          platforms = [ "x86_64-linux" ];
          maintainers = [ ];
        };
      };

      defaultPackage.${system} = self.packages.${system}.huion-driver;
    };
}

