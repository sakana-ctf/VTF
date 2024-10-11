module sql_db

import db.sqlite { DB }
import log
import err_log

// task报错函数
fn task_err() []Task {
    println('${log.false_log}查询错误')
    return []Task{}
}

// 题目数据更新

fn task_db(db DB, i string) []Task {
	return sql db {
        select from Task where type_text == i
    } or { task_err() }
}

pub fn build_task(db DB) []Type {
    mut list_of_type := []Type{}

    mut list := []string{}

    task := sql db {
        select from Task
    } or { task_err() }

    for i in task {
        if i.type_text in list {
            continue
        } else {
            list << i.type_text
        }
    }

    for i in list {
        list_of_type << Type{
                name        :   i
                type_text   :   task_db(db, i)
            }
    }
	return list_of_type
}

// 提交flag
pub fn post_flag(db DB, task_name string, flag string) bool {
    task_flag := sql db {
        select from Task where name == task_name
    } or { task_err() }

    // 这里修改不太对, 还有需要对控制进行私有化, 还挺麻烦的.

    if PostFlag{ flag: flag } in task_flag[0].flag {
        sql db {
            update Task set complete = '../image/complete.png' where name == task_name 
        } or { err_log.logs('Flag: ${flag}错误') }
        return false
    } else {
        err_log.logs('Flag: 修改出错')
    }
    return true
}

pub fn find_user(db DB, id string, pwd string) Personal {
    pid := sql db {
        select from Personal where id == id && passwd == pwd
    } or { personal_err() }
    return pid.first()
}