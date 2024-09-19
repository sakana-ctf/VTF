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

// 未启用, 每次出题目时自动添加, 等我想想怎么实现
@[table: 'personal_flag']
pub struct PersonalFlag {
    pub:
    id         string
    tid        int
    complete   string
}


// 题目信息

@[table: 'task']
pub struct Task{
    //tid       int
    pub:
    type_text  string
    flag       string
    name       string
    diff       string
    intro      string
    complete   string
    container  bool
}

// 未启用, 这里需要对每个表进行查询, 我觉得会不会有点太复杂了?
@[table: 'task_flag']
pub struct TaskFlag {
    pub:
    tid        string
    flag       string
}

// 测试部分初始化函数

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
