// v -d vweb_livereload watch run .
// 重新实时加载运行vweb应用程序

module main

import vweb
import os
import db.sqlite
import err_log
import log
import sql_db { Personal, Task, test_main_function }
import encoding.base64 { url_encode_str, url_decode_str }

/*
// 跨域请求参数, 用后端实现更安全, 但是这部分实现起来好麻烦.
struct Counter {
mut:
    id          string
    passwd      string
}
*/

// 基础结构体
struct App {
    vweb.Context
mut:
    db          sqlite.DB
    //counter shared Counter
}

// 题目
// define true '../image/complete.png'
// define false '../image/incomplete.png'

struct Type{
    name        string
    type_text   []Task
}

/* 登录验证函数
fn function() {
    //mess := cookie_mess(mut app)
    c_id := cookie_id(app)
    c_pwd := cookie_passwd(app)
    login := login_status(app, c_id, c_pwd)

    if c_id == '' {
        return app.redirect('/login.html')
    } else if  login.return_bool {
        [路由主体函数]
    } else {
        return app.redirect('/error.html')
    }
 */
struct LoginStatusReturn {
    return_bool         bool
    id_check            []Personal
}

fn login_status(app App, c_id string, c_pwd string) LoginStatusReturn {
    id_check := sql app.db {
        select from Personal where id == url_encode_str(c_id) && passwd == err_log.sha256_str(c_pwd)
    } or { err_log.personal_err() }
    if id_check.len != 0 {
        return LoginStatusReturn{true, id_check}
    } else {
        return LoginStatusReturn{false, id_check}
    }
}

// 获取id
fn cookie_id(app App) string { 
    c_id := app.get_cookie('id') or { '' }
    return url_decode_str(c_id)
}

// 获取email
fn cookie_email(app App) string { 
    c_email := app.get_cookie('email') or { '' }
    return url_decode_str(c_email)
}

// 获取passwd
fn cookie_passwd(app App) string {
    c_pwd := app.get_cookie('passwd') or { '' }
    return url_decode_str(c_pwd)
}

fn cookie_mess(mut app App) string {
    mess := app.get_cookie('mess') or { '' }
    app.set_cookie(name:'mess', value:'')
    return url_decode_str(mess)
}

/*************
 *  功能函数
*************/

// 主函数
fn main() {
    // 线程设置
    mut workers := 3

    if os.args.len >= 2 {
        workers = os.args[1].int()
    }

    // 数据库设置

    // 初始化题目进行测试.
    //test_main_function()

    vweb.run_at(
        new_app(),
        vweb.RunParams{
            port: 80
            nr_workers: workers
        }) or { panic(err) }
}

// 使所有静态文件可用
fn new_app() &App {
    mut db := sqlite.connect('./data.db')  or {
        err_log.logs('Error: sqlite调用错误')
        panic(err)
    }
    db.synchronization_mode(sqlite.SyncMode.off) or {
        err_log.logs('Error: data.db控制同步设置失败')
    }
    db.journal_mode(sqlite.JournalMode.memory) or {
        err_log.logs('Error: data.db日志模式设置失败')
    }

    mut app := &App{ db:db }
    app.mount_static_folder_at(os.resource_abs_path('.'), '/')
    return app
}

/* 弹窗信息
 * false: ...
 * true: ...
 * warn: ...
 */

/*************
 * 首页文件页
*************/ 
@['/']
fn (mut app App) index() vweb.Result {
    mess := cookie_mess(mut app)
    return $vweb.html()
}

@['/index.html']
fn (mut app App) find_index() vweb.Result {
    return app.redirect('/')
}

/*****************
 * 404错误文件页
*****************/ 
@['/error.html']
fn (mut app App) error() vweb.Result {
    mess := cookie_mess(mut app)
    return $vweb.html()
}

pub fn (mut app App) not_found() vweb.Result {
    app.set_status(404, 'Not Found')
    return app.redirect('/error.html')
}

