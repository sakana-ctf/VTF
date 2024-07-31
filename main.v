// v -d vweb_livereload watch run .
// 重新实时加载运行vweb应用程序

module main

import vweb
import os
import db.sqlite

/*
// 跨域请求参数, 用后端实现更安全, 但是这部分实现起来好麻烦.
struct Counter {
pub mut:
    id          string
    passwd      string
}
*/

// 基础结构体
struct App {
    vweb.Context
mut:
    db sqlite.DB
    //counter shared Counter
}


/*************
 * 数据库类型
*************/

@[table: 'personal']
struct Personal {
    id         string
    email      string
    passwd     string
    whoami     string
    score      int
}

/*************
 *  功能函数
*************/

// 查询报错函数
fn select_err() []Personal {
    println('查询错误')
    return []
}

// 输出日志
fn log(data string) {
    println(data)
}

// 获取id
fn cookie_id(app App) string { 
    c_id := app.get_cookie('id') or { '' }
    return c_id
}

// 获取passwd
fn cookie_passwd(app App) string {
    c_pwd := app.get_cookie('passwd') or { '' }
    return c_pwd
}

// 主函数
fn main() {
    // 线程设置
    mut workers := 3
        /*
    if os.args.len >= 2 {
        workers = os.args[1]
    }
    */
    // 数据库设置

    log('当前线程数为: ${workers}')
    vweb.run_at(
        new_app(),
        vweb.RunParams{
            port: 8080
            nr_workers: workers
        }) or { panic(err) }
}

// 使所有静态文件可用
fn new_app() &App {
        mut db := sqlite.connect('./data.db')  or {
        log('Error: sqlite调用错误')
        panic(err)
    }
    db.synchronization_mode(sqlite.SyncMode.off) or {
        log('Error: data.db控制同步设置失败')
    }
    db.journal_mode(sqlite.JournalMode.memory) or {
        log('Error: data.db日志模式设置失败')
    }

    mut app := &App{ db:db }
    app.mount_static_folder_at(os.resource_abs_path('.'), '/')
    return app
}

/*************
 * 首页文件页
*************/ 
@['/']
fn (mut app App) index() vweb.Result {
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
    return $vweb.html()
}

@['/loginapi'; post]
fn (mut app App) loginapi() vweb.Result {
    /***********************************************************************************
    *   这个函数直接参考refusrerapi去修改就好, 基本都是现成的:
    *       1. 找refusrer.html的节点看看输入的信息设置的和refusrer.html是否基本一样.
    *       2. 在console.js可以参考refusrer()函数编写passwdlogin().
    *       3. 参考refusrerapi()函数修改以下函数.
    *
    *   备注: 与注册不同, 当需要先检查sql数据再进行登录
    ************************************************************************************/
    email := app.form['email']
    passwd := app.form['passwd']

    select_passwd := sql app.db {
        select from Personal where id == email || email == email
    } or { select_err() }
    id := passwd // 详细逻辑不太对, 之后再来解决.

    
    /***********************************************************************************
    *   如果存在id==email会出问题.
    *   应该先进行正则判别
    *   以上需求还未实现, 当前以实现为主要目的
    ************************************************************************************/
    for i in select_passwd {
        if (i == passwd){
            log('Setting: ${c_id}将修改密码为:${newpasswd}')
            app.set_cookie(name:'id', value:id)
            app.set_cookie(name:'passwd', value:passwd)
        }
    }
    return app.redirect('/login.html')
}

/**************
 * 个人文件页
***************/

@['/member.html']
fn (mut app App) member() vweb.Result {
    c_id := cookie_id(app)
    c_pwd := cookie_passwd(app)
    id_check := sql app.db {
        select from Personal where id == c_id && passwd == c_pwd
    } or { select_err() }
    if id_check.len != 0 {
        name := c_id
        email := id_check[0].email
        return $vweb.html()
    } else {
        return app.redirect('/error.html')
    }
}

@['/memberapi'; post]
fn (mut app App) memberapi() vweb.Result {
    c_id := cookie_id(app)
    oldpasswd := app.form['oldpasswd']
    newpasswd := app.form['newpasswd']
    id_check := sql app.db {
        select from Personal where id == c_id && passwd == oldpasswd
    } or { select_err() }
    if id_check.len != 0 {
        log('Setting: ${c_id}将修改密码为:${newpasswd}')
        sql app.db {
            update Personal set passwd = newpasswd where id == c_id && passwd == oldpasswd is none
        } or { log('Error: ${c_id}修改密码失败') }
        app.set_cookie(name:'passwd', value:newpasswd)
    }
    return app.redirect('/member.html')
}

/**************
 * 注册文件页
***************/ 

@['/refusrer.html']
fn (mut app App) refusrer() vweb.Result {
    // 功能问题: 检测注册是否成功应该有提示, 如果成功直接跳转
    cookie_id := app.get_cookie('id') or { '' }
    if cookie_id == '' {
        return $vweb.html()
    } else {
        return app.redirect('/member.html')
    }
}

@['/refusrerapi'; post]
fn (mut app App) refusrerapi() vweb.Result {
    new_number := Personal{
        id      :   app.form['id']
        email   :   app.form['email']
        passwd  :   app.form['passwd']
        whoami  :   'member'
        score   :   0
    }

    sql app.db {
        create table Personal
    } or {
        log('Error: 创建失败')
    }

    id_check := sql app.db {
        select from Personal where id == new_number.id || email == new_number.email
    } or { select_err() }
    if id_check.len != 0 || new_number.id == '' {
        log('Error: 检测到提交无效数据')
        return app.redirect('/refusrer.html')
    }
    log('Setting: 存储数据')
    sql app.db {
        insert new_number into Personal
    } or {
        log("Error: 存储数据出错${new_number}")
        return app.redirect('/refusrer.html')
    }
    app.set_cookie(name:'id', value:new_number.id)
    app.set_cookie(name:'passwd', value:new_number.passwd)
    return app.redirect('/member.html')
}

