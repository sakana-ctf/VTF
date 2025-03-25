module sql_db

import encoding.base64 { url_encode_str, url_decode_str }
import err_log
import vlog
import db.sqlite { DB }

// personal报错函数
fn personal_err() []Personal {
    println('${vlog.false_log}查询错误')
    return []Personal{}
}

// 黑名单personal_err
fn set_black_list() {
    
}

// whoami权限检测
pub fn personal_whoami(db DB, c_id string, c_pwd string) string {
    id_check := sql db {
        select from Personal where id == url_encode_str(c_id) && passwd == err_log.sha256_str(c_pwd)
    } or { personal_err() }
    // there has a black list to set.
    if id_check.len != 0 && true {
        return id_check.first().whoami
    } else {
        return ''
    }
}


// 登录检测
pub fn login_status(db DB, c_id string, c_pwd string) StatusReturn {
    // 临时解决
    personal_err()

    id_check := sql db {
        select from Personal where id == url_encode_str(c_id) && passwd == err_log.sha256_str(c_pwd)
    } or { personal_err() }
    // there has a black list to set.
    if id_check.len != 0 && true {
        return StatusReturn{true, false, id_check}
    } else {
        return StatusReturn{false, false, id_check}
    }
}

// 查询密码
pub fn select_passwd_db(db DB, ip string, email string, passwd string) StatusReturn {
    // 临时解决
    personal_err()

    err_log.logs('${vlog.set_log}: ip:${ip} email/id:${email} password:${passwd} 正在登录.')

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
            err_log.logs('${vlog.true_log}: ip:${ip} pid:${i.pid} is login.')
        }
    }

    return StatusReturn{false, not_passwd, id_check}
}

// ========================= 注册函数 =================================
// 注册检测
pub fn register_status(db DB, id string, email string, passwd string) bool {
    // 临时解决
    personal_err()

    mut return_bool := false

    new_number := Personal{
        id      :   url_encode_str(id)
        email   :   url_encode_str(email)
        passwd  :   err_log.sha256_str(passwd)
        whoami  :   'member'
        challenge    :   []PersonalFlag{}
    }

    id_check := sql db {
        select from Personal where id == new_number.id || email == new_number.email
    } or { personal_err() }
    if id_check.len != 0 || new_number.id == '' {
        println('${vlog.false_log}: 检测到提交无效数据')
        return_bool = true
    }
    return return_bool
}

// 注册函数
pub fn register_db(db DB, id string, email string, passwd string) bool {
    vlog.temporary()


    mut return_bool := false

    mut personal_flag := []PersonalFlag{}
    challenges := sql db {select from Task} or { []Task{} }

    for i in challenges {
        personal_flag << PersonalFlag{ parents_challenge : i.tid, complete : unsolved }
    }

    new_number := Personal{
        id      :   url_encode_str(id)
        email   :   url_encode_str(email)
        passwd  :   err_log.sha256_str(passwd)
        whoami  :   'member'
        challenge    :   personal_flag
    }

    sql db {
        insert new_number into Personal
    } or {
        println("${vlog.false_log}: 存储数据出错${new_number}")
        return_bool = true
    }
    return return_bool
}

// ========================= 修改密码 =================================
// 
pub fn id_check(db DB, c_id string, oldpasswd string, newpasswd string) bool {
    // 临时解决
    personal_err()

    vlog.temporary()


    id_check := sql db {
        select from Personal where id == c_id && passwd == err_log.sha256_str(oldpasswd)
    } or { personal_err() }
    if id_check.len != 0 {
        err_log.logs('Setting: ${c_id}将修改密码为:${newpasswd}')
        sql db {
            update Personal set passwd = newpasswd where id == c_id && passwd == oldpasswd is none
        } or { 
            err_log.logs('${vlog.false_log}: ${c_id}修改密码失败')
            return false
        }
        return true
    }
    return false
}





