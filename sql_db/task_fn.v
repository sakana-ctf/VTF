module sql_db

import db.sqlite { DB }
import log
import err_log

const solved = '../image/complete.webp'
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
pub fn post_flag(db DB, ip string, tid int, flag string, pid int) bool {
    err_log.logs('${log.set_log}ip:${ip} pid:${pid} 提交 tid:${tid} flag:${flag}')
    task_flag := sql db {
        select from Task where tid == tid 
    } or { task_err() }

    // 除了防止tid乱取还有防删除题目, 超出界限的风险.
    if task_flag.len == 0 {
        return false
    }

    if PostFlag{ parents_task: tid, flag: flag } in task_flag.first().flag {
        new_score := task_flag.first().score - 300 / (task_flag.first().max_score - task_flag.first().score + 10)
        sql db {
            update PersonalFlag set complete = solved where parents_task == tid  && parents_id == pid
            update Task set score = new_score where tid == tid
        } or { err_log.logs('Flag: ${flag}错误') }
        err_log.logs('${log.true_log}ip:${ip} pid:${pid} 提交正确 tid:${tid} flag:${flag}')
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