let
    pkgs = import <nixpkgs> { config = {}; overrides = []; };
    cubical = pkgs.agdaPackages.cubical;
in
pkgs.buildEnv {
    name = "cubical";
    extraOutputsToInstall = [];
    paths = [];
    postBuild = ''

    mkdir -p $out
    
    cp -r ${cubical} $out/cub

    cat >$out/BUILD.bazel <<'EOF_BUILD'
    load('agda.bzl', 'agda_library')

    filegroup(
        name = "agda-cub-files",
        srcs = ["cub"],
    )

    agda_library(
        name = "agda-cub",
        inputs = [":agda-cub-files"],
        visibility = ["//visibility:public"],
    )

    EOF_BUILD
  '';
}
