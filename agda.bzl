def _agda_impl(ctx):
    """Rule that just generates a file and returns a provider."""
    compiler_path = "/home/guilherme/.nix-profile/bin/agda"
    compiler = ctx.files.compiler[0]
    inputs = ctx.files.inputs
    file_name = inputs[0].path
    # out = ctx.actions.declare_file(file_name)
    # out = ctx.actions.declare_directory("html")
    out4 = ctx.actions.declare_file("html/a.html")
    # out2 = ctx.actions.declare_file("external/simple_file/a.agdai")
    # out2 = ctx.actions.declare_file("a.agdai")
    print(inputs[0].path)
    print(inputs[0].short_path)
    print(file_name)
    # print(out.path)
    print(compiler.path)
    ctx.actions.run(
        mnemonic = "agda",
        inputs = inputs,
        arguments = [ "--no-libraries", "-i", inputs[0].dirname, "--html", "--html-dir", out4.dirname , file_name ],
        executable = compiler,
        outputs = [ out4 ],
    )
    # ctx.actions.run_shell(
    #     mnemonic = "agda2",
    #     inputs = inputs,
    #     arguments = [ "--no-libraries", "-i", inputs[0].dirname, "--html", "--html-dir", out4.dirname , file_name ],
    #     outputs = [out4],
    #     command = "%s $1 $2 $3 $4 $5 $6 $7" % compiler_path,
    # )

    print("HELLO2")
    return [
        DefaultInfo(files = depset([out4]), runfiles=ctx.runfiles(files=[out4]))
    ]

agda = rule(
    implementation = _agda_impl,
    attrs = {
        "inputs": attr.label_list(allow_files = [".agda"]),
        "compiler": attr.label(
            allow_single_file = True,
            cfg = "exec",
        ),
    },
)