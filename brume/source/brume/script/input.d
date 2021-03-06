/** 
 * Copyright: Enalye
 * License: Zlib
 * Authors: Enalye
 */
module brume.script.input;

import grimoire;
import brume.constants, brume.core;

void loadInputLibrary(GrLibrary library) {
    GrType btnType = library.addEnum("Button", [
            "up", "down", "left", "right", "a", "b", "x", "y"
        ]);
    library.addFunction(&_held, "held?", [btnType], [grBool]);
    library.addFunction(&_pressed, "pressed?", [btnType], [grBool]);
}

enum ButtonType {
    up,
    down,
    left,
    right,
    a,
    b,
    x,
    y
}

private void _held(GrCall call) {
    bool value;
    final switch (call.getEnum!ButtonType(0)) with (ButtonType) {
    case up:
        value = isButtonDown(KeyButton.up) || isButtonDown(ControllerButton.up) || getAxis(
            ControllerAxis.leftY) < -CONTROLLER_DEAD_ZONE;
        break;
    case down:
        value = isButtonDown(KeyButton.down) || isButtonDown(ControllerButton.down) || getAxis(
            ControllerAxis.leftY) > CONTROLLER_DEAD_ZONE;
        break;
    case left:
        value = isButtonDown(KeyButton.left) || isButtonDown(ControllerButton.left) || getAxis(
            ControllerAxis.leftX) < -CONTROLLER_DEAD_ZONE;
        break;
    case right:
        value = isButtonDown(KeyButton.right) || isButtonDown(ControllerButton.right) || getAxis(
            ControllerAxis.leftX) > CONTROLLER_DEAD_ZONE;
        break;
    case a:
        value = isButtonDown(KeyButton.z) || isButtonDown(ControllerButton.a);
        break;
    case b:
        value = isButtonDown(KeyButton.x) || isButtonDown(ControllerButton.b);
        break;
    case x:
        value = isButtonDown(KeyButton.c) || isButtonDown(ControllerButton.x);
        break;
    case y:
        value = isButtonDown(KeyButton.v) || isButtonDown(ControllerButton.y);
        break;
    }
    call.setBool(value);
}

private void _pressed(GrCall call) {
    bool value;
    final switch (call.getEnum!ButtonType(0)) with (ButtonType) {
    case up:
        value = getButtonDown(KeyButton.up) || getButtonDown(ControllerButton.up);
        break;
    case down:
        value = getButtonDown(KeyButton.down) || getButtonDown(ControllerButton.down);
        break;
    case left:
        value = getButtonDown(KeyButton.left) || getButtonDown(ControllerButton.left);
        break;
    case right:
        value = getButtonDown(KeyButton.right) || getButtonDown(ControllerButton.right);
        break;
    case a:
        value = getButtonDown(KeyButton.z) || getButtonDown(ControllerButton.a);
        break;
    case b:
        value = getButtonDown(KeyButton.x) || getButtonDown(ControllerButton.b);
        break;
    case x:
        value = getButtonDown(KeyButton.c) || getButtonDown(ControllerButton.x);
        break;
    case y:
        value = getButtonDown(KeyButton.v) || getButtonDown(ControllerButton.y);
        break;
    }
    call.setBool(value);
}