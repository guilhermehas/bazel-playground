def _agda_impl(ctx):
    """Rule that just generates a file and returns a provider."""
    compiler = ctx.file.compiler
    inputs = ctx.files.inputs
    input = inputs[0]
    file_name = input.path
    html_name = input.basename[:-len(input.extension)] + "html"
    out = ctx.actions.declare_directory("html")
    ctx.actions.run(
        mnemonic = "agda",
        inputs = inputs,
        arguments = [ "--no-libraries", "-i", input.dirname, "--html", "--html-dir", out.path , file_name ],
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

def _agda_library_impl(ctx):
    inputs = ctx.files.inputs
    inp = inputs[0]
    out = ctx.actions.declare_directory(ctx.attr.name)

    ctx.actions.run_shell(
        inputs = inputs,
        command = "cp -r {input_dir}/* {out_path}".format(
            input_dir = inp.dirname,
            input_path = inp.path,
            out_path = out.path,
        ),
        outputs = [out],
    )

    return [
        DefaultInfo(files = depset([out]))
    ]

agda_library = rule(
    implementation = _agda_library_impl,
    attrs = {
        "inputs": attr.label_list(allow_files = [".agda", ".agdai", ".agda-lib"]),
    },
)