module shell

struct CmdOption {
    abbr        string
    full        string
    vari        string
    defa        string
    desc        string
}

// Assignment type option
fn (long_option CmdOption) options(args []string) string {
        mut flags := ''
                flags = long_option.defa
        for i, v in args {
                if v in [long_option.abbr, long_option.full] {
                    if i + 1 < args.len && args[i + 1][0] != 45 {
                            flags = args[i + 1]
                    }
                }
        }
        return flags
}

// Defined option
fn (long_option CmdOption) set_options(args []string) bool {
        mut flags := false
        for v in args {
                if v in [long_option.abbr, long_option.full] {
                        flags = true
                }
        }
        return flags
}

// for abr find option's.
fn find_options(args []string, long_options []CmdOption, abr string ) string {
        mut flags := ''
        for long_option in long_options {
                if long_option.abbr == abr || long_option.full == abr {
                        flags = long_option.options( args )
                }
        }
        return flags
}

// find abr belongs to options?
fn is_options(args []string, long_options []CmdOption, abr string ) bool {
        mut flags := false
        for long_option in long_options {
                if abr == long_option.abbr || abr == long_option.full {
                        flags = true
                }
        }
        return flags
}

fn return_args(args []string) string {
        mut flags := ''
        for i in args[1..] {
                flags += i
        }
        return flags
}
