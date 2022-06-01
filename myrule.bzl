def _myrule_impl(ctx):
    """Rule that just generates a file and returns a provider."""
    out = ctx.actions.declare_file(ctx.label.name + ".out")
    ctx.actions.write(out, "abc")
    return [
        DefaultInfo(files = depset([out]))
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
