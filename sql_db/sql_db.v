module sql_db

import db.sqlite
import log

/************************************
 * emmmm, 这里应该重新限制public的权限
 * 但是现在还不是时候
************************************/

/*************
 * 数据库类型
*************/

// 登录信息

@[table: 'personal']
pub struct Personal {
    pub:
        pid             int                 @[primary; sql:serial]
        id              string
        email           string
        passwd          string
        whoami          string
        task            []PersonalFlag      @[fkey: 'parents_id']
}

// Personal-task对照表.
@[table: 'personal_flag']
pub struct PersonalFlag {
    pub:
        parents_id          int
        parents_task        int
        complete            string
}


// 题目信息

@[table: 'task']
pub struct Task{
    pub:
        tid        int              @[primary; sql:serial]
        type_text  string
        flag       []PostFlag       @[fkey: 'parents_task']
        task       []PersonalFlag   @[fkey: 'parents_task']
        name       string
        diff       string
        intro      string
        max_score  int
        score      int
        container  bool
}

@[table: 'post_flag']
pub struct PostFlag {
        parents_task    int
    pub mut:
        flag            string
}

@[table: 'black_list']
struct BlackList {
    pub:
        ip          string             @[primary]
        id          []BlackId          @[fkey: 'id']
}

// 我们有理由怀疑作弊者不止使用了一个账号.

@[table: 'black_name']
struct BlackId {
    id          int
    name        string
}

struct StatusReturn {
    pub:
        return_bool         bool
        find_passwd         bool
        id_check            []Personal
}

struct Type{
    pub:
        name        string
        type_text   []Task
}



pub fn create_db(db sqlite.DB) {
    sql db {
        create table Personal
        create table Task
        create table PostFlag
        create table PersonalFlag
    } or {
        println('${log.warn_log}: 数据库创建失败, 可能已存在数据库: data.db')
    }
}



// 测试部分初始化函数

pub fn test_main_function(mut db sqlite.DB) {
    the_data := sql db {
        select from Task
    } or { []Task{} }

    if the_data.len != 0 {
        return
    }

    data := [
        Task{
                type_text  :    'Crypto'
                flag       :    [
                                    PostFlag{flag : 'vyctf{adwa_is_the_best_crypto_player}'},
                                ]
                task       :    []PersonalFlag{}
                name       :    'fast_attack'
                diff       :    'normal'
                intro      :    'basectf的精神延续\n出题人:sudopacman\n附件:https://wwtk.lanzoum.com/i44iq2dppize\n远程环境:139.155.139.109:10000'
                max_score  :    300
                score      :    300
                container  :    false
        },

        Task{
                type_text  :    'Crypto'
                flag       :    [
                                    PostFlag{flag : 'vyctf{0010011100000101010011100001101111110101011001000101011111101001}'},
                                ]
                task       :    []PersonalFlag{}
                name       :    "Pell Company's A-level products"
                diff       :    'normal'
                intro      :    '我想拿它来做hash\n出题人:adwa\n附件:https://wwtk.lanzoum.com/iNvgK2dpql9c'
                max_score  :    300
                score      :    300
                container  :    false
        },

        Task{
                type_text  :    'Crypto'
                flag       :    [
                                    PostFlag{flag : 'vyctf{ffefc2b4c1482c8beef04fbdd0e38e7a931d4f41c2e63f7aa13b2e1d1ef7f970}'},
                                ]
                task       :    []PersonalFlag{}
                name       :    "Pell Company's B-level products"
                diff       :    'normal'
                intro      :    'Signin的精神延续\n出题人:adwa\n附件:https://wwtk.lanzoum.com/iNvgK2dpql9c'
                max_score  :    300
                score      :    300
                container  :    false
        },

        Task{
                type_text  :    'Crypto'
                flag       :    [
                                    PostFlag{flag : 'vyctf{19636b9eb26a0f0701691f84a643b081}'},
                                ]
                task       :    []PersonalFlag{}
                name       :    "Pell Company's C-level products"
                diff       :    'normal'
                intro      :    '应该是这次比赛最简单的题目了()\n出题人:adwa\n附件:https://wwtk.lanzoum.com/iDkSA2dprdcd'
                max_score  :    300
                score      :    300
                container  :    false
        },

        Task{
                type_text  :    'Pwn'
                flag       :    [
                                    PostFlag{flag : 'vyctf{wow_you_have_become_a_c_expert}'},
                                ]
                task       :    []PersonalFlag{}
                name       :    "safe_c_compiler"
                diff       :    'hard'
                intro      :    '我从来没有觉得dev开心过\n(注:flag文本以随机名存放至:/home/pwn2/flag文件夹)\n出题人:nydn\n附件:https://wwtk.lanzoum.com/iLnP32dprotg\n远程环境:139.155.139.109:10002'
                max_score  :    500
                score      :    500
                container  :    false
        },

        Task{
                type_text  :    'Reverse'
                flag       :    [
                                    PostFlag{flag : 'vyctf{d13bc9c2db60006994cc63be66dd0283}'}
                                ]
                task       :    []PersonalFlag{}
                name       :    "ez_rust"
                diff       :    'normal'
                intro      :    'So EZ Rust,难道不是吗？桀桀桀桀\n注:输入每个字符之间需加空格，例如0 1 2 3 4\n出题人:H4nn4h\n附件:https://wwtk.lanzoum.com/iHB2S2dpsdtg'
                max_score  :    300
                score      :    300
                container  :    false
        },

        Task{
                type_text  :    'MISC'
                flag       :    [
                                    PostFlag{flag : 'vyctf{Lycoris_Recoil}'}
                                ]
                task       :    []PersonalFlag{}
                name       :    "loop"
                diff       :    'hard'
                intro      :    '我们在研究报告中严肃提到了midi曲目的不安全性\n出题人:sudopacman\n附件:https://wwtk.lanzoum.com/iF5Pb2dpsoyh'
                max_score  :    500
                score      :    500
                container  :    false
        },

        Task{
                type_text  :    'iot'
                flag       :    [
                                    PostFlag{flag : 'VYCTF{教练我想学挨殴踢}'}
                                ]
                task       :    []PersonalFlag{}
                name       :    "来，让我看看！"
                diff       :    'normal'
                intro      :    'Nop偷偷给0x1发了些好康的,但0x1怎么都点不开,你能帮帮他吗\n出题人:Nop\n附件:https://wwtk.lanzoum.com/iVy3Z2dptzhc'
                max_score  :    300
                score      :    300
                container  :    false
        }, 
        
        Task{
                type_text  :    'web'
                flag       :    [
                                    PostFlag{flag : 'vyctf{66895b7d-3169-478d-b7ef-fd0530a46fba}'}
                                ]
                task       :    []PersonalFlag{}
                name       :    "简易计算器"
                diff       :    'normal'
                intro      :    '据说这与平台同源\n出题人:sudopacman\n附件:[还没上]\n远程环境:139.155.139.109:10003'
                max_score  :    300
                score      :    300
                container  :    false
        }, 
    ]

    for i in data {
        sql db {
            insert i into Task
        } or {
        println("Error: 存储数据出错")
        }
    }
}

