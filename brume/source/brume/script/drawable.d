module brume.script.drawable;

import grimoire;

import brume.core, brume.render;

package(brume.script) void loadBrumeLibDrawable(GrLibrary library) {
    GrType drawableType = library.addForeign("Drawable");
    library.addPrimitive(&_draw, "draw", [drawableType, grFloat, grFloat], []);
}

private void _draw(GrCall call) {
    Drawable drawable = call.getForeign!Drawable(0);
    if(!drawable) {
        call.raise("NullError");
        return;
    }
    drawable.draw(Vec2f(call.getFloat(1), call.getFloat(2)));
}