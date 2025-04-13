// v -d veb_livereload watch run .
// ./templates_split/build ; v main.v ; ./main
// 重新实时加载运行vweb应用程序

module main

import db.sqlite { DB }
import veb
import json
import shell { start, CmdSet }
import sql_db {
    connect_db,
    
    login_status,
    login_root_status,
    select_passwd_db,
    register_status,
    register_db,
    id_check,
    find_user,

    build_challenge,
    post_flag,

    get_personal,
    find_challenge,
    bool_solve,
    challenge_score,

    personal_whoami,

    //console
    add_challenge
}

import encoding.base64 { 
    url_encode_str, 
    url_decode_str 
}

const version := "v2.6.0-stable"

/*
struct User {
mut:
	name string
	id   int
}
*/

struct Rank{
    team_id string
    score   int
    challenge    []bool
}

// 基础结构体
pub struct Context {
    veb.Context
// mut:
	// In the context struct we store data that could be different
	// for each request. Like a User struct or a session id
	// user       User
	// session_id string
//mut:
    //db    sqlite.DB
    //counter shared Counter
}

pub struct App {
    veb.StaticHandler
    veb.Middleware[Context]
mut:
    db      DB
}

/* ==================登录验证函数-===================
fn function() {
    c_id := cookie_id(ctx)
    c_pwd := cookie_passwd(ctx)
    login := login_status(app.db, c_id, c_pwd)

    if c_id == '' {
        ctx.set_cookie(name:'mess', value: url_encode_str('Error: 请登录后查看'))
        return ctx.redirect('/login.html')
    } else if login.return_bool {
        [主要函数]
    } else {
        ctx.set_cookie(name:'id', value: '')
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

/*************
 *  功能函数
*************/

// 主函数
fn main() {
    cmd_set := start(version)

    db := connect_db(cmd_set.nohup, cmd_set.args, cmd_set.port, cmd_set.database) or { exit(1) }
    
    println('暂不支持设置线程数: ${cmd_set.workers}')

    mut app := new_app(db)


    veb.run_at[App, Context](
        mut app,
        veb.RunParams{
            port: cmd_set.port
            //nr_workers: workers
        },
    ) or { panic(err) }
}

