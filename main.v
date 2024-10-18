// v -d veb_livereload watch run .
// 重新实时加载运行vweb应用程序

module main

import db.sqlite { DB }
import veb
import os
import log
import sql_db {
    connect_db,
    create_db,
    
    login_status,
    select_passwd_db,
    register_status,
    register_db,
    id_check,
    find_user,

    build_task,
    post_flag,

    get_personal,
    find_task,
    //find_task_score,
    bool_solve,

    test_main_function
}

import encoding.base64 { 
    url_encode_str, 
    url_decode_str 
}

struct User {
mut:
	name string
	id   int
}

// 基础结构体
struct Context {
    veb.Context
mut:
	// In the context struct we store data that could be different
	// for each request. Like a User struct or a session id
	user       User
	session_id string
//mut:
    //db    sqlite.DB
    //counter shared Counter
}

pub struct App {
    veb.StaticHandler
	// In the app struct we store data that should be accessible by all endpoints.
	// For example, a database or configuration values.
mut:
    db DB
}

/* ==================登录验证函数-===================
fn function() {
    //mess := cookie_mess(mut ctx)
    c_id := cookie_id(ctx)
    c_pwd := cookie_passwd(ctx)
    login := login_status(app.db, c_id, c_pwd)

    if login.return_bool {
        [main]
    } else {
        return ctx.redirect('/error.html')
    }
}
    ================================================
*/

// 获取id
fn cookie_id(ctx Context) string { 
    c_id := ctx.get_cookie('id') or { '' }
    return url_decode_str(c_id)
}

// 获取email
fn cookie_email(ctx Context) string { 
    c_email := ctx.get_cookie('email') or { '' }
    return url_decode_str(c_email)
}

// 获取passwd
fn cookie_passwd(ctx Context) string {
    c_pwd := ctx.get_cookie('passwd') or { '' }
    return url_decode_str(c_pwd)
}

fn cookie_mess(mut ctx Context) string {
    mess := ctx.get_cookie('mess') or { '' }
    ctx.set_cookie(name:'mess', value:'')
    return url_decode_str(mess)
}

/*************
 *  功能函数
*************/

// 主函数
fn main() {
    // 线程设置
    mut workers := 3

    if os.args.len >= 2 && os.args[1].int() != 0 {
        workers = os.args[1].int()
    }

    println('暂不支持设置线程数: ${workers}')

    //mut app := &App{ db : connect_db() , }
    
    // 现在我们不需要反复打开关闭例子了:
    /*
    test_main_function(mut app.db)
    
    app.static_mime_types['.cjs'] = 'txt/javascript'
    app.static_mime_types['.vbs'] = 'txt/javascript'
    app.static_mime_types['.md'] = 'txt/plain'
    app.static_mime_types['.png~'] = 'image/png'
    app.handle_static('static', true) or {
        panic(err)
    }
    */
    
    //veb.run[App, Context](mut app, 80)
    mut app := new_app()
    
    veb.run_at[App, Context](
        mut app,
        veb.RunParams{
            port: 80
            //nr_workers: workers
        }
    ) or { panic(err) }
}

fn new_app() &App {
    data := os.execute_opt('v run ./templates_split/build.v') or {
        os.Result{ 0, '${log.warn_log}更新html文件失败.'}
    }
    println(data.output)

    mut app := &App{ 
        db : connect_db() ,
    }
    create_db(app.db)
    
    test_main_function(mut app.db)
    
    app.static_mime_types['.cjs'] = 'txt/javascript'
    app.static_mime_types['.vbs'] = 'txt/javascript'
    app.static_mime_types['.md'] = 'txt/plain'
    app.static_mime_types['.png~'] = 'image/png'

    app.handle_static('static', true) or {
        panic(err)
    }

    return app
}

// 使所有静态文件可用
/*
fn new_app() &App {
    //mut db := connect_db()
    mut app := &App{ }
    app.mount_static_folder_at(os.resource_abs_path('.'), '/')
    return app
}
*/
/*************
 * 首页文件页
*************/ 
@['/']
fn (mut app App) index(mut ctx Context) veb.Result {
    mess := cookie_mess(mut ctx)
    return $veb.html()
}


