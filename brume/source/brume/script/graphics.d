module brume.script.graphics;

import grimoire;
import brume.screen;

void loadGraphicsLibrary(GrLibrary library) {
    library.addPrimitive(&_clear0, "remplis");
    library.addPrimitive(&_clear1, "remplis", [grInt]);
    library.addPrimitive(&_pixel0, "point", [grInt, grInt]);
    library.addPrimitive(&_pixel1, "point", [grInt, grInt, grInt]);
    library.addPrimitive(&_rect0, "rectangle", [grInt, grInt, grInt, grInt]);
    library.addPrimitive(&_rect1, "rectangle", [
            grInt, grInt, grInt, grInt, grInt
        ]);
    library.addPrimitive(&_rectFilled0, "rectanglePlein", [
            grInt, grInt, grInt, grInt
        ]);
    library.addPrimitive(&_rectFilled1, "rectanglePlein", [
            grInt, grInt, grInt, grInt, grInt
        ]);
}

private {
    int _colorId;
}

private void _clear0(GrCall) {
    clearScreen(_colorId);
}

private void _clear1(GrCall call) {
    clearScreen(call.getInt32(0));
}

private void _pixel0(GrCall call) {
    drawPixel(call.getInt32(0), call.getInt32(1), _colorId);
}

private void _pixel1(GrCall call) {
    drawPixel(call.getInt32(0), call.getInt32(1), call.getInt32(2));
}

private void _rect0(GrCall call) {
    drawRect(call.getInt32(0), call.getInt32(1), call.getInt32(2), call.getInt32(3), _colorId);
}

private void _rect1(GrCall call) {
    drawRect(call.getInt32(0), call.getInt32(1), call.getInt32(2), call.getInt32(3), call.getInt32(
            4));
}

private void _rectFilled0(GrCall call) {
    drawFilledRect(call.getInt32(0), call.getInt32(1), call.getInt32(2), call.getInt32(3), _colorId);
}

private void _rectFilled1(GrCall call) {
    drawFilledRect(call.getInt32(0), call.getInt32(1), call.getInt32(2), call.getInt32(3), call.getInt32(
            4));
}
