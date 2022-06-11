let
    pkgs = import <nixpkgs> { config = {}; overrides = []; };
    agda = pkgs.agda;
in
pkgs.buildEnv {
    name = "simple-file";
    extraOutputsToInstall = ["out" "bin" "lib"];
    paths = [ agda ];
    postBuild = ''

    mkdir -p $out

    cat >$out/BUILD.bazel <<'EOF_BUILD'
    load('agda.bzl', 'agda')

    filegroup(
        name = "agdac",
        srcs = ["bin/agda"],
        visibility = ["//visibility:public"],
    )

    agda(
        name = "agda-nix",
        compiler = ":agdac",
        inputs = ["a.agda"],
        visibility = ["//visibility:public"],
    )
    EOF_BUILD
  '';
}