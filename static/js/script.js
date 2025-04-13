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
function ForgetPasswd() {
  showNotification("联系QQ群:882482472", 2000);
}

function alertmess(mess) {
  $('#alertMessage').html(mess);  // 填入要显示的文字
  $('#alertMessage').show();  // 显示弹框
  setTimeout(function () {  // 倒计时
    $('#alertMessage').html(''); // 清空文本
    $('#alertMessage').hide();  // 隐藏弹框
  }, 3000);  // 3秒
}

//提示信息
function showNotification(mess, duration = 1000) {
  var notification = document.createElement('div');
  notification.className = 'notification';
  notification.textContent = mess;
  if (mess.split(':')[0] != 'Error') {
    notification.style.backgroundColor = 'var(--alert-green-url-color)';
    notification.style.border = '1px solid var(--green-outline)';
  }
  document.body.appendChild(notification);
  setTimeout(function () {
    notification.style.opacity = 0;
    setTimeout(function () {
      document.body.removeChild(notification);
    }, 1000);
  }, duration);
}



