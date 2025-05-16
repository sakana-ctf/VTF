// 当前页主要存放用于调用的功能性函数, 本身不会对程序有任何影响.

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
  
/* post传递数据, 以发送a='test1', b='test2'到'/testapi'为例:
 * var test1 = url_encode_str('test1')
 * var test2 = url_encode_str('test2')
 * var data = 'test1=' + test1
 * data += '&test2=' + test2
 * post_data(data, '/testapi')
 */
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
  
// js传输数据url编码
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

function url_str(base64) {
    base64 = base64.replace(/\+/g, '-'); // 替换 + 为 -
    base64 = base64.replace(/\//g, '_'); // 替换 / 为 _
    base64 = base64.replace(/=+$/, '');  // 去除末尾的 =
  
    return base64;
}

// 对vlang传输数据进行url解码
function url_decode_str(input) {
    // 替换回Base64编码中的原始字符
    let base64 = input.replace(/-/g, '+'); // 替换 - 为 +
    base64 = base64.replace(/_/g, '/'); // 替换 _ 为 /
    
    // 由于在编码时去除了末尾的 =，这里需要根据Base64的填充规则补回
    const mod4 = base64.length % 4;
    if (mod4 > 0) {
        base64 += '='.repeat(4 - mod4);
    }
    
    const binaryStr = window.atob(base64);
    
    // 将二进制字符串转换为Uint8Array
    const bytes = new Uint8Array(binaryStr.length);
    for (let i = 0; i < binaryStr.length; i++) {
        bytes[i] = binaryStr.charCodeAt(i);
    } 
    // 使用TextDecoder转换为UTF-8
    const utf8Str = new TextDecoder('utf-8').decode(bytes);
    return utf8Str;
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
  