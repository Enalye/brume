import std.stdio;
import brume.screen;

void main() {
    try {
        runApplication();
    }
    catch (Exception e) {
        writeln(e.msg);
    }
}
