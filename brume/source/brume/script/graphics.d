/** 
 * Copyright: Enalye
 * License: Zlib
 * Authors: Enalye
 */
module brume.script.graphics;

import grimoire;
import brume.constants, brume.core, brume.image;

void loadGraphicsLibrary(GrLibrary library) {
    GrType imgType = library.addForeign("Image");

    library.addFunction(&_color, "color", [grInt]);

    library.addFunction(&_clip0, "clip");
    library.addFunction(&_clip1, "clip", [grInt, grInt, grInt, grInt]);

    library.addFunction(&_clear0, "clear");
    library.addFunction(&_clear1, "clear", [grInt]);

    library.addFunction(&_pixel0, "pixel", [grInt, grInt]);
    library.addFunction(&_pixel1, "pixel", [grInt, grInt, grInt]);

    library.addFunction(&_rect0, "rectangle", [
            grInt, grInt, grInt, grInt, grBool
        ]);
    library.addFunction(&_rect1, "rectangle", [
            grInt, grInt, grInt, grInt, grBool, grInt
        ]);

    library.addFunction(&_circle0, "circle", [
            grInt, grInt, grInt, grBool
        ]);
    library.addFunction(&_circle1, "circle", [
            grInt, grInt, grInt, grBool, grInt
        ]);

    library.addFunction(&_line0, "line", [grInt, grInt]);
    library.addFunction(&_line1, "line", [grInt, grInt, grInt]);
    library.addFunction(&_line2, "line", [grInt, grInt, grInt, grInt]);
    library.addFunction(&_line3, "line", [
            grInt, grInt, grInt, grInt, grInt
        ]);

    library.addFunction(&_triangle0, "triangle", [
            grInt, grInt, grInt, grInt, grInt, grInt, grBool
        ]);
    library.addFunction(&_triangle1, "triangle", [
            grInt, grInt, grInt, grInt, grInt, grInt, grBool, grInt
        ]);

    library.addFunction(&_cursor0, "cursor");
    library.addFunction(&_cursor1, "cursor", [
            grInt, grInt
        ]);

    library.addFunction(&_print0, "print", [
            grString
        ]);
    library.addFunction(&_print1, "print", [
            grString, grInt
        ]);
    library.addFunction(&_print2, "print", [
            grString, grInt, grInt
        ]);
    library.addFunction(&_print3, "print", [
            grString, grInt, grInt, grInt
        ]);

    library.addFunction(&_makeImage, "Image", [grInt, grInt], [imgType]);
    library.addFunction(&_setImage0, "set", [imgType, grIntArray]);
    library.addFunction(&_setImage1, "set", [imgType, grString]);
    library.addFunction(&_setImage2, "set", [imgType, grInt, grInt, grStringArray]);
    library.addFunction(&_drawImage, "draw", [imgType, grInt, grInt]);
}

private {
    int _penColor;
    int _endPointX, _endPointY;
    int _cursorX, _cursorY;
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

private void _cursor0(GrCall) {
    _cursorX = 0;
    _cursorY = 0;
}

private void _cursor1(GrCall call) {
    _cursorX = call.getInt32(0);
    _cursorY = call.getInt32(1);
}

private void _print0(GrCall call) {
    GrString text = call.getString(0);
    printText(text, _cursorX, _cursorY, _penColor);
    _cursorY += FONT_LINE;
}

private void _print1(GrCall call) {
    GrString text = call.getString(0);
    _penColor = call.getInt32(1);
    printText(text, _cursorX, _cursorY, _penColor);
    _cursorY += FONT_LINE;
}

private void _print2(GrCall call) {
    GrString text = call.getString(0);
    _cursorX = call.getInt32(1);
    _cursorY = call.getInt32(2);
    printText(text, _cursorX, _cursorY, _penColor);
    _cursorY += FONT_LINE;
}

private void _print3(GrCall call) {
    GrString text = call.getString(0);
    _cursorX = call.getInt32(1);
    _cursorY = call.getInt32(2);
    _penColor = call.getInt32(3);
    printText(text, _cursorX, _cursorY, _penColor);
    _cursorY += FONT_LINE;
}

private void _makeImage(GrCall call) {
    call.setForeign!Image(new Image(call.getInt32(0), call.getInt32(1)));
}

private void _setImage0(GrCall call) {
    import std.algorithm.comparison : min;

    Image img = call.getForeign!Image(0);
    GrIntArray values = call.getIntArray(1);

    if (!img) {
        call.raise("Nul");
        return;
    }

    const end = min(values.data.length, img._width * img._height);

    for (int i; i < end; ++i) {
        if(values.data[i] >= 0 && values.data[i] <= 15)
            img._texels[i] = cast(ubyte) values.data[i];
        else {
            img._texels[i] = TRANSPARENCY_VALUE;
        }
    }
}

private void _setImage1(GrCall call) {
    import std.algorithm.comparison : min;

    Image img = call.getForeign!Image(0);
    GrString values = call.getString(1);

    if (!img) {
        call.raise("Nul");
        return;
    }

    const end = min(values.length, img._width * img._height);

    for (int i; i < end; ++i) {
        auto value = values[i];
        if(value >= '0' && value <= '9') {
            img._texels[i] = cast(ubyte) (value - '0');
        }
        else if(value >= 'a' && value <= 'f') {
            img._texels[i] = cast(ubyte) ((value - 'a') + 10);
        }
        else if(value >= 'A' && value <= 'F') {
            img._texels[i] = cast(ubyte) ((value - 'A') + 10);
        }
        else {
            img._texels[i] = TRANSPARENCY_VALUE;
        }
    }
}

private void _setImage2(GrCall call) {
    import std.algorithm.comparison : min;

    Image img = call.getForeign!Image(0);
    const int x = call.getInt32(1);
    const int y = call.getInt32(2);
    GrStringArray values = call.getStringArray(3);

    if (!img) {
        call.raise("Nul");
        return;
    }

    const endY = min(values.data.length, img._height - y);
    for (int iy; iy < endY; ++iy) {
        GrString line = values.data[iy];
        const endX = min(line.length, img._width - x);
        for (int ix; ix < endX; ++ix) {
            auto value = line[ix];
            const int index = (iy + y) * img._height + (ix + x);
            if(index < 0 || index >= img._texels.length)
                continue;
            if(value >= '0' && value <= '9') {
                img._texels[index] = cast(ubyte) (value - '0');
            }
            else if(value >= 'a' && value <= 'f') {
                img._texels[index] = cast(ubyte) ((value - 'a') + 10);
            }
            else if(value >= 'A' && value <= 'F') {
                img._texels[index] = cast(ubyte) ((value - 'A') + 10);
            }
            else {
                img._texels[index] = TRANSPARENCY_VALUE;
            }
        }
    }
}

private void _drawImage(GrCall call) {
    Image img = call.getForeign!Image(0);

    if (!img) {
        call.raise("Nul");
        return;
    }

    drawImage(img, call.getInt32(1), call.getInt32(2));
}
