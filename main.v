// v -d vweb_livereload watch run .
// 重新实时加载运行vweb应用程序

module main

import vweb
import os

// 基础结构体
struct App {
    vweb.Context
}

// 输出日志
fn log(data string) {
    println(data)
}

// 主函数
fn main() {
    mut workers := 7
    if os.args.len < 2 {
        new_workers := os.args[1]
        if typeof(new_workers).name == 'int' {
            workers = new_workers
        }
    }
    vweb.run_at(new_app(), vweb.RunParams{
        port: 8080 , nr_workers: workers
    }) or { panic(err) }
}

// 使所有静态文件可用
fn new_app() &App {
    mut app := &App{}
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
    return $vweb.html()
}

