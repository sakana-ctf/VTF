init();


function init() {
    // 排位页数设置
    Rankapi(1);
}


/*******************************
 * 工具类函数
*******************************/

// 获取数据
function GetRankData(callback) {
    fetch('/rankapi')
        .then(response => {
            if (response.status === 200) {
                console.log("发送成功, 尝试拉取排行榜数据");
                return response.text();
            }
            throw new Error("请求失败，状态码：" + response.status);
        })
        .then(data => {
            callback(data);
        })
        .catch(error => {
            console.error("请求排行榜数据出错:", error);
        });
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

// 寻找最大时间
function getMaxTime(timeArray) {
    return timeArray.reduce((max, current) => {
        const currentTime = new Date(current);
        return max > currentTime ? max : currentTime;
    }, new Date(0));
}

// 定位离散点
function getDatasets(XList, YList) {
    var y = 0;
    var Datasets = XList
        .map((x, index) => ({x: x, y: YList[index]}))
        .filter(point => point.y !== -1);
    Datasets.sort((a, b) => a.x - b.x);
    for (i of Datasets) {
        y += i.y;
        i.y = y;
    }
    return Datasets;
}

// 获取时间字符串
function getTimeString(time) {
    const date = new Date(time*1000);
    const pad = num => num.toString().padStart(2, '0');
    return `${date.getFullYear()}-${pad(date.getMonth()+1)}-${pad(date.getDate())} ${pad(date.getHours())}:${pad(date.getMinutes())}`;
}

function getShortTimeString(time) {
    const date = new Date(time);
    const pad = num => num.toString().padStart(2, '0');
    return `${pad(date.getHours())}:${pad(date.getMinutes())}`;
}

/*******************************
 * 使用类函数
*******************************/

// 绘制排行榜图表
function find_ranking_line(data, starttime, endtime) {
    // todo: 这里需要重新改一下图表, 不然效果实际上挺差的.
    var canvas = document.getElementById('myChart');
    /*
    var nowtime = new Date().getTime();
    if (endtime >= (nowtime / 1000)) {
        endtime = nowtime / 1000;
    }
    labels = [getTimeString(new Date(starttime))];
    const timeDiff = endtime - starttime;
    const interval = timeDiff / 30;

    var currentTime = starttime;
    for (let i = 0; i < 3; i++) {
        currentTime += interval;
        labels.push(getShortTimeString(new Date((parseInt(currentTime)))));

        if (currentTime > endtime) {
            break;
        }
    }
    labels.push(getTimeString(new Date(parseInt(endtime))));
    console.log(labels);
    */
    var datasets = [];
    var color = [214, 107, 137];
    for (i of data) {
        datasets.push({
            label: i.team_id,
            data: getDatasets(i.kill_time, i.score),
            backgroundColor: 'rgba('+color[0]+', '+color[1]+', '+color[2]+', 0.2)',
            borderColor: 'rgb('+color[0]+', '+color[1]+', '+color[2]+')',
            borderWidth: 1
        });
        color[0] = (color[0] * 2) % 255;
        color[1] = (color[1] * 2) % 255;
        color[2] = (color[2] * 2) % 255;
    }
    ranking_line(canvas, datasets);
}

// 对数据进行执行, 需要重排序, 并按输出结果抽取
function SetRankJson(data, nowtext) {
    nowtext = parseInt(nowtext);
    data = data.split('\n');
    starttime = parseInt(data[0]);
    endtime = parseInt(data[1]);
    data = JSON.parse(data[2]);
    // 移除whoami != 'member'的数据
    data = data.filter(item => item.whoami == 'member');
    //按照升序排列
    function down(x, y) {
        const x_score = x.score.reduce((sum, score) => sum + (score !== -1 ? score : 0), 0);
        const y_score = y.score.reduce((sum, score) => sum + (score !== -1 ? score : 0), 0);
        
        if (x_score === y_score) {
            const x_kill_time = getMaxTime(x.kill_time);
            const y_kill_time = getMaxTime(y.kill_time);
            return x_kill_time - y_kill_time;
        }
        return y_score - x_score;
    }

    //sort函数中放up函数，就可以实现对接送进行排序
    data.sort(down);

    if (data.length >= 5) {
        find_ranking_line(data.slice(0, 5), starttime, endtime);
    } else {
        find_ranking_line(data, starttime, endtime);
    }

    show_data = data.slice((nowtext - 1) * 10, nowtext * 10);
    SetPage(Math.ceil(data.length / 10), nowtext);

    for (i=0; i<10; i++) {
        var rank = "td" + i + "_rank";
        document.getElementById(rank).innerHTML = '';
        var team_id = "td" + i + "_team_id";
        document.getElementById(team_id).innerHTML = '';
        var score = "td" + i + "_score";
        document.getElementById(score).innerHTML = '';
        for (k in data[0].task) {
            var challenge = "td" + i + "_" + k;
            document.getElementById(challenge).innerHTML = '';
        }
    }

    for (i in show_data) {
        j = parseInt(i) + (nowtext - 1) * 10;
        var rank = "td" + i + "_rank";
        document.getElementById(rank).innerHTML = j+1;
        var team_id = "td" + i + "_team_id";
        document.getElementById(team_id).innerHTML = show_data[i].team_id;
        var score = "td" + i + "_score";
        var all_score = 0;
        for (k in show_data[i].score) {
            var challenge = "td" + i + "_" + k;
            if ( show_data[i].score[k] == -1 ) {
                document.getElementById(challenge).innerHTML = '';
            } else {
                document.getElementById(challenge).innerHTML = '★';
                all_score += show_data[i].score[k];
            }
        }
        document.getElementById(score).innerHTML = all_score;
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
