<div align="center" style="display:grid;place-items:center;">
<p>
    <a href="https://gitee.com/sakana_ctf/vtf" target="_blank"><img width="180" src="./static/image/vtf-logo.svg" alt="VTF logo"></a>
<h1>VTF</h1>
</p>
</div>

# 介绍

VTF是由[vlang](https://vlang.io)搭建的ctf比赛平台, 相比其它平台, VTF具有以下特点:

* 编译到clang, 运行中拥有更高的效率;
* 直接使用自带的veb框架, 无需学习配置其他web框架;
* vlang拥有很方便的交叉编译能力, 可以轻松实现跨平台;
* 支持分屏操作, 在最小屏幕中也能正常使用;
* 由[二次元姛战队](https://gitee.com/sakana_ctf)维护, 二次元含量极高.

# 使用

我们提供了源码与编译好的二进制文件以供使用.

```
./main -h
VTF v2.6.0, CTF competition platform based on the V programming language.
Basic usages:
 运行程序:      main [Options]
 运行程序(设置线程数):  main [walkers] [Options]
Options:
 -h, -help                              显示编码的基本信息并退出.
 -v, --version                          显示版本号并退出.
 -n, --nohup                            守护进程并将日志输出到nohup.out文件(目前只支持在linux设置).
 -p, --port [int]                       设置端口号.
```

### 二进制文件

我们根据情况提供稳定版本用于快速部署服务, 可以通过以下方式直接获取预编译好的源码.

```bash
wget https://gitee.com/sakana_ctf/vtf/releases/tag/[版本号]/vtf-[对应版本类型]
./vtf-[对应版本类型]-[系统类型].zip
unzip vtf-[对应版本类型]-[系统类型].zip
cd vtf-[对应版本类型]-[系统类型]
./main
```

如果不了解也可以在[发行版](https://gitee.com/sakana_ctf/vtf/releases)找到对应版本的文件下载并解压, 文件列表如下:

```
vtf
├── static
│   ├── css
│   ├── image
│   └── js
├── main
└── data.db
```

其中main是执行程序, 使用后data.db是数据库文件, 用于存储本次比赛的所有数据, 无需安装任何东西, 直接运行`./main`可以得到VTF环境.

**注意**: 我们在新版本中禁止了`nohup ./main &`的写法, 请采用`./main -n`或`./main --nohup`代替运行.

## 自行编译

### 依赖

- sqlite3

## 前置条件

### vlang环境

详情参考[vdoc](https://gitee.com/sakana_ctf/vdoc), sakana战队从vlang的基础部署到使用有进行详细描写, 欢迎star.

### vlang下sqlite环境部署

使用之前需自行配置好sqlite环境, 不会太过麻烦:

**Archlinux用户**

```bash
sudo pacman -S sqlite
```

**debian系linux用户**

```bash
sudo apt install sqlite3 libsqlite3-dev
```

**Fedora linux用户**

```bash
sudo dnf -y install sqlite-devel
```

**windows用户**

* 从[sqlite](https://sqlite.org/download.html)下载源zip文件
* 在`v/thirdparty`里面创建一个新的文件夹`sqlite`
* 将 zip 解压缩到该文件夹中

### 编译

#### 获取源码

git用户可以直接使用代码:

```bash
git clone https://gitee.com/sakana_ctf/vtf.git
cd vtf
```

非git用户可以前往网站下载[VTF](https://gitee.com/sakana_ctf/vtf).

#### 初次编译

编译程序只需要执行`v main.v`, 但是在此之前我们推荐先完成`/templates_split/build.v`文件的编译, 便于后续修改html模板:

```bash
v templates_split/build.v
```

#### 调试运行

编译并运行:

```bash
./templates_split/build ; v main.v ; ./main 
```

以上代码先将`templates_split`文件夹下的所有文件编译到`templates`, 然后编译主程序, 最后运行主程序.

#### 服务器运行

**注意**: 我们在新版本中禁止了`nohup ./main &`的写法, 请采用`./main -n`或`./main --nohup`代替运行.

# 支持

| 需求          | 当前情况                                                                         | 检验人                  |
|:-----------:|:----------------------------------------------------------------------------:|:--------------------:|
| 版本号         | v2.6.0(实现基本的root权限分配和控制台)                                  | sudopacman           |
| wiki版本号     | 当前跟随到v2.1.0                                                                  | sudopacman           |
| 数据测试        | 在1核1G的debian服务器进行100位用户注册测试, 已修复bug, 可正常使用                                   | sudopacman, Kengwang |
| 测试反馈        | 存在资源印用错误, 现已修复                                                               | secret               |
| 测试反馈        | 存在题目未格式化问题, 现暂用替代方案                                                          | adwa                 |
| firefox兼容问题 | 已最低限度适配                                                  |   sudopacman, VintageGameBoy                   |
| 说明书         | 已修正debian脚本错误                                                                | H4nn4h               |
| 线程设置        | 当前veb框架暂不支持                                                                  |                      |
| 登录安全        | 实现登录函数`login_status`, 其他路由已完善                                                | sudopacman           |
| 黑名单         | 禁止选手访问, 将移动在控制台设置                                                             |                      |
| 题目          | 支持提交flag                                                                     | sudopacman           |
| 多flag设置     | 已实现                                                                          | sudopacman           |
| 数据库         | 当前仅支持sqlite3数据库                                                              | sudopacman           |
| 错误显示        | 等待重写, 目前js上统一使用`showinfo(${mess})`显示错误                                          | sudopacman           |
| 排行榜         | 实现基本的图形表格, 待实现数据拉取功能                                                                          | sudopacman           |
| 一血, 二血, 三血  | 将重新调整数据库                                                                     |                      |                   |
| 中英文显示问题     | 在`/templates_split/language`中添加语言, 脚本问题待解决                                                                          |                      |
| html批量修改    | 删除主程序调用html构建脚本功能, 推荐使用`./templates_split/build ; v main.v ; ./main`指令进行调试运行, 当前需要重构语言部分, 重新拆分编译规则 | sudopacman           |

# 参与贡献

vtf是一项很大的工程, 我们欢迎大家参与提交维护, 我们提供相关资料方便大家进行学习:

## vlang语言

vtf基于vlang, 以下可以参考[sakana_ctf/vdoc](https://gitee.com/sakana_ctf/vdoc)进行学习

## wiki

vtf编写符合[wiki](https://gitee.com/sakana_ctf/vtf.wiki.git)规范, 参与贡献前请对wiki进行了解.

## 提交

提交代码的方式可以参考文章: [怎么在GitHub上为开源项目作贡献](https://zhuanlan.zhihu.com/p/23457016), 需要实现/维护的功能已经写在[支持](#支持)中, 也可以在[issues](https://gitee.com/sakana_ctf/vtf/issues)上就功能问题进行提问.

# VY许可证说明

VTF采用VY通用许可证, 以下是简易解释, 详情参考[LICENSE](./LICENSE):

在不进行个人补充的情况下VY许可证又称为VY通用许可证, 公开使用时只需标注社(VYCMa.png)标或声明源码来自VYCMa, 便可以免费修改和商用素材.

对于分发问题, 为方便更多人理解, 在VY许可证中有重新定义"版权转移"概念: 他人修改源码后可以闭源, 每个修改过的文件需放置版权说明, 如果要进行公开展示需标注作者个人的标志,若作者无特殊说明需标注社标(VYCMa.png)标或声明源码来自VYCMa.

![](./static/image/VYCMa.webp)
