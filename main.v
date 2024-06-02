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
        mut db := sqlite.connect('db')  or {
        log('sqlite调用错误')
        panic(err)
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
 * 注册文件页
***************/ 
@['/refusrer.html'; post; get]
fn (mut app App) refusrer() vweb.Result {
    //println(app.form['data']
    return $vweb.html()
}

/**************
 * 注册文件页
***************/ 
@['/refusrer.html'; post; get]
fn (mut app App) refusrer() vweb.Result {
    log(app.form['id'])
    log(app.form['email'])
    log(app.form['passwd'])
    return $vweb.html()
}

