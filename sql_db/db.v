module sql_db

import db.sqlite

pub fn connect_db() sqlite.DB {
    mut db := sqlite.connect('./data.db')  or {
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


