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

// 对数据翻页进行控制
function SetPage(number, nowtext) {
    var element = document.getElementById("set_page");
    page = document.getElementById("page");
    page.innerHTML = "";
    element.firstChild.setAttribute("onclick", "Rankapi(1);");
    page.appendChild(element);
    j = nowtext < 4 ? 1 : nowtext - 3;
    for (i=0;i<(number < 7 ? number : 7);i++) {
        k = i + j;
        var clone = element.cloneNode(true);
        if (k == nowtext) { clone.firstChild.className = "active" };
        clone.firstChild.innerHTML = k;
        clone.firstChild.setAttribute("onclick", "Rankapi("+k+");");
        if (k <= number) { page.appendChild(clone); }
    }
    var clone = element.cloneNode(true);
    clone.firstChild.innerHTML = '»';
    clone.firstChild.setAttribute("onclick", "Rankapi("+number+");");
    page.appendChild(clone);
}

// 对数据进行执行, 需要重排序, 并按输出结果抽取
function SetRankJson(data, nowtext) {
    data = JSON.parse(data);
    //按照升序排列
    function down(x, y) {
	    return y.score - x.score;
    }
    //data是上面数据名，需要先引入，然后sort函数中放up函数，就可以实现对接送进行排序
    data.sort(down);

    SetPage(Math.ceil(data.length / 10), nowtext);
    for (i in data.slice((nowtext-1)*10, nowtext*10)) {
        var rank = "td" + i + "_rank";
        document.getElementById(rank).innerHTML = parseInt(i)+1;
        var team_id = "td" + i + "_team_id";
        document.getElementById(team_id).innerHTML = data[i].team_id;
        var score = "td" + i + "_score";
        document.getElementById(score).innerHTML = data[i].score;
        for (j in data[i].task) {
            var task = "td" + i + "_" + j;
            //alert(task);
            document.getElementById(task).innerHTML = data[i].task[j];
            //alert(j);
            //
        }
        //console(id);
        //alert(id);
    }
}

window.addEventListener('beforeunload', function() {
    sessionStorage.removeItem('obj');
    }
);

// 使用示例
function Rankapi(nowtext) {
    // 读取缓存信息
    str = sessionStorage.obj;
    if (str == undefined) {
        GetRankData(function (data) {
            sessionStorage.obj = data;
            SetRankJson(data, nowtext);
        });
    } else {
        // 这里还是有问题, 刷新以后按道理应该读取新的数据.
        SetRankJson(str, nowtext);
        console.log('old ranking data.')
    }
}
