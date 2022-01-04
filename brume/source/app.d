import std.stdio;
import brume.common, brume.core;

void main() {
	try {
		runApplication();
	}
	catch (Exception e) {
		writeln(e.msg);
	}
}
