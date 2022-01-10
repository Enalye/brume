/** 
 * Copyright: Enalye
 * License: Zlib
 * Authors: Enalye
 */
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
