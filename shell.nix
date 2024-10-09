{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = [
    pkgs.texlive.combined.scheme-full
    pkgs.minikube
    pkgs.docker
    pkgs.docker-compose
    pkgs.kubectl
    pkgs.nodePackages_latest.pnpm
    pkgs.kubernetes-helm
    # (wrapHelm kubernetes-helm {
    #     plugins = with pkgs.kubernetes-helmPlugins; [
    #       helm-secrets
    #       helm-diff
    #       helm-s3
    #       helm-git
    #     ];
    #   })
  ];
}
