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

## 自行编译

```bash
git clone https://gitee.com/sakana_ctf/vtf.git
cd vtf
v main.v
./main
```

我们可以在编译时设置参数`-os [linux/windows]`使程序交叉编译到其他平台.

## 二进制文件

```bash
wget https://gitee.com/sakana_ctf/vtf/releases/tag/[版本号]/vtf-[对应版本类型].zip
unzip vtf-[对应版本类型].zip
cd vtf-[对应版本类型]
./vtf-[对应版本类型]
```

