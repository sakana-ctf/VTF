module sql_db

import encoding.base64 { url_encode_str, url_decode_str }
import err_log
import log
import db.sqlite { DB }



// personal报错函数
fn personal_err() []Personal {
    println('${log.false_log}查询错误')
    return []Personal{}
}

// 登录检测
pub fn login_status(db DB, c_id string, c_pwd string) StatusReturn {
    id_check := sql db {
        select from Personal where id == url_encode_str(c_id) && passwd == err_log.sha256_str(c_pwd)
    } or { personal_err() }
    if id_check.len != 0 {
        return StatusReturn{true, false, id_check}
    } else {
        return StatusReturn{false, false, id_check}
    }
}

// 查询密码
pub fn select_passwd_db(db DB, email string, passwd string) StatusReturn {
    err_log.logs('${log.set_log}: email/id:${email} password:${passwd} 正在登录.')
    id_check := sql db {
        select from Personal where id == url_encode_str(email) || email == url_encode_str(email)
    } or { personal_err() }

    if id_check.len == 0 {
        return StatusReturn{true, false, id_check}
    }
    
    mut not_passwd := true

    for i in id_check {
        if i.passwd == err_log.sha256_str(passwd) {
            not_passwd = false
            err_log.logs('${log.true_log}: pid:${i.pid} 已登录.')
        }
    }
    return StatusReturn{false, not_passwd, id_check}
}

// ========================= 注册函数 =================================
// 注册检测
pub fn register_status(db DB, id string, email string, passwd string) bool {
    mut return_bool := false

    new_number := Personal{
        id      :   url_encode_str(id)
        email   :   url_encode_str(email)
        passwd  :   err_log.sha256_str(passwd)
        whoami  :   'member'
        task    :   []PersonalFlag{}
    }

    id_check := sql db {
        select from Personal where id == new_number.id || email == new_number.email
    } or { personal_err() }
    if id_check.len != 0 || new_number.id == '' {
        println('${log.false_log}: 检测到提交无效数据')
        return_bool = true
    }
    return return_bool
}

// 注册函数
pub fn register_db(db DB, id string, email string, passwd string) bool {
    mut return_bool := false

    mut personal_flag := []PersonalFlag{}
    tasks := sql db {select from Task} or { []Task{} }

    for i in tasks {
        personal_flag << PersonalFlag{ parents_task : i.tid, complete : unsolved }
    }

    println(personal_flag)

    new_number := Personal{
        id      :   url_encode_str(id)
        email   :   url_encode_str(email)
        passwd  :   err_log.sha256_str(passwd)
        whoami  :   'member'
        task    :   personal_flag
    }

    sql db {
        insert new_number into Personal
    } or {
        println("${log.false_log}: 存储数据出错${new_number}")
        return_bool = true
    }
    return return_bool
}

// ========================= 修改密码 =================================
// 
pub fn id_check(db DB, c_id string, oldpasswd string, newpasswd string) bool {
    id_check := sql db {
        select from Personal where id == c_id && passwd == err_log.sha256_str(oldpasswd)
    } or { personal_err() }
    if id_check.len != 0 {
        err_log.logs('Setting: ${c_id}将修改密码为:${newpasswd}')
        sql db {
            update Personal set passwd = newpasswd where id == c_id && passwd == oldpasswd is none
        } or { 
            err_log.logs('${log.false_log}: ${c_id}修改密码失败')
            return false
        }
        return true
    }
    return false
}





