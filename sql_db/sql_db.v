module sql_db

import db.sqlite

/************************************
 * emmmm, 这里应该重新限制public的权限
 * 但是现在还不是时候
************************************/

/*************
 * 数据库类型
*************/

// 登录信息

@[table: 'personal']
pub struct Personal {
    pub:
    id         string
    email      string
    passwd     string
    whoami     string
    score      int
}


@[table: 'task']
pub struct Task{
    pub:
    type_text  string
    flag       string
    name       string
    diff       string
    intro      string
    complete   string
    container  bool
}



pub fn test_main_function() {
    mut db := sqlite.connect('./data.db')  or {
        println('Error: sqlite调用错误')
        panic(err)
    }

    sql db {
        create table Task
    } or {
        println('Error: 创建Task失败')
    }

    data := [
        Task{
                type_text  :    'crypto'
                flag       :    'flag{test_1}'
                name       :    'ez_math'
                diff       :    'baby'
                intro      :    'test task'
                complete   :    '../image/complete.png'
                container  :    false
        },
    
        Task{
                type_text  :    'crypto'
                flag       :    'flag{test_2}'
                name       :    'mid_math'
                diff       :    'baby'
                intro      :    'new task'
                complete   :    '../image/incomplete.png'
                container  :    false
        }
    ]
    
    for i in data {
        sql db {
            insert i into Task
        } or {
        println("Error: 存储数据出错")
        }
    }


    db.close() or {
        println('Error: 关闭数据库出错')
        panic(err)
    }

}
