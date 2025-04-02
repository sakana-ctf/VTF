module cmd

pub struct CmdSet {
pub:
	port		int
	args		string

pub mut:
	nohup		bool
	workers		int
}