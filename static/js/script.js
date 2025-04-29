// 当前页用于存放不同路由的控制函数与一些初始化代码, 当前页应该严格控制全局变量等状态.

/**
 * 缩小页打开侧页部分函数
 */
const addEventOnElements = function (elements, eventType, callback) {
  for (let i = 0, len = elements.length; i < len; i++) {
    elements[i].addEventListener(eventType, callback);
  }
};
const navbar = document.querySelector("[data-navbar]");
const navTogglers = document.querySelectorAll("[data-nav-toggler]");
const toggleNav = () => {
  navbar.classList.toggle("active");
  document.body.classList.toggle("nav-active");
};
addEventOnElements(navTogglers, "click", toggleNav);

// 存储先前的Cookie值
var previousCookieId = findCookie('id');
var previousCookieWhoami = findCookie('whoami');
// 设置定时器，每秒检查一次Cookie变化
setInterval(checkCookieChanges, 500);
var lastClickTime = 0;
NoLog();

/**
 * 提示模块
 */

// 忘记密码
function ForgetPasswd() {
  showNotification("联系QQ群:882482472", 2000);
}

/**
 * 功能函数
 */

// 注册函数
function signup() {
  const currentTime = Date.now(); // 获取当前时间
  if (currentTime - lastClickTime < 5000) { // 如果距离上次点击时间小于10秒
      showNotification("Error: 操作频繁");
      return; // 阻止进一步操作
  }
  lastClickTime = currentTime; // 更新上次点击时间
  var id = url_encode_str(document.getElementById('id').value);
  var email = url_encode_str(document.getElementById('email').value);
  var passwd = document.getElementById('passwd').value;
  var passwdagain = document.getElementById('passwdagain').value;
  
  if (passwd === passwdagain) {             
      const data = "id=" + id + "&email=" + email + "&passwd=" + url_encode_str(passwd);
      //post_data(data, '/signupapi');
      post_data(data, '/signupapi');
  } else {
      showNotification("Error: 密码不一致");
  }
}

// 更新密码函数
function fixpasswd() {
  const currentTime = Date.now(); // 获取当前时间
  if (currentTime - lastClickTime < 5000) { // 如果距离上次点击时间小于10秒
      showNotification("Error: 操作频繁");
      return; // 阻止进一步操作
  }
  lastClickTime = currentTime; // 更新上次点击时间
  var oldpasswd = url_encode_str(document.getElementById('old-passwd').value);
  var newpasswd = document.getElementById('new-passwd').value;
  var passwdagain = document.getElementById('passwd-again').value;
  if (newpasswd === passwdagain) {
      const data = "oldpasswd=" + oldpasswd + "&newpasswd=" + url_encode_str(newpasswd);
      post_data(data, '/memberapi');
  } else {
      showNotification("Error: 密码不一致");
  }
}

// 登录函数
function passwdlogin() {
  const currentTime = Date.now(); // 获取当前时间
  if (currentTime - lastClickTime < 5000) { // 如果距离上次点击时间小于10秒
      showNotification("Error: 操作频繁");
      return; // 阻止进一步操作
  }
  lastClickTime = currentTime; // 更新上次点击时间
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
  location.reload();
}

// 提交flag函数
function inputflag(tid){
  flag = url_encode_str(document.getElementById(tid).value);
  const data = "flag=" + flag + "&tid=" + url_encode_str(tid);
  post_data(data, '/flagapi');

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

// 检查Cookie是否已更改的函数
function checkCookieChanges() {
  var currentCookieId = findCookie('id');
  var currentCookieWhoami = findCookie('whoami');
  var mess = findCookie('mess');

  if (currentCookieId !== previousCookieId || currentCookieWhoami !== previousCookieWhoami) {
      location.reload();

      previousCookieId = currentCookieId;
      previousCookieWhoami = currentCookieWhoami;
  }
  
  if (mess != "") {
      showNotification(url_decode_str(mess));
      delCookie("mess");
  }
}