@['/index.html']
fn (mut app App) find_index(mut ctx Context) veb.Result {
    return ctx.redirect('/')
}

/*****************
 * 404错误文件页
*****************/ 
@['/error.html']
fn (mut app App) error(mut ctx Context) veb.Result {
    mess := cookie_mess(mut ctx)
    return $veb.html()
}

pub fn (mut ctx Context) not_found() veb.Result {
    ctx.res.set_status(.not_found)
    return ctx.redirect('/error.html')
}

/**************
 * 登录文件页
***************/ 
@['/login.html']
fn (mut app App) login(mut ctx Context) veb.Result {
    mess := cookie_mess(mut ctx)
    c_id := cookie_id(ctx)
    
    if c_id == '' {
        return $veb.html()
    } else {
        return ctx.redirect('/member.html')
    }
}

@['/loginapi'; post]
fn (mut app App) loginapi(mut ctx Context) veb.Result {
    email := url_decode_str(ctx.form['email'])
    passwd := url_decode_str(ctx.form['passwd'])

    select_passwd := select_passwd_db(app.db, email, passwd)

    if select_passwd.return_bool {
        ctx.set_cookie(name:'mess', value: url_encode_str('Error: 用户不存在'))
        return ctx.text('401: User not found.')
    }
    
    if select_passwd.find_passwd {
        ctx.set_cookie(name:'mess', value: url_encode_str('Error: 密码错误'))   
        return ctx.text('403: Password is Wrong.')
    } else {
        ctx.set_cookie(name:'id', value:select_passwd.id_check[0].id)
        ctx.set_cookie(name:'passwd', value:url_encode_str(passwd))
        ctx.redirect('/member.html')
        return ctx.text('200: Seccess.')
    }
    return ctx.text('404: Not found.')
}

/**************
 * 注册文件页
***************/ 

@['/refusrer.html']
fn (mut app App) refusrer(mut ctx Context) veb.Result {
    mess := cookie_mess(mut ctx)

    // 功能问题: 检测注册是否成功应该有提示, 如果成功直接跳转
    c_id := cookie_id(ctx)
    if c_id == '' {
        return $veb.html()
    } else {
        return ctx.redirect('/member.html')
    }
}

@['/refusrerapi'; post]
fn (mut app App) refusrerapi(mut ctx Context) veb.Result {
    id := url_decode_str(ctx.form['id'])
    email := url_decode_str(ctx.form['email'])
    passwd := url_decode_str(ctx.form['passwd'])

    if id.index('@') != none {
        ctx.set_cookie(name:'mess', value: url_encode_str('Error: 名称中禁止包含"@"'))
        return ctx.redirect('/error.html')
    }

    // email 的格式也应该进行正则匹配.
    if register_status(app.db, id, email, passwd) {
        ctx.set_cookie(name:'mess', value: url_encode_str('Error: 检测到提交无效数据'))
        return ctx.redirect('/error.html')
    }

    if register_db(app.db, id, email, passwd) {
        ctx.set_cookie(name:'mess', value: url_encode_str('Error: 存储数据出错'))
        return ctx.redirect('/error.html')
    }
    // 设置cookie并更新页面情况
    ctx.set_cookie(name:'id', value:url_encode_str(id))
    ctx.set_cookie(name:'passwd', value:url_encode_str(passwd))
    return ctx.redirect('/error.html')
}

/**************
 * 个人文件页
***************/

@['/member.html']
fn (mut app App) member(mut ctx Context) veb.Result {
    mess := cookie_mess(mut ctx)
    c_id := cookie_id(ctx)
    c_pwd := cookie_passwd(ctx)
    login := login_status(app.db, c_id, c_pwd)

    if c_id == '' {
        ctx.set_cookie(name:'mess', value: url_encode_str('Error: 请登录后查看'))
        return ctx.redirect('/login.html')
    } else if login.return_bool {
        name := c_id
        email := url_decode_str(login.id_check[0].email)
        return $veb.html()
    
    } else {
        return ctx.redirect('/error.html')
    }
}

