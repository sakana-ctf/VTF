module main

import os

fn main() {
	os.chdir('./templates_split') or {
		println('\033[33m[Warn] \033[0m不在主目录中')
	}

	for i in list_file('./html') {
		if i != 'index.html' {
			write_html(i, set_html(i))
		}
	}

	mut data := readfile('./css/console.css')
	mut url := '../static/css/console.css'
	os.write_file(url, data) or { return }
	println('\033[32m[True] \033[0m文件储存于: ${url}')
	data = readfile('./html/index.html')
	url = '../static/html/index.html'
	os.write_file(url, data) or { return }
	println('\033[32m[True] \033[0m文件储存于: ${url}')
}

fn readfile(path string) string {
	mut file := os.open(path) or {
		return ''
	}
	fsize := os.file_size(path).str().int()
	data := file.read_bytes(fsize).bytestr()
	file.close()
	return data
}

fn set_html(main_html string) string {
	url := 'html/${main_html}'
	head := readfile('head.html')
	header := readfile('header.html')
	main := readfile(url)
	js := readfile('js.html')
	return '<!DOCTYPE html>\n<html lang="zh">\n${head}\n<body id="top">\n${header}\n${js}\n${main}\n</body>\n</html>'
}

fn list_file(path string) []string {
	return os.ls(path) or { []string{} }
}

fn write_html(i string, data string) {
	url := '../templates/${i}'
	os.write_file(url, data) or { return }
	println('\033[32m[True] \033[0m文件储存于: ${url}')
}
