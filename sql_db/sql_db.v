module sql_db

import db.sqlite
import log

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
        pid             int                 @[primary; sql:serial]
        id              string
        email           string
        passwd          string
        whoami          string
        task            []PersonalFlag      @[fkey: 'parents_id']
}

// Personal-task对照表.
@[table: 'personal_flag']
pub struct PersonalFlag {
    pub:
        parents_id          int
        parents_task        int
        complete            string
}


// 题目信息

@[table: 'task']
pub struct Task{
    pub:
        tid        int              @[primary; sql:serial]
        type_text  string
        flag       []PostFlag       @[fkey: 'parents_task']
        task       []PersonalFlag   @[fkey: 'parents_task']
        name       string
        diff       string
        intro      string
        score      int
        container  bool
}

@[table: 'post_flag']
pub struct PostFlag {
        parents_task    int
    pub mut:
        flag            string
}

struct StatusReturn {
    pub:
        return_bool         bool
        find_passwd         bool
        id_check            []Personal
}

struct Type{
    pub:
        name        string
        type_text   []Task
}



pub fn create_db(db sqlite.DB) {
    sql db {
        create table Personal
        create table Task
        create table PostFlag
        create table PersonalFlag
    } or {
        println('${log.warn_log}: 数据库创建失败, 可能已存在数据库: data.db')
    }
}



// 测试部分初始化函数

pub fn test_main_function(mut db sqlite.DB) {
    the_data := sql db {
        select from Task
    } or { []Task{} }

    if the_data.len != 0 {
        return
    }

    data := [
        Task{
                type_text  :    'crypto'
                flag       :    [
                                    PostFlag{flag : 'flag{test_1}'},
                                ]
                task       :    []PersonalFlag{}
                name       :    'ez_math'
                diff       :    'baby'
                intro      :    'test task'
                score      :    10
                container  :    false
        },

        Task{
                type_text  :    'crypto'
                flag       :    [
                                    PostFlag{flag : 'flag{test_2}'},
                                    PostFlag{flag : 'flag{test_3}'},
                                ]
                task       :    []PersonalFlag{}
                name       :    'mid_math'
                diff       :    'baby'
                intro      :    'test task'
                score      :    10
                container  :    false
        },
    
        Task{
                type_text  :    'web'
                flag       :    [
                                    PostFlag{flag : 'flag{test_4}'},
                                    PostFlag{flag : 'flag{test_5}'},
                                ]
                task       :    []PersonalFlag{}
                name       :    'ez_xss'
                diff       :    'baby'
                intro      :    'new task'
                score      :    10
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
}

