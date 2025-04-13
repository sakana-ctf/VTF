module sql_db

import os
import vlog
import err_log
import db.sqlite
import shell { test_daemon }
import encoding.base64 { url_encode_str, url_decode_str }

fn connect(database string) sqlite.DB {
    mut db := sqlite.connect('./data/${database}.db')  or {
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

pub fn connect_db(set_nohup bool, args string, port int, database string) ?sqlite.DB {
    /* 
        todo:
        经过反复思考, 我认为还是需要引入cmd.CmdSet进行调用为益
        不然后续对启动内容进行编写容易引起调用灾难, 但是我懒, 
        所以先丢一个todo在这里, 等以后再慢慢替换过来.
    */
    mut db := sqlite.DB{}

    if !os.exists('./data/${database}.db') {

        id := os.input('Root id: ')
        email := os.input('Root email: ')
        passwd := os.input_password('Root password: ') or {
            panic(err)
        }

        db = connect(database)
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
        db = connect(database)
    }

    test_daemon(set_nohup, port)

    return db
}
