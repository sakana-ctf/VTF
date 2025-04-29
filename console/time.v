module console

import time { now, Time }

pub fn play_time(starttime Time, endtime Time ) bool {
	mut flag := false
	now_time := now()
	if starttime < now_time && endtime > now_time {
		flag = true
	}
	return flag
}



