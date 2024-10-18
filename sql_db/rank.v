module sql_db

import db.sqlite { DB }

pub fn get_personal(db DB) []Personal {
	data := sql db {
		select from Personal
	} or {
		[]Personal{}
	}
	return data
}

pub fn find_task(db DB) string {
	data := sql db {
		select from Task
	} or {
		[]Task{}
	}
	mut text := ''
	for i in data {
		text += ' ${i.name}(${i.tid}) |'
	}
	return text
}
/*
pub fn find_task_score(db DB, task Task) []Task {
	task.
	data := sql db {
		select from PersonalFlag
	} or {
		[]Task{}
	}
	return data
}
*/
pub fn bool_solve(pf PersonalFlag) string {
	if pf.complete == solved {
		return '✓'
	} else {
		return '✗'
	}
}


