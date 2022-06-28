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

    filegroup(
        name = "agda-cub",
        srcs = ["cub"],
        visibility = ["//visibility:public"],
    )

    EOF_BUILD
  '';
}
