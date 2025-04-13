module shell

import os

pub fn start(version string) CmdSet {
	long_options := [
		CmdOption{
			abbr: '-h'
			full: '-help'
			vari: ''
			defa: ''
			//desc: 'Show basic help message and exit.'
			desc: '显示编码的基本信息并退出.'
		},
		CmdOption{
			abbr: '-v'
			full: '--version'
			vari: ''
			defa: ''
			//desc: 'Show version and exit.'
			desc: '显示版本号并退出.'
		},
		CmdOption{
			abbr: '-n'
			full: '--nohup'
			vari: ''
			defa: ''
			desc: '守护进程并将日志输出到nohup.out文件(目前只支持在linux设置).'
		},
		CmdOption{
			abbr: '-p'
			full: '--port'
			vari: '[int]'
			defa: '8080'
			desc: '设置端口号.'
		},
		CmdOption{
			abbr: '-d'
			full: '--database'
			vari: '[string]'
			defa: 'data'
			desc: '设置使用的数据库名.'
		},
	]

	mut args := os.args.clone()

	mut cmd_set := CmdSet {
		args	: return_args(args)
		port  	: long_options[3].options(args).int()
		database: long_options[4].options(args)
		nohup 	: false
		workers	: 3
	}

	// -h or --help
	if long_options[0].set_options(args) {
		help(long_options, version)
		exit(1)
	}

	// -v or --version
	if long_options[1].set_options(args) {
		println('VTF ${version}')
		exit(1)
	}

	// workers
	if args.len > 1 {
		if !is_options(args, long_options, args[1]) {
			cmd_set.workers = args[1].int()
		}
	}

	// -n or --nohup
	if long_options[2].set_options(args) {
		cmd_set.nohup = true
	}

	return cmd_set
}

// -h or --help
fn help(long_options []CmdOption, version string) {
    mut data := 'VTF ${version}, CTF competition platform based on the V programming language.'
    data += '\nBasic usages:'
	data += '\n 运行程序:\tmain [Options]'
    data += '\n 运行程序(设置线程数):\tmain [walkers] [Options]'
    data += '\nOptions:'
    println(data)

    for v in long_options {
        data = ' ${v.abbr}, ${v.full} ${v.vari}'
        data_len := data.len
        for _ in 0..(5 - (data_len / 8)) {
            data += '\t'
        }
        if (data_len % 8) == 0 {
            data += '\t'
        }
        data += '${v.desc}'
        println(data)
    }
}