// 注册函数
function refusrer() {
    var id = document.getElementById('id').value;
    var email = document.getElementById('email').value;
    var passwd = document.getElementById('passwd').value;
    var passwdagain = document.getElementById('passwdagain').value;
    if (passwd === passwdagain) {
        /*******************************************************
        *   这里留了一个大坑, 不知道为什么firefox无法返回数值
        ********************************************************/

        console.log("发送信息ing...");        
        // 存储数据
        const data = "id=" + id + "&email=" + email + "&passwd=" + passwd;

        // 执行操作
        const XHR = new XMLHttpRequest();  
        XHR.addEventListener("load", (event) => {
            console.log("发送成功, 正在校验账号");
        });
        
        // 错误提示
        XHR.addEventListener("error", (event) => {
            console.log("Error: 发送失败");
        });

        // 建立请求
        XHR.open("POST", "/refusrerapi");
        XHR.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
        XHR.send(data);

    } else {
        alert("Error: 密码不一致");
    }
}



// 删除cookie
function delCookie(name){
   document.cookie = name+"=;expires="+(new Date(0)).toGMTString();
}

// 查询cookie
function findCookie(name){
    var re =new RegExp('(?:(?:^|.*;\\s*)' + name + '\\s*\=\\s*([^;]*).*$)|^.*$');
    // /(?:(?:^|.*;\s*) name \s*\=\s*([^;]*).*$)|^.*$/
    return document.cookie.replace(re, "$1")
}

// 对非权限用户去掉console节点
function KillConsole() {
    var the_console = document.getElementsByClassName('navbar-list')[0];
    the_console.removeChild(the_console.firstElementChild);
}

// 对未登录用户修改为注册和登录节点
function NoLog() {
    const cookie_id = findCookie('id');
    const cookie_whoami = findCookie('whoami');
    if (cookie_id == "") {
        var the_team = document.getElementById('navbar4');
        var the_member = document.getElementById('navbar5');
        the_team.innerText = "注册";
        the_member.innerText = "登录";
        the_team.href = "refusrer.html";
        the_member.href = "login.html";
    };
    if (cookie_whoami != "root") {
        KillConsole();
    };

}

//delCookie('id');
NoLog();