<div align="center" style="display:grid;place-items:center;">
<p>
    <a href="https://github.com/sakana-ctf/VTF" target="_blank"><img width="180" src="./static/image/vtf-logo.svg" alt="VTF logo"></a>
<h1>VTF</h1>
</p>
</div>

# Introduction

English|[中文](./README_CN.md)
 
VTF is a CTF competition platform built with [Vlang](https://vlang.io). Compared to other platforms, VTF has the following features:
 
* Compiled with Clang for higher runtime efficiency.
* Uses built-in Veb framework without needing to learn other web frameworks.
* Vlang's cross-compilation capabilities enable easy cross-platform deployment.
* Supports split-screen operations for normal use on minimal screens.
* Developed with a minimalist philosophy for quick deployment.
* Maintained by [Sakana Team](https://vycma.xyz/sakana) with high anime energy.
 
# Usage
 
We provide both source code and precompiled binaries for use.

```
./main -h
VTF v2.6.1-alpha, CTF competition platform based on the V programming language.
Basic usages:
 运行程序:      main [Options]
 运行程序(设置线程数):  main [walkers] [Options]
Options:
 -h, -help                              显示编码的基本信息并退出.
 -v, --version                          显示版本号并退出.
 -n, --nohup                            守护进程并将日志输出到nohup.out文件(目前只支持在linux设置).
 -p, --port [int]                       设置端口号.
 -d, --database [string]                设置使用的数据库名.
```

### Binaries
 
We provide stable releases for quick deployment. You can directly download precompiled binaries using:
 
```bash
wget https://github.com/sakana-ctf/VTF/releases/tag/[version]/vtf-[edition]
unzip vtf-[edition]-[system].zip
cd vtf-[edition]-[system]
./main
```

For detailed versions, visit our https://github.com/sakana-ctf/VTF/releases. The file structure is:

```
vtf
├── static
│   ├── css
│   ├── image
│   └── js
├── main
└── data
    ├── README.md
    └── data.db
```

Where `main` is the executable program that, when used, creates a database file. For example, it defaults to creating `data.db` as the database file stored in the `data` folder. The database file stores all data for the current competition. There is no need to install anything; simply running `./main` will give you the VTF environment.

**Note**: The `nohup ./main &` syntax is deprecated. Use `./main -n` or `./main --nohup` instead.

### Self-Compilation

#### Dependencies

sqlite3

#### Prerequisites

##### Vlang Environment

See detailed instructions in https://gitee.com/sakana_ctf/vdoc. The Sakana Team provides comprehensive guides from basic deployment to usage - welcome to star!

##### SQLite Configuration for Vlang

Configure SQLite before use:

**Archlinux Users**

```bash
sudo pacman -S sqlite
```

**Debian-based Users**

```bash
sudo apt install sqlite3 libsqlite3-dev
```

**Fedora Users**

```bash
sudo dnf -y install sqlite-devel
```

**Windows Users**

* Download SQLite zip from https://sqlite.org/download.html.
* Create sqlite folder in `v/thirdparty`.
* Extract zip to this folder.

#### Compilation

##### Get Source Code

Git users:

```bash
git clone https://github.com/sakana_ctf/vtf.git
cd vtf
```

Non-git users can download from https://github.com/sakana-ctf/VTF.

##### Initial Compilation

Compile templates first for easier HTML modification:

```bash
v templates_split/build.v
```

##### Debug Run

Compile and run:

```bash
./templates_split/build ; v main.v ; ./main
```

This compiles `templates_split` to `templates`, then the main program, and finally runs it.

##### Server Operation
**Note**: The nohup ./main & syntax is deprecated. Use ./main -n or ./main --nohup instead.

# Support Matrix

| Feature        | Current Status                                                                 | Verified By                  |
|:-----------:|:----------------------------------------------------------------------------:|:--------------------:|
| Version         | v2.6.0 (Basic root permission allocation and console implemented)                  | sudopacman           |
| Wiki Version     | Currently at v2.1.0, pending update                                                  | sudopacman           |
| Stress Test        | 100-user registration test passed on 1-core 1G Debian server                                   | sudopacman, Kengwang |
| Bug Fix        | Resource reference error fixed                                                               | secret               |
| Format Fix        | Temporary solution for unformatted challenge display                                          | adwa                 |
| Firefox Compatibility | Minimum adaptation achieved                                  | sudopacman, VintageGameBoy                   |
| Manual Fix         | Debian script error corrected                                                | H4nn4h               |
| Thread Settings        | Not supported by current Veb framework                                                  |                      |
| Login Security        | `login_status` function implemented, other routes improved                                | sudopacman           |
| Blacklist         | Contestant access restriction moved to console settings                                             |                      |
| Challenge Submission        | Flag submission supported                                                     | sudopacman           |
| Multi-Flag Settings     | Implemented                                                          | sudopacman           |
| Database         | SQLite3 only                                                              | sudopacman           |
| Error Display        | To be rewritten, currently using `showinfo(${mess})` in JS                                          | sudopacman           |
| Leaderboard         | Basic graphical table implemented, data fetching pending                                                          | sudopacman           |
| Blood Rankings  | Database restructuring needed                                                     |                      |                   |
| Localization         | Add languages in `/templates_split/language`, script issues pending                                                          |                      |	

# Contribution

VTF is a large project. Contributions are welcome! We provide learning materials:

## Vlang Language

VTF is based on Vlang. Learn through [sakana_ctf/vdoc](https://gitee.com/sakana_ctf/vdoc)

## Wiki

VTF follows [wiki](https://github.com/sakana-ctf/vtf.wiki.git) standards. Please familiarize yourself with the wiki before contributing.

## Submission

Follow this guide: [How to Contribute to Open Source Projects on GitHub](https://zhuanlan.zhihu.com/p/23457016). Features to implement/maintain are listed in the [Support Matrix](#support-matrix). You can also ask questions in [issues](https://github.com/sakana-ctf/VTF/issues).

# VY License

VTF uses the VY Universal License. Simplified explanation below. For full details, see [LICENSE](./LICENSE):

The VY License allows free modification and commercial use with attribution to VYCMa (using VYCMa.png logo or stating "Source from VYCMa"). 

Regarding redistribution: Modified code can be closed-source. Each modified file must include copyright notice. Public displays require author attribution (personal logo if specified, otherwise VYCMa.png or "Source from VYCMa").
