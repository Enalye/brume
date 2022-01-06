import std.stdio;
import brume.core;

void main() {
    try {
        startup();
    }
    catch (Exception e) {
        writeln(e.msg);
    }
}
