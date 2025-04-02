// 如果不是纯前端交互请不要使用`location.reload();`刷新, 统一使用后端进行刷新.

function url_encode_str(input) {
    // 对输入字符串进行 URI 编码，确保所有字符都是安全的
    let encoded = encodeURIComponent(input).replace(/%([0-9A-F]{2})/g,
        function(match, p1) {
            return String.fromCharCode('0x' + p1);
        }
    );
    // 对编码后的字符串进行 Base64 编码
    let base64 = window.btoa(encoded);
    // 替换掉 Base64 编码中的 URL 不安全字符
    base64 = base64.replace(/\+/g, '-'); // 替换 + 为 -
    base64 = base64.replace(/\//g, '_'); // 替换 / 为 _
    base64 = base64.replace(/=+$/, '');  // 去除末尾的 =

    return base64;
}


function url_decode_str(input) {
    // 替换回Base64编码中的原始字符
    let base64 = input.replace(/-/g, '+'); // 替换 - 为 +
    base64 = base64.replace(/_/g, '/'); // 替换 _ 为 /
    
    // 由于在编码时去除了末尾的 =，这里需要根据Base64的填充规则补回
    const mod4 = base64.length % 4;
    if (mod4 > 0) {
        base64 += '='.repeat(4 - mod4);
    }
    
    // 对修正后的Base64字符串进行解码
    let decoded = window.atob(base64);
    
    // 对解码后的字符串进行URI解码
    decoded = decodeURIComponent(decoded);

    return decoded;
}

function reload_page(path) {
    window.setTimeout(function () {
        window.location.href = path;
    },300)
}

// post传递数据
function post_data(data, route) {
    console.log("发送信息ing...");
    fetch(route, {
        mode: 'cors',
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: data
    })
    .then(response => {
        if (!response.ok) {
            throw new Error('Network response was not ok');
        }
        console.log("发送成功, 正在校验账号");
    })
    .catch(error => {
        console.log('Error:', error);
    });
}

// 使用async/await来“阻塞”直到响应
async function sendDataAndWaitForResponse(data, route) {
    try {
        const response = await post_data(data, route);
        console.log("响应数据:", response);
    } catch (error) {
        console.error("发生错误:", error.message);
    }
}

// 注册函数
function signup() {
    var id = url_encode_str(document.getElementById('id').value);
    var email = url_encode_str(document.getElementById('email').value);
    var passwd = document.getElementById('passwd').value;
    var passwdagain = document.getElementById('passwdagain').value;
    
    if (passwd === passwdagain) {             
        const data = "id=" + id + "&email=" + email + "&passwd=" + url_encode_str(passwd);
        //post_data(data, '/signupapi');
        post_data(data, '/signupapi');
    } else {
        alert("Error: 密码不一致");
    }
}

// 更新密码函数
function fixpasswd() {
    var oldpasswd = url_encode_str(document.getElementById('old-passwd').value);
    var newpasswd = document.getElementById('new-passwd').value;
    var passwdagain = document.getElementById('passwd-again').value;
    if (newpasswd === passwdagain) {
        const data = "oldpasswd=" + oldpasswd + "&newpasswd=" + url_encode_str(newpasswd);
        post_data(data, '/memberapi');
    } else {
        alert("Error: 密码不一致");
    }
}

// 登录函数
function passwdlogin() {
    var email = url_encode_str(document.getElementById('email').value);
    var passwd = url_encode_str(document.getElementById('passwd').value);
    const data = "email=" + email + "&passwd=" + passwd;
    post_data(data, '/loginapi');
}

// 登出函数
function logout() {
    delCookie('id');
    delCookie('passwd');
    delCookie('whoami');
    /*
     临时用这个, 但是本质上应该是通过js关闭模态框,
     不应该直接刷新增加服务器压力.
    */
    location.reload();
}

// 提交flag
function inputflag(tid){
    flag = url_encode_str(document.getElementById(tid).value);
    const data = "flag=" + flag + "&tid=" + url_encode_str(tid);
    post_data(data, '/flagapi');
    location.reload();
}

/*****************
 * cookie管理函数
*****************/ 

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

/*****************
 * 节点管理函数
*****************/ 

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
        the_team.href = "signup.html";
        the_member.href = "login.html";
    };


    if (cookie_whoami == url_encode_str("member") || cookie_whoami == "") {
        KillConsole();
    };

}

// 存储先前的Cookie值
var previousCookieId = findCookie('id');
var previousCookieWhoami = findCookie('whoami');

// 检查Cookie是否已更改的函数
function checkCookieChanges() {
    var currentCookieId = findCookie('id');
    var currentCookieWhoami = findCookie('whoami');

    if (currentCookieId !== previousCookieId || currentCookieWhoami !== previousCookieWhoami) {
        location.reload();

        previousCookieId = currentCookieId;
        previousCookieWhoami = currentCookieWhoami;
    }
}

// 设置定时器，每秒检查一次Cookie变化
setInterval(checkCookieChanges, 500);
NoLog();


