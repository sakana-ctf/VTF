module sql_db

import db.sqlite { DB }
import vlog
import err_log

const solved = '../image/complete.webp'
const unsolved = '../image/incomplete.png'

// challenge报错函数
fn challenge_err() []Task {
    println('${vlog.false_log}查询错误')
    return []Task{}
}

// 题目数据更新

fn challenge_db(db DB, i string) []Task {
	return sql db {
        select from Task where type_text == i
    } or { challenge_err() }
}

pub fn build_challenge(db DB) []Type {
    mut list_of_type := []Type{}

    mut list := []string{}

    challenge := sql db {
        select from Task
    } or { challenge_err() }

    for i in challenge {
        if i.type_text in list {
            continue
        } else {
            list << i.type_text
        }
    }

    for i in list {
        list_of_type << Type{
                name        :   i
                type_text   :   challenge_db(db, i)
            }
    }
	return list_of_type
}

// 提交flag
pub fn post_flag(db DB, ip string, tid int, flag string, pid int) bool {
    err_log.logs('${vlog.set_log}ip:${ip} pid:${pid} 提交 tid:${tid} flag:${flag}')
    challenge_flag := sql db {
        select from Task where tid == tid 
    } or { challenge_err() }

    // 除了防止tid乱取还有防删除题目, 超出界限的风险.
    if challenge_flag.len == 0 {
        return false
    }

    if PostFlag{ parents_challenge: tid, flag: flag } in challenge_flag.first().flag {
        new_score := challenge_flag.first().score - 300 / (challenge_flag.first().max_score - challenge_flag.first().score + 10)
        sql db {
            update PersonalFlag set complete = solved where parents_challenge == tid  && parents_id == pid
            update Task set score = new_score where tid == tid
        } or { err_log.logs('Flag: ${flag}错误') }
        err_log.logs('${vlog.true_log}ip:${ip} pid:${pid} 提交正确 tid:${tid} flag:${flag}')
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
