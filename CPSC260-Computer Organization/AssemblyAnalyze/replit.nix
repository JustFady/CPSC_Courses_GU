{ pkgs }: {
    deps = [
      pkgs.lf
        pkgs.nasm
        pkgs.bashInteractive
        pkgs.man
    ];
}