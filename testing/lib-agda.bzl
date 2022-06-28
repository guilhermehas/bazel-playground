AgdaInfo = provider(
    "Agda Infomation",
    fields={
        "name": "Name of library",
        "agda_lib": "Library file",
        "agda_files": "Agda files"
    })

def _agda_lib2_impl(ctx):
    return [
        AgdaInfo(
            name = ctx.attr.name,
            agda_files = depset(ctx.files.agda_files),
            agda_lib = ctx.file.agda_lib
        )
    ]


agda_lib2 = rule(
    _agda_lib2_impl,
    attrs = {
        "agda_files": attr.label_list(
            allow_files = [".agda"],
        ),
        "agda_lib": attr.label(
            allow_single_file = [".agda-lib"],
        ),
    },
)

def _agda_exe2_impl(ctx):
    agda_info = ctx.attr.agda_lib[AgdaInfo]
    out = agda_info.agda_files.to_list() + [agda_info.agda_lib]
    return [
        DefaultInfo(files = depset(out)),
        OutputGroupInfo(
            debug_files = depset(out),
        ),

    ]

agda_exe2 = rule(
    _agda_exe2_impl,
    attrs = {
        "agda_lib": attr.label(
            providers = [AgdaInfo],
        )
    }
)