#run {
    #import "Compiler";
    #import "Basic";
    #import "String";
    Autorun :: #import "Autorun";

    set_build_options_dc(.{do_output = false});

    w := compiler_create_workspace("Input Workspace");

    options := get_build_options(w);
    copy_commonly_propagated_fields(get_build_options(), *options);
    options.output_executable_name = "input";
    set_build_options(options, w);

    compiler_begin_intercept(w);
    add_build_file("main.jai", w);

    while true {
        message := compiler_wait_for_message();
        if message.kind == {
        case .COMPLETE;
            mc := cast(*Message_Complete)message;
            if mc.error_code != .NONE {
                exit(1);
            }
            break;
        }
    }
    compiler_end_intercept(w);
    print("\n");
    Autorun.run_build_result_of_workspace(w);
}