fn new_app(db DB) &App {

    mut app := &App{ 
        db : db,
    }

    app.static_mime_types['.cjs'] = 'txt/javascript'
    app.static_mime_types['.map'] = 'txt/javascript'
    app.static_mime_types['.vbs'] = 'txt/javascript'
    app.static_mime_types['.yml'] = 'txt/javascript'
    app.static_mime_types['.mts'] = 'txt/javascript'
    app.static_mime_types['.hml'] = 'txt/javascript'
    app.static_mime_types['.md'] = 'txt/plain'
    app.static_mime_types['.markdown'] = 'txt/plain'
    app.static_mime_types['.jade'] = 'txt/plain'
    app.static_mime_types['.png~'] = 'image/png'

    app.handle_static('static', true) or {
        panic(err)
    }

    app.use(veb.cors[Context](veb.CorsOptions{
                // allow CORS requests from every domain
                origins: ['*']
                // allow CORS requests with the following request methods:
                allowed_methods: [.get, .head, .patch, .put, .post, .delete]
        }))

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

    select_passwd := select_passwd_db(app.db, ctx.ip(), email, passwd)

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

@['/signup.html']
fn (mut app App) signup(mut ctx Context) veb.Result {
    // 功能问题: 检测注册是否成功应该有提示, 如果成功直接跳转
    c_id := cookie_id(ctx)
    if c_id == '' {
        return $veb.html()
    } else {
        return ctx.redirect('/member.html')
    }
}

@['/signupapi'; post]
fn (mut app App) signupapi(mut ctx Context) veb.Result {
    id := url_decode_str(ctx.form['id'])
    email := url_decode_str(ctx.form['email'])
    passwd := url_decode_str(ctx.form['passwd'])

    // 这里应该使用正则匹配, 现在只是粗暴区分用户名和邮箱.
    if id.index('@') != none {
        ctx.set_cookie(name:'mess', value: url_encode_str('Error: 名称中禁止包含"@"'))
        return ctx.text('401: Usernames are forbidden to contain "@".')
    }

    // email 的格式应该进行更详细的正则匹配.
    if email.index('@') == none {
        ctx.set_cookie(name:'mess', value: url_encode_str('Error: email格式存在错误'))
        return ctx.text('401: There is an error in the email format.')
    }

    
    if register_status(app.db, id, email, passwd) {
        ctx.set_cookie(name:'mess', value: url_encode_str('Error: 检测到提交无效数据'))
        return ctx.text('403: Invalid data was detected')
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
    c_id := cookie_id(ctx)
    c_pwd := cookie_passwd(ctx)
    login := login_status(app.db, c_id, c_pwd)

    if c_id == '' {
        ctx.set_cookie(name:'mess', value: url_encode_str('Error: 请登录后查看'))
        return ctx.redirect('/login.html')
    } else if login.return_bool {
        ctx.set_cookie(name:'whoami', value: url_encode_str(login.id_check.first().whoami))
        name := c_id
        email := url_decode_str(login.id_check[0].email)
        return $veb.html()
    
    } else {
        ctx.set_cookie(name:'id', value: '')
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

@['/challenge.html']
fn (mut app App) challenge(mut ctx Context) veb.Result {
    c_id := cookie_id(ctx)
    c_pwd := cookie_passwd(ctx)
    login := login_status(app.db, c_id, c_pwd)

    if c_id == '' {
        ctx.set_cookie(name:'mess', value: url_encode_str('Error: 请登录后查看'))
        return ctx.redirect('/login.html')
    } else if login.return_bool {
        c_pid := find_user(app.db, url_encode_str(c_id), c_pwd).pid
        list_of_type := build_challenge(app.db)
        return $veb.html()
    } else {
        ctx.set_cookie(name:'id', value: '')
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
        return ctx.text('401: Please login first.')
    } else if login.return_bool {
        flag := url_decode_str(ctx.form['flag'])
        tid := url_decode_str(ctx.form['tid']).int()

        if post_flag(app.db, ctx.ip(), tid, flag, login.id_check.first().pid) {
            ctx.set_cookie(name:'mess', value: url_encode_str('提交成功'))
            return ctx.text('200: Seccess.')
        }
        ctx.set_cookie(name:'mess', value: url_encode_str('Error: 提交失败'))
        return ctx.text('403: Wrong.')
    } else {
        ctx.set_cookie(name:'mess', value: url_encode_str('Error: 账户存在问题'))
        return ctx.text('401: Please login first.')
    }
}


@['/team.html']
fn (mut app App) team(mut ctx Context) veb.Result {
    return $veb.html()
}

/**************
 * 排行榜
***************/

@['/ranking.html']
fn (mut app App) ranking(mut ctx Context) veb.Result {
    challenge_name := find_challenge(app.db)
    return $veb.html()
}

@['/rankapi']
fn (mut app App) rankapi(mut ctx Context) veb.Result {
    mut data := []Rank{}
    for i in get_personal(app.db) {
        mut delta := []bool{}
        mut score := 0
        for j in i.challenge {
            if bool_solve(j) {
                delta << true
                score += challenge_score(app.db, j)
            } else {
                delta << false
            }
        }
        data << Rank{
            team_id 	: url_decode_str(i.id)
            score   	: score
            challenge   : delta
        }
    }
    
    return ctx.text(json.encode(data))
}

@['/notice.html']
fn (mut app App) notice(mut ctx Context) veb.Result {
    return ctx.redirect('/team.html')
}

/**************
 * 后台控制系统
***************/

@['/console.html']
fn (mut app App) console(mut ctx Context) veb.Result {
    c_id := cookie_id(ctx)
    c_pwd := cookie_passwd(ctx)
    login := login_root_status(app.db, c_id, c_pwd)

    if c_id == '' {
        ctx.set_cookie(name:'mess', value: url_encode_str('Error: 请登录后查看'))
        return ctx.redirect('/login.html')
    } else if login.return_bool {
            list_of_type := build_challenge(app.db)
            return $veb.html() 
    } else {
        ctx.set_cookie(name:'id', value: '')
        return ctx.redirect('/error.html')
    }
}

@['/challengeapi/:set'; post]
fn (mut app App) addchallengeapi(mut ctx Context, set string) veb.Result {
    c_id := cookie_id(ctx)
    c_pwd := cookie_passwd(ctx)
    login := login_root_status(app.db, c_id, c_pwd)

    if c_id == '' {
        ctx.set_cookie(name:'mess', value: url_encode_str('Error: 请登录后查看'))
        return ctx.redirect('/login.html')
    } else if login.return_bool {
        match set {
            'add' {
                    type_text := url_decode_str(ctx.form['type_text'])
                    // todo: 多个flag的问题
                    flag := url_decode_str(ctx.form['flag'])
                    name := url_decode_str(ctx.form['name'])
                    diff := url_decode_str(ctx.form['diff'])
                    intro := url_decode_str(ctx.form['intro'])
                    max_score := url_decode_str(ctx.form['max_score']).int()
                    score := url_decode_str(ctx.form['score']).int()
                    container := url_decode_str(ctx.form['container']).bool()
                    msg := add_challenge(app.db, type_text, [flag], name, diff, intro, max_score, score, container)
                    ctx.set_cookie(name:'mess', value: url_encode_str(msg))
                return ctx.text('200: Seccess.')
            }
            else {
                return ctx.text('403: Wrong.')
            }
        }
    } else {
        ctx.set_cookie(name:'id', value: '')
        return ctx.text('403: Wrong.')
    }
}




