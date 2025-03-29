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

我们提供了源码与编译好的二进制文件以供使用:

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

### 配置

### 依赖

- sqlite3

### 自行编译

```bash
git clone https://gitee.com/sakana_ctf/vtf.git
cd vtf
v main.v
./main
```

我们可以在编译时设置参数`-os [linux/windows]`使程序交叉编译到其他平台.

### 二进制文件

我们也不定期提供稳定版本用于快速部署服务, 可以通过以下方式直接获取预编译好的源码.

```bash
wget https://gitee.com/sakana_ctf/vtf/releases/tag/[版本号]/vtf-[对应版本类型]
./vtf-[对应版本类型]-[系统类型].zip
unzip vtf-[对应版本类型]-[系统类型].zip
cd vtf-[对应版本类型]-[系统类型]
./main
```

# 运行

## 调试运行

调试运行方便对于修改源码过程中快速看见代码的更新情况, 在第一次进行调试前推荐先编译修改提交html文件的子件:

```bash
v ./templates_split/build.v
```

在每次更新后可以运行以下代码:

```shell
./templates_split/build ; v main.v ; ./main
```

## 服务器运行

在正式的服务器环境中推荐使用以下指令在后台运行:

```bash
nohup ./main &
```

# 支持

| 需求          | 当前情况                                                                         | 检验人                  |
|:-----------:|:----------------------------------------------------------------------------:|:--------------------:|
| 版本号         | v2.5.2(兼容firefox, 填充后端内容)                                                              | sudopacman           |
| wiki版本号     | 当前跟随到v2.1.0                                                                  | sudopacman           |
| 数据测试        | 在1核1G的debian服务器进行100位用户注册测试, 已修复bug, 可正常使用                                   | sudopacman, Kengwang |
| 测试反馈        | 存在资源印用错误, 现已修复                                                               | secret               |
| 测试反馈        | 存在题目未格式化问题, 现暂用替代方案                                                          | adwa                 |
| firefox兼容问题 | 已最低限度适配                                                  |   sudopacman                   |
| 说明书         | 已修正debian脚本错误                                                                | H4nn4h               |
| edge兼容问题    | 已适配                                                                          | sudopacman           |
| 线程设置        | 当前veb框架暂不支持                                                                  |                      |
| 登录措施        | 普通用户登录与注册                                                                    | sudopacman           |
| 管理员         | 未支持                                                                          |                      |
| 非member视角   | 未支持                                                                          |                      |
| 权限区分        | 未实现, 考虑使用新函数统一区分权限                                                           |                      |
| 登录状态维持      | 当前页基本解决                                                                      | sudopacman           |
| 登录安全        | 实现登录函数`login_status`, 其他路由已完善                                                | sudopacman           |
| 黑名单         | 禁止选手访问, 预计下一版本支持                                                             |                      |
| 题目          | 支持提交flag                                                                     | sudopacman           |
| 多flag设置     | 已实现                                                                          | sudopacman           |
| 数据库         | 当前仅支持sqlite3数据库                                                              | sudopacman           |
| 数据库安全       | 统一使用base64编码, sha256单向加密传递数据                                                 | sudopacman           |
| 错误显示        | 已重构, js上统一使用`showinfo(${mess})`显示错误                                          | sudopacman           |
| 提交更新        | 已完成                                                                          | sudopacman           |
| 函数分离        | 已分离成多个模块                                                                     | sudopacman           |
| 排行榜         | 已完成                                                                          | sudopacman           |
| 动态计分        | 已更新                                                                          |                      |
| 一血, 二血, 三血  | 将重新调整数据库                                                                     |                      |
| 线程数设置       | 当前重构版本不支持设置线程                                                                |                      |
| html分块编辑    | 使用复杂脚本替代编辑问题                                                                 | sudopacman           |
| ip检测功能      | 支持最基础的ip检测                                                                   | sudopacman           |
| 图片格式 | 已优化                                                             | sudopacman           |
| 中英文显示问题     | 应支持多语言, 在`/templates_split/language`中添加语言                                                                          |                      |
| 数据可视化       | 使用js实现简单的可视化                                        |                      |
| html批量修改    | 删除主程序调用html构建脚本功能, 推荐使用`./templates_split/build ; v main.v ; ./main`指令进行调试运行, 当前需要重构语言部分, 重新拆分编译规则 | sudopacman           |
| 后台功能    | 已实现基本 | sudopacman           |
| 日志功能    | 为弥补新版本vlang的问题采用了替代方案, 将在未来修复bug后解决日志问题 | sudopacman           |

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
