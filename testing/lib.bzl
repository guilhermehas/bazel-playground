def _lib_impl(ctx):
    print(ctx.files.fgroup)
    print(ctx.files.agda_lib)
    fgroup = ctx.files.fgroup
    agda_lib = ctx.files.agda_lib

    out = ctx.actions.declare_directory(ctx.attr.name)
    ctx.actions.run_shell(
        inputs = ctx.files.agda_lib,
        command = "cp -r {input_dir}/* {out_path}".format(
            input_dir = ctx.files.agda_lib[0].path,
            out_path = out.path,
        ),
        outputs = [out],
    )

    return [
        DefaultInfo(files = depset([out]))
    ]

lib = rule(
    _lib_impl,
    attrs = {
        "fgroup": attr.label_list(),
        "agda_lib": attr.label_list(),
    },
)

def _lib2_impl(ctx):
    out = [ctx.file.agda_lib] + ctx.files.agda_files
    return [
        DefaultInfo(files = depset(out))
    ]


lib2 = rule(
    _lib2_impl,
    attrs = {
        "agda_files": attr.label_list(
            allow_files = [".agda"],
        ),
        "agda_lib": attr.label(
            allow_single_file = [".agda-lib"],
        ),
    },
)

def _agda_exe_impl(ctx):
    files = ctx.files.agda_libs
    file = files[0]

    out = ctx.actions.declare_file(ctx.attr.name)
    ctx.actions.run_shell(
        inputs = files,
        command = "cat {inp_path} >> {output_path}".format(
            inp_path = file.path,
            output_path = out.path,
        ),
        outputs = [out],
    )

    return [
        DefaultInfo(files = depset([out]))
    ]
    

agda_exe = rule(
    _agda_exe_impl,
    attrs = {
        "agda_libs": attr.label_list(
            allow_files = [".agda", ".agda-lib"],
        )
    }
)