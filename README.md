<div align="center" style="display:grid;place-items:center;">
<p>
    <a href="https://gitee.com/sakana_ctf/vtf" target="_blank"><img width="180" src="./image/vtf-logo.svg" alt="VTF logo"></a>
<h1>VTF</h1>
</p>
</div>

# 介绍

VTF是由[vlang](https://vlang.io)搭建的ctf比赛平台, 相比其它平台, VTF具有以下特点:

* 编译到clang, 运行中拥有更高的效率;
* 直接使用自带的vweb框架, 无需学习配置其他web框架;
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
sudo apt install sqlite3, libsqlite3-dev
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

```bash
git clone https://gitee.com/sakana_ctf/vtf.git
cd vtf
wget https://gitee.com/sakana_ctf/vtf/releases/tag/[版本号]/vtf-[对应版本类型]
./vtf-[对应版本类型]
```

# 支持

| 需求          | 当前情况                                  | 检验人        |
|:-----------:|:-------------------------------------:|:----------:|
| wiki版本号 | 当前跟随到v1.1.0 | sudopacman |
| firefox兼容问题 | js部分未支持, 可能需要重构源码                               |            |
| edge兼容问题    | 已适配                                   | sudopacman |
| 线程设置        | 当前可以直接设置进程数, 未配置变量执行                  | sudopacman |
| 登录措施        | 普通用户登录与注册                             | sudopacman |
| 管理员         | 未支持                                   |            |
| 非member视角       |  未支持       |                    |
| 权限区分       |  未实现, 考虑使用新函数统一区分权限       |                    |
| 登录状态维持      | 当前页基本解决                               | sudopacman |
| 登录安全          | 参考`\member.html`路由, 未检查其他页面 | sudopacman |
| 题目          | 已支持显示题目,当前支持提交flag                    | sudopacman |
| 多flag设置     | `[]string`无法通过sqlite传递, 需设置fkey创建子db. |            |
| 数据库         | 当前仅支持sqlite3数据库                       | sudopacman |
| 数据库安全       | 使用base64编码数据进行导入取出                                   | sudopacman           |
| 登录-cookie-数据库密码系统 |  考虑设计一套4k门以下密码系统应对数据库泄露  |  |
| 错误显示        | 已重构, js上统一使用`showinfo(${mess})`显示错误                                   | sudopacman           |
| 提交flag      | 提交flag过程已完善, 未设置题目db                  | sudopacman |
| 提交更新        | 基础更新原理已实现, 未进行详细设置                    | sudopacman |
| 函数分离        | 分离多个文件, 还未进行权限管理                      | sudopacman |
| 动态计分        | 动态计算分值(需重改数据库?)                       |            |
| 线程数设置      | 支持自定义线程数(默认为3)  | sudopacman |
| html分块编辑    | 待重构                         |            |

| 中英文显示问题   | 未考虑实现方式                         |            |
| 数据可视化      |  考虑使用godot接管数据                         |            |


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

![](./image/VYCMa.png)
