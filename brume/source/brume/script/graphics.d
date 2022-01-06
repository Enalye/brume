module brume.script.graphics;

import grimoire;
import brume.constants, brume.core;

void loadGraphicsLibrary(GrLibrary library) {
    library.addPrimitive(&_color, "couleur", [grInt]);

    library.addPrimitive(&_clip0, "région");
    library.addPrimitive(&_clip1, "région", [grInt, grInt, grInt, grInt]);

    library.addPrimitive(&_clear0, "nettoie");
    library.addPrimitive(&_clear1, "nettoie", [grInt]);

    library.addPrimitive(&_pixel0, "point", [grInt, grInt]);
    library.addPrimitive(&_pixel1, "point", [grInt, grInt, grInt]);

    library.addPrimitive(&_rect0, "rectangle", [
            grInt, grInt, grInt, grInt, grBool
        ]);
    library.addPrimitive(&_rect1, "rectangle", [
            grInt, grInt, grInt, grInt, grBool, grInt
        ]);

    library.addPrimitive(&_circle0, "cercle", [
            grInt, grInt, grInt, grBool
        ]);
    library.addPrimitive(&_circle1, "cercle", [
            grInt, grInt, grInt, grBool, grInt
        ]);

    library.addPrimitive(&_line0, "ligne", [grInt, grInt]);
    library.addPrimitive(&_line1, "ligne", [grInt, grInt, grInt]);
    library.addPrimitive(&_line2, "ligne", [grInt, grInt, grInt, grInt]);
    library.addPrimitive(&_line3, "ligne", [
            grInt, grInt, grInt, grInt, grInt
        ]);

    library.addPrimitive(&_triangle0, "triangle", [
            grInt, grInt, grInt, grInt, grInt, grInt, grBool
        ]);
    library.addPrimitive(&_triangle1, "triangle", [
            grInt, grInt, grInt, grInt, grInt, grInt, grBool, grInt
        ]);
}

private {
    int _penColor;
    int _endPointX, _endPointY;
}

private void _color(GrCall call) {
    _penColor = call.getInt32(0);
}

private void _clip0(GrCall) {
    clipScreen(0, 0, CANVAS_WIDTH, CANVAS_HEIGHT);
}

private void _clip1(GrCall call) {
    clipScreen(call.getInt32(0), call.getInt32(1), call.getInt32(2), call.getInt32(3));
}

private void _clear0(GrCall) {
    clearScreen(_penColor);
}

private void _clear1(GrCall call) {
    _penColor = call.getInt32(0);
    clearScreen(_penColor);
}

private void _pixel0(GrCall call) {
    drawPixel(call.getInt32(0), call.getInt32(1), _penColor);
}

private void _pixel1(GrCall call) {
    _penColor = call.getInt32(2);
    drawPixel(call.getInt32(0), call.getInt32(1), _penColor);
}

private void _rect0(GrCall call) {
    if (call.getBool(4))
        drawFilledRect(call.getInt32(0), call.getInt32(1), call.getInt32(2), call.getInt32(3), _penColor);
    else
        drawRect(call.getInt32(0), call.getInt32(1), call.getInt32(2), call.getInt32(3), _penColor);
}

private void _rect1(GrCall call) {
    _penColor = call.getInt32(5);
    if (call.getBool(4))
        drawFilledRect(call.getInt32(0), call.getInt32(1), call.getInt32(2), call.getInt32(3), _penColor);
    else
        drawRect(call.getInt32(0), call.getInt32(1), call.getInt32(2), call.getInt32(3), _penColor);
}

private void _circle0(GrCall call) {
    if (call.getBool(3))
        drawFilledCircle(call.getInt32(0), call.getInt32(1), call.getInt32(2), _penColor);
    else
        drawCircle(call.getInt32(0), call.getInt32(1), call.getInt32(2), _penColor);
}

private void _circle1(GrCall call) {
    _penColor = call.getInt32(4);
    if (call.getBool(3))
        drawFilledCircle(call.getInt32(0), call.getInt32(1), call.getInt32(2), _penColor);
    else
        drawCircle(call.getInt32(0), call.getInt32(1), call.getInt32(2), _penColor);
}

private void _line0(GrCall call) {
    drawLine(call.getInt32(0), call.getInt32(1), _endPointX, _endPointY, _penColor);
}

private void _line1(GrCall call) {
    int x2 = call.getInt32(0);
    int y2 = call.getInt32(1);
    _penColor = call.getInt32(2);
    drawLine(_endPointX, _endPointY, x2, y2, _penColor);
    _endPointX = x2;
    _endPointY = y2;
}

private void _line2(GrCall call) {
    int x2 = call.getInt32(0);
    int y2 = call.getInt32(1);
    drawLine(_endPointX, _endPointY, x2, y2, _penColor);
    _endPointX = x2;
    _endPointY = y2;
}

private void _line3(GrCall call) {
    _endPointX = call.getInt32(2);
    _endPointY = call.getInt32(3);
    _penColor = call.getInt32(4);
    drawLine(call.getInt32(0), call.getInt32(1), _endPointX, _endPointY, _penColor);
}

private void _triangle0(GrCall call) {
    if (call.getBool(6))
        drawFilledTriangle(call.getInt32(0), call.getInt32(1), call.getInt32(2), call.getInt32(3), call.getInt32(4), call
                .getInt32(5), _penColor);
    else
        drawTriangle(call.getInt32(0), call.getInt32(1), call.getInt32(2), call.getInt32(3), call.getInt32(4), call
                .getInt32(5), _penColor);
}

private void _triangle1(GrCall call) {
    _penColor = call.getInt32(7);
    if (call.getBool(6))
        drawFilledTriangle(call.getInt32(0), call.getInt32(1), call.getInt32(2), call.getInt32(3), call.getInt32(4), call
                .getInt32(5), _penColor);
    else
        drawTriangle(call.getInt32(0), call.getInt32(1), call.getInt32(2), call.getInt32(3), call.getInt32(4), call
                .getInt32(5), _penColor);
}
