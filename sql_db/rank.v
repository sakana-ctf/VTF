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

pub fn find_task(db DB) []Task {
	data := sql db {
		select from Task
	} or {
		[]Task{}
	}
	return data
}

pub fn bool_solve(pf PersonalFlag) bool {
	if pf.complete == solved {
		return true
	} else {
		return false
	}
}

pub fn task_score(db DB, pf PersonalFlag) int {
	data := sql db {
		select from Task where tid == pf.parents_task
	} or {
		return 0
	}
	return data.first().score
}
