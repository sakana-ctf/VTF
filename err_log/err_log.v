module err_log

import sql_db { Personal, Task }
import log
import crypto.sha256

// sha256加密
pub fn sha256_str(data string) string {
    return sha256.sum(data.bytes()).hex()
}

// 输出日志
pub fn logs(data string) {
    println(data)
}

// 显示输出报错
pub fn logs_err(data string) {
    println('错误: ${data}')
}

// personal报错函数
pub fn personal_err() []Personal {
    println('${log.false_log}查询错误')
    return []
}

// task报错函数
pub fn task_err() []Task {
    println('${log.false_log}查询错误')
    return []
}