@['/memberapi'; post]
fn (mut app App) memberapi(mut ctx Context) veb.Result {
    c_id := cookie_id(ctx)
    oldpasswd := url_decode_str(ctx.form['oldpasswd'])
    newpasswd := url_decode_str(ctx.form['newpasswd'])

    if id_check(app.db, c_id, oldpasswd, newpasswd) {
        ctx.set_cookie(name:'passwd', value: newpasswd)
        // 更新页面情况
    } else {
        ctx.set_cookie(name:'mess', value: url_encode_str('Error: 修改密码失败'))
    }
    
    return ctx.redirect('/member.html')
}

/**************
 * 挑战页
***************/

@['/task.html']
fn (mut app App) task(mut ctx Context) veb.Result {
    mess := cookie_mess(mut ctx)
    c_id := cookie_id(ctx)
    c_pwd := cookie_passwd(ctx)
    login := login_status(app.db, c_id, c_pwd)

    if c_id == '' {
        ctx.set_cookie(name:'mess', value: url_encode_str('Error: 请登录后查看'))
        return ctx.redirect('/login.html')
    } else if login.return_bool {
        c_pid := find_user(app.db, url_encode_str(c_id), c_pwd).pid
        list_of_type := build_task(app.db)
        return $veb.html()
    } else {
        return ctx.redirect('/error.html')
    }
}

@['/flagapi'; post]
fn (mut app App) flagapi(mut ctx Context) veb.Result {
    /***********************************************************************************
    *   这里有个很重要的问题:
    *   我认为使用name作为判别依据是不现实的,
    *   应该生成一段id信息进行区分,
    *   但是现在实现功能要紧,
    *   之后需要重新修改底层.
    ************************************************************************************/
    the_cookie_id := cookie_id(ctx)
    c_id := cookie_id(ctx)
    c_pwd := cookie_passwd(ctx)
    login := login_status(app.db, c_id, c_pwd)
    
    if the_cookie_id == '' {
        ctx.set_cookie(name:'mess', value: url_encode_str('Error: 请登录后提交flag'))
        app.task(mut ctx)
        return ctx.text('401: Please login first.')
    } else if login.return_bool {
        flag := url_decode_str(ctx.form['flag'])
        tid := url_decode_str(ctx.form['tid']).int()

        if post_flag(app.db, tid, flag, login.id_check.first().pid) {
            ctx.set_cookie(name:'mess', value: url_encode_str('提交成功'))
            app.task(mut ctx)
            return ctx.text('200: Seccess.')
        }
        ctx.set_cookie(name:'mess', value: url_encode_str('Error: 提交失败'))
        app.task(mut ctx)
        return ctx.text('403: Wrong.')
    } else {
        ctx.set_cookie(name:'mess', value: url_encode_str('Error: 账户存在问题'))
        app.task(mut ctx)
        return ctx.text('401: Please login first.')
    }
}


@['/team.html']
fn (mut app App) team(mut ctx Context) veb.Result {
    mess := cookie_mess(mut ctx)
    return $veb.html()
}

/**************
 * 排行榜
***************/

@['/ranking.html']
fn (mut app App) ranking(mut ctx Context) veb.Result {
    mess := cookie_mess(mut ctx)
    return $veb.html()
}

@['/rankapi']
fn (mut app App) rankapi(mut ctx Context) veb.Result {
    mut data := '| 队伍名称 | 队伍得分 |' + find_task(app.db)
    for i in get_personal(app.db) {
        data += '\n| ${url_decode_str(i.id)} |  |'
        for j in i.task {
            data += ' ${bool_solve(j)} |'
        }
        data += '\n'
    }
    
    return ctx.text(data)
}

@['/notice.html']
fn (mut app App) notice(mut ctx Context) veb.Result {
    return ctx.redirect('/team.html')
}
