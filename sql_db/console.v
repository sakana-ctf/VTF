module sql_db

import err_log
import db.sqlite { DB }

pub fn add_challenge(db sqlite.DB, type_text string, flag []string, name string, diff string, intro string, max_score int, score int, container bool, file []u8) string {
	mut new_personal_flag := []PersonalFlag{}
	parents_id := sql db {
		select from Personal
	} or {
		[]Personal{}
	}
	for i in parents_id {
		new_personal_flag << PersonalFlag {
    	parents_id		:	i.pid
		complete        :	unsolved
		}
	}

	mut task_flag := []PostFlag{}

	for i in flag {
		task_flag << PostFlag{
			flag	:	i
		}
	}

	new_task := Task{
        type_text  :    type_text
        flag       :    task_flag
        challenge  :    new_personal_flag
        name       :    name
        diff       :    diff
        intro      :    intro
        max_score  :    max_score
        score      :    score
        container  :    container
	}
	sql db {
		insert new_task into Task
	} or {
		err_log.logs_err('Error: 添加失败')
		return 'Error: 添加失败'
	}
	return '添加成功'
}
