// 注册函数
function refusrer() {
    var id = document.getElementById('id').value;
    var email = document.getElementById('email').value;
    var passwd = document.getElementById('passwd').value;
    var passwdagain = document.getElementById('passwdagain').value;
    if (passwd === passwdagain){
    } else {
        alert("Error: 密码不一致");
    }
}

// 对非权限用户去掉console节点
function KillConsole() {
    var the_console = document.getElementsByClassName('navbar-list')[0];
    the_console.removeChild(the_console.firstElementChild);
}


// 对未登录用户修改为注册和登录节点
function NoLog() {
    var the_team = document.getElementById('navbar4');
    var the_member = document.getElementById('navbar5');
    the_team.innerText = "注册";
    the_member.innerText = "登录";
    the_team.href = "refusrer.html";
    the_member.href = "login.html";
}

NoLog();
KillConsole();
