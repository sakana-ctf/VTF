/* 测试事件:
 * 通用测试事件, 主要用于
*/

// 平滑移动.
document.addEventListener('DOMContentLoaded', function () {
    var links = document.querySelectorAll('#sidebar .nav a');
    links.forEach(function (link) {
        link.addEventListener('click', function (event) {
            // 获取id，去掉#
            event.preventDefault();
            var targetId = this.getAttribute('href').substring(1);
            var targetElement = document.getElementById(targetId);
            if (targetElement) {
                targetElement.scrollIntoView({ behavior: 'smooth' });
            }
        });
    });
});

// 设置图表.
var canvas1 = document.getElementById('canvas1');
var canvas2 = document.getElementById('canvas2');
ranking_doughnut(canvas1);
ranking_polararea(canvas2);

// 代替的通用测试事件.
function updateTitle() {
    alert(1);
}

function updatePlatform() {
    alert(8);
}

// 设置名称
function updateTitleName() {
  var title_name = getInputValue('title_name');
  var data = "title_name=" + title_name;
  post_data(data, '/setapi/title');
}

// 设置index页
function updateIndex() {
  var textareaElement = document.getElementById('index').value;
  var data = "index=" + url_encode_str(textareaElement);
  post_data(data, '/setapi/index');
}

// 设置开始, 结束的时间事件
function updateTime() {
  const time_zone = getInputValue('time_zone');
  const startTime = document.getElementById('startTime').value;
  const endTime = document.getElementById('endTime').value;
  const data = "time_zone=" + time_zone + "&starttime=" + url_encode_str(startTime) + "&endtime=" + url_encode_str(endTime);
  post_data(data, '/setapi/time');
}

function getInputValue(selectName) {
    var inputElement = document.getElementById(selectName);
    if (inputElement.type === 'checkbox') {
      return url_encode_str(inputElement.checked);
    } else {
      return url_encode_str(inputElement.value);
    }
  }

  function getSelectedOptionText(selectName) {
    var selectElement = document.getElementById(selectName);
    var selectedValue = selectElement.value;
    if (selectedValue == 0) {
      return getInputValue(selectName + '_x')
    }
    for (var i = 1; i < selectElement.options.length; i++) {
      if (selectElement.options[i].value === selectedValue) {
        return url_encode_str(selectElement.options[i].textContent);
      }
    }
    return '';
  }

// 添加挑战
  function addChallenge() {
    // 获取表单元素
    const typeText = getSelectedOptionText('type_text');
    const flag = getInputValue('flag');
    const name = getInputValue('name');
    const diff = getSelectedOptionText('diff');
    const intro = getInputValue('intro');
    const maxScore = getInputValue('max_score');
    const score = getInputValue('score');
    const container = getInputValue('container');

    var data = "type_text=" + typeText;
    data += "&flag=" + flag;
    data += "&name=" + name;
    data += "&diff=" + diff;
    data += "&intro=" + intro;
    data += "&max_score=" + maxScore;
    data += "&score=" + score;
    data += "&container=" + container;
    post_data(data, '/challengeapi/add');
  }
