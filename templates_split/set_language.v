module main

import os
import regex



fn readfile(path string) string {
	mut file := os.open(path) or {
		return ''
	}
	fsize := os.file_size(path).str().int()
	data := file.read_bytes(fsize).bytestr()
	file.close()
	return data
}

fn set_regex(data string) bool {
	query := r'.*".*": ".*".*'
	mut re := regex.regex_opt(query) or { panic(err) }
	return re.matches_string(data)
}

fn main() {
	data := readfile('./language/zh_CN.json')
	json_data := data.split('\n')
	for i in json_data {
		if set_regex(i) {
			println(i.split('"')[1])
			println(i.split('"')[3])
		}
	}
}

