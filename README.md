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
sudo apt install sqlite3
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



# VY许可证说明

在不进行个人补充的情况下VY许可证又称为VY通用许可证, 公开使用时只需标注社(VYCMa.png)标或声明源码来自VYCMa, 便可以免费修改和商用素材.

对于分发问题, 为方便更多人理解, 在VY许可证中有重新定义"版权转移"概念: 他人修改源码后可以闭源, 每个修改过的文件需放置版权说明, 如果要进行公开展示需标注作者个人的标志,若作者无特殊说明需标注社标(VYCMa.png)标或声明源码来自VYCMa.

![](./image/VYCMa.png)
