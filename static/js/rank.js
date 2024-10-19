function GetRankData(callback) {
    const XHR = new XMLHttpRequest();

    // 为了简化代码, 未对错误情况进行处理
    XHR.addEventListener("load", function () {
        if (XHR.status === 200) {
            console.log("发送成功, 尝试拉取排行榜数据");
            callback(XHR.responseText);
        }
    });
    XHR.open('GET', '/rankapi');
    XHR.send();
}


function SetRankJson(data) {
    data = JSON.parse(data);
    for (i of data) {
        alert(i);
    }
}

// 使用示例
function Rankapi() {
    // 读取缓存信息
    str = sessionStorage.obj;
    if (str == undefined) {
        GetRankData(function (data) {
            sessionStorage.obj = data;
            SetRankJson(data);
        });
    } else {
        // 这里还是有问题, 刷新以后按道理不会再进行读取.
        SetRankJson(str);
        alert('true')
    }
}
