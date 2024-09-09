module sql_db

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
    id         string
    email      string
    passwd     string
    whoami     string
    score      int
}


@[table: 'task']
pub struct Task{
    pub:
    name       string
    diff       string
    intro      string

    complete   string
    flag       []string
    container  bool
}




