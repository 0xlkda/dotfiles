{
  description = "alex dotfiles — Home Manager (standalone) + dev shell";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager }:
    let
      system = "aarch64-darwin";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      homeConfigurations.alex = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ ./home.nix ];
      };

      devShells.${system}.default = pkgs.mkShell {
        packages = [ pkgs.nodejs ];
        shellHook = ''export PATH="$PWD/node_modules/.bin:$PATH"'';
      };
    };
}
