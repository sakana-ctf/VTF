module shell

import os

$if !windows {
    #include <unistd.h>
    #include <fcntl.h>   
} 

fn C.setsid() int
fn C.umask(mask u32) u32
fn C.chdir(path &char) int
fn C.open(path &char, flags int, ...) int
fn C.dup2(oldfd int, newfd int) int

//暂时使用c进行daemon的实现，之后应该换成v.
pub fn test_daemon(set_nohup bool, port int) {
    $if !windows {
        if set_nohup {
            println('[veb] Running app on http://localhost:${port}/')
            mut pid := os.fork()

            if pid < 0 {
                println("Error: create_daemon() first fork faild") 
                exit(1)
            }
            if pid > 0 {
                exit(0) 
            }

            sid := C.setsid()
            if sid < 0 {
                println("Error: create_daemon() setsid faild")
                exit(1)
            }

            pid = os.fork()
            if pid < 0 {
                println("Error: create_daemon() second fork faild")
                exit(1)
            }
            if pid > 0 {
                exit(0)
            }

            if C.chdir(c'./') < 0 {
                println("Error: create_daemon() chdir faild")
                exit(1)
            }
        
            C.umask(0)
            dev_null := C.open(c'/dev/null', C.O_RDWR)
            if dev_null < 0 {
                println("Error: create_daemon() open /dev/null faild")
                exit(1)
            }

            _ = C.dup2(dev_null, 0)
            _ = C.dup2(dev_null, 1)
            _ = C.dup2(dev_null, 2)

            if dev_null > 2 {
                C.close(dev_null)
            }
        }
    }
}

// 等慢慢提pr了, 之后如果可行的话再使用.
fn daemon() {
	/*
		Todo:
		先用着test_daemon, 
		之后应该是要重新拿这个函数换掉那段的.
	*/
   pid := os.fork()
    if pid < 0 {
        println("Error: create_daemon() first fork faild") 
        exit(1)
    }
    if pid > 0 {
        println("Error: create_daemon() setsid faild")
        exit(1)
    }

    /*
    if os.setsid() < 0 {
        println("Error: create_daemon() second fork faild")
        exit(1)
    }
    */

    // 关闭标准流
    os.fd_close(0)
    os.fd_close(1)
    os.fd_close(2)
    // 重定向到 /dev/null（可选）
	/*
    os.open("/dev/null", os.O_RDONLY)  // stdin
    os.open("/dev/null", os.O_WRONLY)  // stdout
    os.open("/dev/null", os.O_WRONLY)  // stderr
	*/
    // 更改工作目录
    os.chdir("/") or { panic(err) }
    //os.umask(0)
}

