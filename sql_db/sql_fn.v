module sql_db

import encoding.base64 { url_encode_str, url_decode_str }
import err_log
import vlog
import db.sqlite { DB }
import time {Time}
import console { readfile }

type Any = string | int | time.Time

// personal报错函数
fn personal_err() []Personal {
    println('${vlog.false_log}查询错误')
    return []Personal{}
}

// 黑名单personal_err
fn set_black_list() bool {
    return true
}

// 查看Init初始化数据信息
pub fn set_init(db DB) Init {
    init := sql db { select from Init } or { []Init{} }
    if init.len == 0 {
        new_init := Init{
            id         : 1
            starttime : Time{
                year: 1970
                month: 1
                day: 1
                hour: 0
                minute: 0
                second: 0
            }
            endtime   : Time{
                year: 9999
                month: 12
                day: 31
                hour: 23
                minute: 59
                second: 59
            }
            index      : readfile('./static/html/index.html')
            title_name : 'VTF'
            time_zone  : 8
        }
        sql db {
            insert new_init into Init
        } or {}
        return new_init
    }
    else {
        return init.first()
    }
}

// 修改Init初始化数据信息
pub fn update_init(db DB, type_text string, text Any ) {
    match type_text {
        'starttime' {
            $if text is Time {
                sql db {
                    update Init set starttime = text where id == 1
                } or { return }
            }
        }
        'endtime' {
            $if text is Time {
                sql db {
                    update Init set endtime = text where id == 1
                } or { return }
            }
        }
        'index' {
            $if text is string {
                sql db {
                    update Init set index = text where id == 1
                } or { return }
            }
        }
        'title_name' {
            $if text is string {
                sql db {
                    update Init set title_name = text where id == 1
                } or { return }
            }
        }
        'time_zone' {
            $if text is string {
                sql db {
                    update Init set time_zone = text where id == 1
                } or { return }
            }
        }
        else {
            return
        }
    }
}


// whoami权限检测
pub fn personal_whoami(db DB, c_id string, c_pwd string) string {
    id_check := sql db {
        select from Personal where id == url_encode_str(c_id) && passwd == err_log.sha256_str(c_pwd)
    } or { personal_err() }
    // there has a black list to set.
    if id_check.len != 0 && set_black_list() {
        return id_check.first().whoami
    } else {
        return ''
    }
}

// 登录检测
pub fn login_status(db DB, c_id string, c_pwd string) StatusReturn {
    id_check := sql db {
        select from Personal where id == url_encode_str(c_id) && passwd == err_log.sha256_str(c_pwd)
    } or { personal_err() }
    // there has a black list to set.
    if id_check.len != 0 && set_black_list() {
        return StatusReturn{true, false, id_check}
    } else {
        return StatusReturn{false, false, id_check}
    }
}

// 管理员检测
pub fn login_root_status(db DB, c_id string, c_pwd string) StatusReturn {
    id_check := sql db {
        select from Personal where id == url_encode_str(c_id) && passwd == err_log.sha256_str(c_pwd) && whoami != 'member'
    } or { personal_err() }
    // there has a black list to set.
    if id_check.len != 0 && set_black_list() {
        return StatusReturn{true, false, id_check}
    } else {
        return StatusReturn{false, false, id_check}
    }
}

// 查询密码
pub fn select_passwd_db(db DB, ip string, email string, passwd string) StatusReturn {
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