/**************
 * 登录文件页
***************/ 
@['/login.html']
fn (mut app App) login() vweb.Result {
    mess := cookie_mess(mut app)

    c_id := cookie_id(app)
    
    if c_id == '' {
        return $vweb.html()
    } else {
        return app.redirect('/member.html')
    }
}

@['/loginapi'; post]
fn (mut app App) loginapi() vweb.Result {
    email := url_decode_str(app.form['email'])
    passwd := url_decode_str(app.form['passwd'])

    select_passwd := sql app.db {
        select from Personal where id == url_encode_str(email) || email == url_encode_str(email)
    } or { err_log.personal_err() }

    if select_passwd.len == 0 {
        app.set_cookie(name:'mess', value: url_encode_str('Error: 用户不存在'))
        return app.redirect('/error.html')
    }
    
    /***********************************************************************************
    *   如果id==email会出问题.
    *   应该先进行正则判别
    *   以上需求还未实现, 当前以实现为主要目的
    *   
    *   登录密码和cookie我希望能使用不同的方式进行存储
    *   希望能使密码系统门数足够小
    *   且就算盗取cookie后具有可恢复性
    *   数据库中的passwd仅作为验证信息
    *   无法使用cookie进行登录
    ************************************************************************************/
    mut not_passwd := true
    
    for i in select_passwd {
        if i.passwd == err_log.sha256_str(passwd) {
            not_passwd = false
            err_log.logs('${log.set_log}: ${i.id}已登陆')
            app.set_cookie(name:'id', value:i.id)
            app.set_cookie(name:'passwd', value:url_encode_str(passwd))
        }
    }

    if not_passwd {
        app.set_cookie(name:'mess', value: url_encode_str('Error: 密码错误'))
    }

    return app.redirect('/error.html')
}

/**************
 * 注册文件页
***************/ 

@['/refusrer.html']
fn (mut app App) refusrer() vweb.Result {
    mess := cookie_mess(mut app)

    // 功能问题: 检测注册是否成功应该有提示, 如果成功直接跳转
    c_id := cookie_id(app)
    if c_id == '' {
        return $vweb.html()
    } else {
        return app.redirect('/member.html')
    }
}

@['/refusrerapi'; post]
fn (mut app App) refusrerapi() vweb.Result {
    id := url_decode_str(app.form['id'])
    email := url_decode_str(app.form['email'])
    passwd := url_decode_str(app.form['passwd'])

    if id.index('@') != none {
        err_log.logs_err('${log.false_log}: 检测到名称中包含"@"')
        app.set_cookie(name:'mess', value: url_encode_str('Error: 名称中禁止包含"@"'))
        return app.redirect('/error.html')
    }

    // email 的格式也应该进行正则匹配.
    
    new_number := Personal{
        id      :   url_encode_str(id)
        email   :   url_encode_str(email)
        passwd  :   err_log.sha256_str(passwd)
        whoami  :   'member'
        score   :   0
    }

    sql app.db {
        create table Personal
    } or {
        err_log.logs('${log.false_log}: 检测到数据库创建失败')
    }

    id_check := sql app.db {
        select from Personal where id == new_number.id || email == new_number.email
    } or { err_log.personal_err() }
    if id_check.len != 0 || new_number.id == '' {
        err_log.logs_err('${log.false_log}: 检测到提交无效数据')
        app.set_cookie(name:'mess', value: url_encode_str('Error: 检测到提交无效数据'))
        return app.redirect('/error.html')
    }
    sql app.db {
        insert new_number into Personal
    } or {
        err_log.logs_err("${log.false_log}: 存储数据出错${new_number}")
        app.set_cookie(name:'mess', value: url_encode_str('Error: 存储数据出错'))
        return app.redirect('/error.html')
    }
    // 设置cookie并更新页面情况
    app.set_cookie(name:'id', value:url_encode_str(id))
    app.set_cookie(name:'passwd', value:url_encode_str(passwd))
    return app.redirect('/error.html')
}

