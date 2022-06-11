def _agda_impl(ctx):
    """Rule that just generates a file and returns a provider."""
    compiler = ctx.files.compiler[0]
    inputs = ctx.files.inputs
    file_name = inputs[0].path
    out = ctx.actions.declare_file("html/a.html")
    ctx.actions.run(
        mnemonic = "agda",
        inputs = inputs,
        arguments = [ "--no-libraries", "-i", inputs[0].dirname, "--html", "--html-dir", out.dirname , file_name ],
        executable = compiler,
        outputs = [ out ],
    )

    return [
        DefaultInfo(files = depset([out]), runfiles=ctx.runfiles(files=[out]))
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