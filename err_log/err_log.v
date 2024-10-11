module err_log

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



