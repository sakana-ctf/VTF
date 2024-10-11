module sql_db

import db.sqlite

/* 这里会有一次很严重的资源浪费,
 * 我希望能有办法在不造成调用冲突时能避免浪费.
 * db := connect_db()
*/
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


