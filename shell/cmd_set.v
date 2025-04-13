module shell

pub struct CmdSet {
pub:
	port		int
	args		string
	database	string
pub mut:
	nohup		bool
	workers		int
}