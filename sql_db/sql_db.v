module sql_db

import db.sqlite
import vlog
import time

/************************************
 * todo: 这里应该重新限制public的权限
 * 但是没时间自己做.
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
        challenge       []PersonalFlag      @[fkey: 'parents_id']
}

// Personal-challenge对照表.
@[table: 'personal_flag']
pub struct PersonalFlag {
    pub:
        parents_id          int
        parents_challenge   int
        complete            string
        kill_time           time.Time
}


// 题目信息

@[table: 'challenge']
pub struct Task{
    pub:
        tid        int              @[primary; sql:serial]
        type_text  string
        flag       []PostFlag       @[fkey: 'parents_challenge']
        challenge  []PersonalFlag   @[fkey: 'parents_challenge']
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

pub struct Type{
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

