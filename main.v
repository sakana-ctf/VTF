// v -d vweb_livereload watch run .
// 重新实时加载运行vweb应用程序

module main

import vweb
import os
// db 现在还未进行测试, 可以自己搞
import db.sqlite

// 基础结构体
struct App {
    vweb.Context
mut:
    db sqlite.DB
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

// 输出日志
fn log(data string) {
    println(data)
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
        log('sqlite调用错误')
        panic(err)
    }
    db.synchronization_mode(sqlite.SyncMode.off) or {
        log('Error: data.db控制同步设置失败')
    }
    db.journal_mode(sqlite.JournalMode.memory) or {
        log('Error: data.db日志模式设置失败')
    }

    mut app := &App{
        db:db
    }
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

/**************
 * 个人文件页
***************/ 
@['/member.html']
fn (mut app App) member() vweb.Result {
    return $vweb.html()
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

fn test() []Personal {
    log('Error: select查询失败')
    return []
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
    } or { test() }
    if id_check.len != 0 || new_number.id == '' {
        log('Error: 检测到提交无效数据')
        return app.redirect('/refusrer.html')
    }
    log('存储数据')
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
