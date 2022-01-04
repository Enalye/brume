module brume.script.triangle;

import grimoire;

import brume.core, brume.render;

package(brume.script) void loadBrumeLibTriangle(GrLibrary library) {
    GrType triangleType = library.addForeign("Triangle", [], "Drawable");
    library.addPrimitive(&_triangle1, "triangle", [], [triangleType]);
}

private void _triangle1(GrCall call) {
    Triangle triangle = new Triangle();
    call.setForeign(triangle);
}