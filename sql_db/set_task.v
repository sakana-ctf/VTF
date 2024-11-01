import db.sqlite
import os

// Personal-task对照表.
@[table: 'personal_flag']
pub struct PersonalFlag {
    pub:
        parents_id          int
        parents_task        int
        complete            string
}

@[table: 'personal']
pub struct Personal {
    pub:
        pid             int                 @[primary; sql:serial]
        id              string
        email           string
        passwd          string
        whoami          string
        task            []PersonalFlag      @[fkey: 'parents_id']
}

@[table: 'task']
pub struct Task{
    pub:
        tid        int              @[primary; sql:serial]
        type_text  string
        flag       []PostFlag       @[fkey: 'parents_task']
        task       []PersonalFlag   @[fkey: 'parents_task']
        name       string
        diff       string
        intro      string
        max_score  int
        score      int
        container  bool
}


@[table: 'post_flag']
pub struct PostFlag {
        parents_task    int
    pub mut:
        flag            string
}

const solved = '../image/complete.webp'
const unsolved = '../image/incomplete.png'

fn get_new_data() string {
	mut new_data := os.input('>')
	new_data = new_data.replace('\\n', '\n')
	return new_data
}

pub fn main() {
    mut db := sqlite.connect('../data.db')  or {
        println('Error: sqlite调用错误')
        panic(err)
    }

	data := os.input('1. 查看题目\n2. 添加题目\n3. 删除题目\n4. 修改题目\n>')
	tasks := sql db {
		select from Task 
	} or {
		[]Task{}
	}

	match data {
		'1' {
			// 查看题目
			for task in tasks {
				println('=========${task.tid}========\n${task.name} ${task.diff}\n${task.intro}')
			}
			//println(tasks)
		} '2' {
			// 添加题目

			mut new_personal_flag := []PersonalFlag{}
			for i in 0..tasks.first().task.len {
				new_personal_flag << PersonalFlag {
        			parents_id		:	i + 1
        			complete        :	unsolved
				}
			}

			//mut the_text := os.input('题目类型\n>')
			//mut the_text := os.input('flag值\n>')

			new_task := Task{
                type_text  :    'Reverse'
                flag       :    [
                                    PostFlag{flag : 'vyctf{Vm_ji_ni_tai_mei~~~Oh_baby!}'},
                                ]
                task       :    new_personal_flag
                name       :    '嘘拟鸡'
                diff       :    'hard'
                intro      :    '黏氢仁，老夫看你钴铬旌旗，这个嘘拟鸡便两块五卖与你吧\n出题人:H4nn4h\n附件:https://wwtk.lanzoum.com/iNIk52duojxc'
                max_score  :    500
                score      :    500
                container  :    false
        	}

			sql db {
				insert new_task into Task
			} or {
				println('Error: 添加失败')
			}
		} '3' {
			// 删除题目
			id := os.input('修改题目编号:\n>').int()
			sql db {
				delete from Task where tid == id
				delete from PostFlag where parents_task == id
				delete from PersonalFlag where parents_task == id
			} or {
				println('Error: 删除失败')
			}
		} '4' {
			// 修改题目
			id := os.input('修改题目编号:\n>').int()
			the_type := os.input('修改类型(name, diff, intro):\n>')
			match the_type {
				'name' {
					println(tasks[id-1].name)
					new_data := get_new_data()
					sql db {
						update Task set name = new_data where tid == id
					} or {
						println('Error: 修改失败')
					}
				} 'diff' {
					println(tasks[id-1].diff)
					new_data := get_new_data()
					sql db {
						update Task set diff = new_data where tid == id
					} or {
						println('Error: 修改失败')
					}
				} 'intro' {
					println(tasks[id-1].intro)
					new_data := get_new_data()
					sql db {
						update Task set intro = new_data where tid == id
					} or {
						println('Error: 修改失败')
					}
				} else {
					println('Error: 修改失败')
				}
			}
		}
		else {
			return
		}
	}
}


