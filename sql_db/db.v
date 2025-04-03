module sql_db

import os
import vlog
import err_log
import db.sqlite
import encoding.base64 { url_encode_str, url_decode_str }

fn connect() sqlite.DB {
    mut db := sqlite.connect('data.db')  or {
        println('Error: sqlite调用错误')
        panic(err)
    }
    db.synchronization_mode(sqlite.SyncMode.off) or {
        println('Error: data.db控制同步设置失败')
    }
    db.journal_mode(sqlite.JournalMode.memory) or {
        println('Error: data.db日志模式设置失败')
    }

    return db
}


#include <unistd.h>
#include <fcntl.h>
    
fn C.setsid() int
fn C.umask(mask u32) u32
fn C.chdir(path &char) int
fn C.open(path &char, flags int, ...) int
fn C.dup2(oldfd int, newfd int) int

pub fn create_daemon(path string, args string) {
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
    
    // close(dev_null)
    asm amd64 {
        mov rax, 3
        mov rdi, fd
        syscall
        ; 
        ; r (dev_null) as fd
    }
     os.system('./main ${args}')
}



pub fn connect_db(set_nohup bool, args string, port int) ?sqlite.DB {
    mut db := sqlite.DB{}

    if !os.exists('data.db') {

        id := os.input('Root id: ')
        email := os.input('Root email: ')
        passwd := os.input_password('Root password: ') or {
            panic(err)
        }

        db = connect()
        create_db(db)

        root_number := Personal{
            id      :   url_encode_str(id)
            email   :   url_encode_str(email)
            passwd  :   err_log.sha256_str(passwd)
            whoami  :   'root'
            challenge    :   []PersonalFlag{}
        }

        sql db {
            insert root_number into Personal
        } or {
            println("${vlog.false_log}: 无法注册root用户, 请重试.")
            os.rm('data.db') or { panic(err) }
            exit(1)
        }
    } else {
        db = connect()
    }

    /* 
        todo:
        目前使用了最原始的方法代替后台运行, 
        在windows下只提供了基础调试功能, 无法用于生产环境.
        未来考虑优化单独设置守护进程.
        这在后续是需要进行调整优化的.
    */


    if os.exists('start') {
        os.rm('start') or { panic(err) }
    } else {
        os.write_file('start', '') or { panic(err) }
        $if windows {
            os.system('.\\main ${args}')
        } $else {
            if set_nohup {
                println('[veb] Running app on http://localhost:${port}/')
                create_daemon('./main', '${args}')
            } else {
                os.system('./main ${args}')
            }
        }
        exit(1)
    }

    return db
}
