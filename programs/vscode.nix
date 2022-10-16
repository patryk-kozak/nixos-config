{
  config,
  pkgs,
  latest-nixpkgs,
  ...
}: let
  preConfiguredVscode = pkgs.vscode-with-extensions.override {
    vscodeExtensions =
      [
        latest-nixpkgs.vscode-extensions.arrterian.nix-env-selector
        pkgs.vscode-extensions.bbenoist.nix
        latest-nixpkgs.vscode-extensions.jnoortheen.nix-ide
      ]
      ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "theme-monokai-pro-vscode";
          publisher = "monokai";
          version = "1.1.18";
          sha256 = "0dg68z9h84rpwg82wvk74fw7hyjbsylqkvrd0r94ma9bmqzdvi4x";
        }
        {
          name = "markdown-all-in-one";
          publisher = "yzhang";
          version = "3.4.0";
          sha256 = "0ihfrsg2sc8d441a2lkc453zbw1jcpadmmkbkaf42x9b9cipd5qb";
        }
        {
          name = "code-spell-checker";
          publisher = "streetsidesoftware";
          version = "1.10.2";
          sha256 = "1ll046rf5dyc7294nbxqk5ya56g2bzqnmxyciqpz2w5x7j75rjib";
        }
        {
          name = "Go";
          publisher = "golang";
          version = "0.33.0";
          sha256 = "HPTRQYvSmlj88V3DZJx7JcSEHqk9QyxvOf5YK8n7qfE=";
        }
      ];
  };
in
  preConfiguredVscode
