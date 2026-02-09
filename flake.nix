let
  pkgs = import <nixpkgs> {};
  frameworks = pkgs.darwin.apple_sdk.frameworks;
in 
  pkgs.mkShell {
    nativeBuildInputs = with pkgs.buildPackages; [ nodejs ];
    buildInputs = with pkgs.buildPackages; [
    ];
    shellHook = '' 
      export PATH="node_modules/.bin:$PATH"
    '';
  }
