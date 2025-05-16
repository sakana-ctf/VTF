module console

import os

pub fn readfile(path string) string {
	mut file := os.open(path) or {
		return ''
	}
	fsize := os.file_size(path).str().int()
	data := file.read_bytes(fsize).bytestr()
	file.close()
	return data
}

pub fn writefile(path string, buf []u8) {
        mut file := os.open_append(path) or {
                return
        }
        file.write(buf) or { 0 }
		file.close()
}


