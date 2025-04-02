module sql_db

import db.sqlite
import vlog

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
        challenge            []PersonalFlag      @[fkey: 'parents_id']
}

// Personal-challenge对照表.
@[table: 'personal_flag']
pub struct PersonalFlag {
    pub:
        parents_id          int
        parents_challenge        int
        complete            string
}


// 题目信息

@[table: 'challenge']
pub struct Task{
    pub:
        tid        int              @[primary; sql:serial]
        type_text  string
        flag       []PostFlag       @[fkey: 'parents_challenge']
        challenge       []PersonalFlag   @[fkey: 'parents_challenge']
        name       string
        diff       string
        intro      string
        max_score  int
        score      int
        container  bool
}

@[table: 'post_flag']
pub struct PostFlag {
        parents_challenge    int
    pub mut:
        flag            string
}

@[table: 'black_list']
struct BlackList {
    pub:
        ip          string             @[primary]
        id          []BlackId          @[fkey: 'id']
}

// 我们有理由怀疑作弊者不止使用了一个账号.

@[table: 'black_name']
struct BlackId {
    id          int
    name        string
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



fn create_db(db sqlite.DB) {
    sql db {
        create table Personal
        create table Task
        create table PostFlag
        create table PersonalFlag
    } or {
        println('${vlog.warn_log}: 数据库创建失败, 可能已存在数据库: data.db')
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
                type_text  :    'Crypto'
                flag       :    [
                                    PostFlag{flag : 'vyctf{adwa_is_the_best_crypto_player}'},
                                ]
                challenge       :    []PersonalFlag{}
                name       :    'fast_attack'
                diff       :    'normal'
                intro      :    'basectf的精神延续\n出题人:sudopacman\n附件:https://wwtk.lanzoum.com/i44iq2dppize\n远程环境:139.155.139.109:10000'
                max_score  :    300
                score      :    300
                container  :    false
        },

        Task{
                type_text  :    'Crypto'
                flag       :    [
                                    PostFlag{flag : 'vyctf{0010011100000101010011100001101111110101011001000101011111101001}'},
                                ]
                challenge       :    []PersonalFlag{}
                name       :    "Pell Company's A-level products"
                diff       :    'normal'
                intro      :    '我想拿它来做hash\n出题人:adwa\n附件:https://wwtk.lanzoum.com/iNvgK2dpql9c'
                max_score  :    300
                score      :    300
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

