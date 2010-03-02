package ua.kiev.djm.core.net.cmd {
	
	public interface ICommandParser {
		
		function parse(command:*): void;
		
	}
}