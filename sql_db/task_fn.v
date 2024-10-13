module sql_db

import db.sqlite { DB }
import log
import err_log

const solved = '../image/complete.png'
const unsolved = '../image/incomplete.png'

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
pub fn post_flag(db DB, tid int, flag string, pid int) bool {
    err_log.logs('${log.set_log}pid:${pid} 提交 tid:${tid} flag:${flag}')
    task_flag := sql db {
        select from Task where tid == tid 
    } or { task_err() }

    // 除了防止tid乱取还有防删除题目, 超出界限的风险.
    if task_flag.len == 0 {
        return false
    }

    // 这里修改不太对, 还有需要对控制进行私有化, 还挺麻烦的.
    if PostFlag{ parents_task: tid, flag: flag } in task_flag.first().flag {
        sql db {
            update PersonalFlag set complete = solved where parents_task == tid  && parents_id == pid
        } or { err_log.logs('Flag: ${flag}错误') }
        return true
    } else {
        err_log.logs('Flag: 修改出错')
    }
    return false
}

pub fn find_user(db DB, id string, pwd string) Personal {
    pid := sql db {
        select from Personal where id == id && passwd == err_log.sha256_str(pwd)
    } or { personal_err() }
    return pid.first()
}