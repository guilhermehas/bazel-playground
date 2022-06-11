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