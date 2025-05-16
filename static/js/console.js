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

// 阻止上传文件的跳转行为
var filesChallenges = [];
document.querySelectorAll('.drop-zone').forEach(function(zone) {
  zone.addEventListener('dragover', function(e) {
    e.preventDefault(); // 阻止默认行为
    e.stopPropagation(); // 阻止事件冒泡
  });

  zone.addEventListener('drop', function(e) {
    e.preventDefault(); // 阻止默认行为
    e.stopPropagation(); // 阻止事件冒泡

    var files = e.dataTransfer.files;
    var fileList = zone.querySelector('.file-list'); // 使用当前drop-zone的文件列表容器
    //fileList.innerHTML = ''; // 清空现有文件信息

    Array.from(files).forEach(function(file) {
      // 创建文件信息元素
      var fileItem = document.createElement('div');
      fileItem.className = 'file-item';

      // 创建文件名称元素
      var fileName = document.createElement('span');
      fileName.className = 'file-name';
      fileName.textContent = file.name;
      fileItem.appendChild(fileName);

      // 创建删除按钮元素
      var deleteBtn = document.createElement('ion-icon');
      deleteBtn.setAttribute('name', 'close-circle-outline');
      deleteBtn.classList.add('delete-btn');
      deleteBtn.addEventListener('click', function() {
        // 从 filesChallenges 中移除对应的文件
        const fileIndex = Array.prototype.findIndex.call(fileItem.parentNode.children, function(child) {
          return child === fileItem;
        });
        if (fileIndex !== -1) {
          filesChallenges.splice(fileIndex, 1);
        }
        // 删除文件信息元素
        fileItem.remove();
      });
      fileItem.appendChild(deleteBtn);
      fileList.appendChild(fileItem);
      // 读取文件内容并转换为 Base64 编码
      const reader = new FileReader();
      reader.onload = function(event) {
        const base64Data = event.target.result.split(',')[1]; // 提取 Base64 编码部分
        filesChallenges.push([
          url_encode_str(file.name),
          url_str(base64Data)
        ]);
      };
      reader.readAsDataURL(file);
    });
  });
});

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
  //data += "&file=" + file;
  data += "&container=" + container;
  data += "&file=" + filesChallenges;
  post_data(data, '/challengeapi/add');
}