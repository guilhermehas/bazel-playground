def _myrule_impl(ctx):
    """Rule that just generates a file and returns a provider."""
    out = ctx.actions.declare_file(ctx.label.name + ".out")
    ctx.actions.write(out, "abc")
    return [
        DefaultInfo(files = depset([out]), runfiles=ctx.runfiles(files=[out]))
    ]

myrule = rule(
    implementation = _myrule_impl,
)

def _myrule_validation_impl(ctx):
    """Rule for instantiating myrule_validator.sh.template for a given target."""
    out = ctx.actions.declare_file(ctx.label.name + ".sh")
    target = ctx.file.target
    ctx.actions.expand_template(output = out,
                                template = ctx.file.template,
                                is_executable = True,
                                substitutions = {
                                    "%TARGET%": target.short_path,
                                })

    return [
        DefaultInfo(executable = out, runfiles=ctx.runfiles(files=[target]))
    ]

myrule_validation = rule(
    implementation = _myrule_validation_impl,
    attrs = {
        "target" : attr.label(allow_single_file=True),
        "template" : attr.label(allow_single_file=True)
    },
    executable = True,
)

def _myrule_validation_test_impl(ctx):
    """Rule for instantiating myrule_validator.sh.template for a given target."""
    exe = ctx.outputs.executable
    target = ctx.file.target
    ctx.actions.expand_template(output = exe,
                                template = ctx.file._script,
                                is_executable = True,
                                substitutions = {
                                "%TARGET%": target.short_path,
                                })
    # This is needed to make sure the output file of myrule is visible to the
    # resulting instantiated script.
    return [DefaultInfo(runfiles=ctx.runfiles(files=[target]))]

myrule_validation_test = rule(
    implementation = _myrule_validation_test_impl,
    attrs = {"target": attr.label(allow_single_file=True),
             "_script": attr.label(allow_single_file=True,
                                   default=Label("//:my_template"))},
    test = True,
)