/**************
 * 个人文件页
***************/

@['/member.html']
fn (mut app App) member() vweb.Result {
    mess := cookie_mess(mut app)
    c_id := cookie_id(app)
    c_pwd := cookie_passwd(app)
    login := login_status(app, c_id, c_pwd)

    if c_id == '' {
        return app.redirect('/login.html')
    } else if  login.return_bool {
        name := c_id
        email := url_decode_str(login.id_check[0].email)
        return $vweb.html()
    } else {
        return app.redirect('/error.html')
    }
}

@['/memberapi'; post]
fn (mut app App) memberapi() vweb.Result {
    c_id := cookie_id(app)
    oldpasswd := url_decode_str(app.form['oldpasswd'])
    newpasswd := url_decode_str(app.form['newpasswd'])
    id_check := sql app.db {
        select from Personal where id == c_id && passwd == err_log.sha256_str(oldpasswd)
    } or { err_log.personal_err() }
    if id_check.len != 0 {
        err_log.logs('Setting: ${c_id}将修改密码为:${newpasswd}')
        sql app.db {
            update Personal set passwd = newpasswd where id == c_id && passwd == oldpasswd is none
        } or { err_log.logs('${log.false_log}: ${c_id}修改密码失败') }
        app.set_cookie(name:'passwd', value: newpasswd)
        // 更新页面情况
        app.member()
    }
    
    return app.redirect('/member.html')
}

/**************
 * 挑战页
***************/

@['/task.html']
fn (mut app App) task() vweb.Result {
    mess := url_decode_str(app.get_cookie('mess') or { '' })
    app.set_cookie(name:'mess', value:'')
    
    the_cookie_id := cookie_id(app)
    if the_cookie_id == '' {
        return app.redirect('/login.html')
    } else {
        list_of_crypto := sql app.db {
            select from Task where type_text == "crypto"
        } or { err_log.task_err() }

        list_of_web := sql app.db {
            select from Task where type_text == "web"
        } or { err_log.task_err() }

        list_of_misc := sql app.db {
            select from Task where type_text == "misc"
        } or { err_log.task_err() }

        list_of_pwn := sql app.db {
            select from Task where type_text == "pwn"
        } or { err_log.task_err() }

        list_of_reverse := sql app.db {
            select from Task where type_text == "reverse"
        } or { err_log.task_err() }
        /*

        */

        list_of_type := [
            Type{
                name         :    'Crypto'
                type_text    :    list_of_crypto
            },
            Type{
                name         :    'Web'
                type_text    :    list_of_web
            }
            Type{
                name         :    'MISC'
                type_text    :    list_of_misc
            }
            Type{
                name         :    'Pwn'
                type_text    :    list_of_pwn
            }
            Type{
                name         :    'Reverse'
                type_text    :    list_of_reverse
            }
        ]
        return $vweb.html()
    }
}

@['/flagapi'; post]
fn (mut app App) flagapi() vweb.Result {
        /***********************************************************************************
    *   这里有个很重要的问题:
    *   我认为使用name作为判别依据是不现实的,
    *   应该生成一段id信息进行区分,
    *   但是现在实现功能要紧,
    *   之后需要重新修改底层.
    ************************************************************************************/
    the_cookie_id := app.get_cookie('id') or { '' }
    if the_cookie_id == '' {
        return app.redirect('/login.html')
    } else {
        flag := app.form['flag']
        task_name := app.form['name']
        task_flag := sql app.db {
            select from Task where name == task_name
        } or { err_log.task_err() }

        // 这里修改不太对, 还有需要对控制进行私有化, 还挺麻烦的.

        if flag == task_flag[0].flag {
            sql app.db {
                update Task set complete = '../image/complete.png' where name == task_name 
            } or { err_log.logs('Flag: ${flag}错误') }
        } else {
            err_log.logs('Flag: 修改出错')
        }

        app.task()

        return app.redirect('/login.html')
    }
}

