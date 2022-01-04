/** 
 * Copyright: Enalye
 * License: Zlib
 * Authors: Enalye
 */
module brume.screen;

import std.stdio;
import std.string;
import std.exception;
import std.datetime.systime;
import core.thread;

version (linux) {
    import core.sys.posix.unistd;
    import core.sys.posix.signal;
}
version (Windows) {
    import core.stdc.signal;
}

import bindbc.sdl, bindbc.sdl.image, bindbc.sdl.mixer;
import grimoire;

import brume.constants;
import brume.script;

private {
    SDL_Window* _sdlWindow;
    SDL_Renderer* _sdlRenderer;
    SDL_Texture* _renderTexture;

    SDL_Surface* _icon;
    uint _width, _height;

    float _deltatime = 1f;
    float _currentFps;
    long _tickStartFrame;

    bool _isChildGrabbed;
    uint _idChildGrabbed;

    uint _fps = 30u;

    GrEngine _engine;

    // Entrées
    bool[KeyButton.max + 1] _keys1, _keys2;
}

private shared bool _isRunning = false;

/// Liste des touches
enum KeyButton {
    unknown = SDL_SCANCODE_UNKNOWN,
    a = SDL_SCANCODE_A,
    b = SDL_SCANCODE_B,
    c = SDL_SCANCODE_C,
    d = SDL_SCANCODE_D,
    e = SDL_SCANCODE_E,
    f = SDL_SCANCODE_F,
    g = SDL_SCANCODE_G,
    h = SDL_SCANCODE_H,
    i = SDL_SCANCODE_I,
    j = SDL_SCANCODE_J,
    k = SDL_SCANCODE_K,
    l = SDL_SCANCODE_L,
    m = SDL_SCANCODE_M,
    n = SDL_SCANCODE_N,
    o = SDL_SCANCODE_O,
    p = SDL_SCANCODE_P,
    q = SDL_SCANCODE_Q,
    r = SDL_SCANCODE_R,
    s = SDL_SCANCODE_S,
    t = SDL_SCANCODE_T,
    u = SDL_SCANCODE_U,
    v = SDL_SCANCODE_V,
    w = SDL_SCANCODE_W,
    x = SDL_SCANCODE_X,
    y = SDL_SCANCODE_Y,
    z = SDL_SCANCODE_Z,
    alpha1 = SDL_SCANCODE_1,
    alpha2 = SDL_SCANCODE_2,
    alpha3 = SDL_SCANCODE_3,
    alpha4 = SDL_SCANCODE_4,
    alpha5 = SDL_SCANCODE_5,
    alpha6 = SDL_SCANCODE_6,
    alpha7 = SDL_SCANCODE_7,
    alpha8 = SDL_SCANCODE_8,
    alpha9 = SDL_SCANCODE_9,
    alpha0 = SDL_SCANCODE_0,
    enter = SDL_SCANCODE_RETURN,
    escape = SDL_SCANCODE_ESCAPE,
    backspace = SDL_SCANCODE_BACKSPACE,
    tab = SDL_SCANCODE_TAB,
    space = SDL_SCANCODE_SPACE,
    minus = SDL_SCANCODE_MINUS,
    equals = SDL_SCANCODE_EQUALS,
    leftBracket = SDL_SCANCODE_LEFTBRACKET,
    rightBracket = SDL_SCANCODE_RIGHTBRACKET,
    backslash = SDL_SCANCODE_BACKSLASH,
    nonushash = SDL_SCANCODE_NONUSHASH,
    semicolon = SDL_SCANCODE_SEMICOLON,
    apostrophe = SDL_SCANCODE_APOSTROPHE,
    grave = SDL_SCANCODE_GRAVE,
    comma = SDL_SCANCODE_COMMA,
    period = SDL_SCANCODE_PERIOD,
    slash = SDL_SCANCODE_SLASH,
    capslock = SDL_SCANCODE_CAPSLOCK,
    f1 = SDL_SCANCODE_F1,
    f2 = SDL_SCANCODE_F2,
    f3 = SDL_SCANCODE_F3,
    f4 = SDL_SCANCODE_F4,
    f5 = SDL_SCANCODE_F5,
    f6 = SDL_SCANCODE_F6,
    f7 = SDL_SCANCODE_F7,
    f8 = SDL_SCANCODE_F8,
    f9 = SDL_SCANCODE_F9,
    f10 = SDL_SCANCODE_F10,
    f11 = SDL_SCANCODE_F11,
    f12 = SDL_SCANCODE_F12,
    printScreen = SDL_SCANCODE_PRINTSCREEN,
    scrollLock = SDL_SCANCODE_SCROLLLOCK,
    pause = SDL_SCANCODE_PAUSE,
    insert = SDL_SCANCODE_INSERT,
    home = SDL_SCANCODE_HOME,
    pageup = SDL_SCANCODE_PAGEUP,
    remove = SDL_SCANCODE_DELETE,
    end = SDL_SCANCODE_END,
    pagedown = SDL_SCANCODE_PAGEDOWN,
    right = SDL_SCANCODE_RIGHT,
    left = SDL_SCANCODE_LEFT,
    down = SDL_SCANCODE_DOWN,
    up = SDL_SCANCODE_UP,
    numLockclear = SDL_SCANCODE_NUMLOCKCLEAR,
    numDivide = SDL_SCANCODE_KP_DIVIDE,
    numMultiply = SDL_SCANCODE_KP_MULTIPLY,
    numMinus = SDL_SCANCODE_KP_MINUS,
    numPlus = SDL_SCANCODE_KP_PLUS,
    numEnter = SDL_SCANCODE_KP_ENTER,
    num1 = SDL_SCANCODE_KP_1,
    num2 = SDL_SCANCODE_KP_2,
    num3 = SDL_SCANCODE_KP_3,
    num4 = SDL_SCANCODE_KP_4,
    num5 = SDL_SCANCODE_KP_5,
    num6 = SDL_SCANCODE_KP_6,
    num7 = SDL_SCANCODE_KP_7,
    num8 = SDL_SCANCODE_KP_8,
    num9 = SDL_SCANCODE_KP_9,
    num0 = SDL_SCANCODE_KP_0,
    numPeriod = SDL_SCANCODE_KP_PERIOD,
    nonusBackslash = SDL_SCANCODE_NONUSBACKSLASH,
    application = SDL_SCANCODE_APPLICATION,
    power = SDL_SCANCODE_POWER,
    numEquals = SDL_SCANCODE_KP_EQUALS,
    f13 = SDL_SCANCODE_F13,
    f14 = SDL_SCANCODE_F14,
    f15 = SDL_SCANCODE_F15,
    f16 = SDL_SCANCODE_F16,
    f17 = SDL_SCANCODE_F17,
    f18 = SDL_SCANCODE_F18,
    f19 = SDL_SCANCODE_F19,
    f20 = SDL_SCANCODE_F20,
    f21 = SDL_SCANCODE_F21,
    f22 = SDL_SCANCODE_F22,
    f23 = SDL_SCANCODE_F23,
    f24 = SDL_SCANCODE_F24,
    execute = SDL_SCANCODE_EXECUTE,
    help = SDL_SCANCODE_HELP,
    menu = SDL_SCANCODE_MENU,
    select = SDL_SCANCODE_SELECT,
    stop = SDL_SCANCODE_STOP,
    again = SDL_SCANCODE_AGAIN,
    undo = SDL_SCANCODE_UNDO,
    cut = SDL_SCANCODE_CUT,
    copy = SDL_SCANCODE_COPY,
    paste = SDL_SCANCODE_PASTE,
    find = SDL_SCANCODE_FIND,
    mute = SDL_SCANCODE_MUTE,
    volumeUp = SDL_SCANCODE_VOLUMEUP,
    volumeDown = SDL_SCANCODE_VOLUMEDOWN,
    numComma = SDL_SCANCODE_KP_COMMA,
    numEqualsAs400 = SDL_SCANCODE_KP_EQUALSAS400,
    international1 = SDL_SCANCODE_INTERNATIONAL1,
    international2 = SDL_SCANCODE_INTERNATIONAL2,
    international3 = SDL_SCANCODE_INTERNATIONAL3,
    international4 = SDL_SCANCODE_INTERNATIONAL4,
    international5 = SDL_SCANCODE_INTERNATIONAL5,
    international6 = SDL_SCANCODE_INTERNATIONAL6,
    international7 = SDL_SCANCODE_INTERNATIONAL7,
    international8 = SDL_SCANCODE_INTERNATIONAL8,
    international9 = SDL_SCANCODE_INTERNATIONAL9,
    lang1 = SDL_SCANCODE_LANG1,
    lang2 = SDL_SCANCODE_LANG2,
    lang3 = SDL_SCANCODE_LANG3,
    lang4 = SDL_SCANCODE_LANG4,
    lang5 = SDL_SCANCODE_LANG5,
    lang6 = SDL_SCANCODE_LANG6,
    lang7 = SDL_SCANCODE_LANG7,
    lang8 = SDL_SCANCODE_LANG8,
    lang9 = SDL_SCANCODE_LANG9,
    alterase = SDL_SCANCODE_ALTERASE,
    sysreq = SDL_SCANCODE_SYSREQ,
    cancel = SDL_SCANCODE_CANCEL,
    clear = SDL_SCANCODE_CLEAR,
    prior = SDL_SCANCODE_PRIOR,
    enter2 = SDL_SCANCODE_RETURN2,
    separator = SDL_SCANCODE_SEPARATOR,
    out_ = SDL_SCANCODE_OUT,
    oper = SDL_SCANCODE_OPER,
    clearAgain = SDL_SCANCODE_CLEARAGAIN,
    crsel = SDL_SCANCODE_CRSEL,
    exsel = SDL_SCANCODE_EXSEL,
    num00 = SDL_SCANCODE_KP_00,
    num000 = SDL_SCANCODE_KP_000,
    thousandSeparator = SDL_SCANCODE_THOUSANDSSEPARATOR,
    decimalSeparator = SDL_SCANCODE_DECIMALSEPARATOR,
    currencyUnit = SDL_SCANCODE_CURRENCYUNIT,
    currencySubunit = SDL_SCANCODE_CURRENCYSUBUNIT,
    numLeftParenthesis = SDL_SCANCODE_KP_LEFTPAREN,
    numRightParenthesis = SDL_SCANCODE_KP_RIGHTPAREN,
    numLeftBrace = SDL_SCANCODE_KP_LEFTBRACE,
    numRightBrace = SDL_SCANCODE_KP_RIGHTBRACE,
    numTab = SDL_SCANCODE_KP_TAB,
    numBackspace = SDL_SCANCODE_KP_BACKSPACE,
    numA = SDL_SCANCODE_KP_A,
    numB = SDL_SCANCODE_KP_B,
    numC = SDL_SCANCODE_KP_C,
    numD = SDL_SCANCODE_KP_D,
    numE = SDL_SCANCODE_KP_E,
    numF = SDL_SCANCODE_KP_F,
    numXor = SDL_SCANCODE_KP_XOR,
    numPower = SDL_SCANCODE_KP_POWER,
    numPercent = SDL_SCANCODE_KP_PERCENT,
    numLess = SDL_SCANCODE_KP_LESS,
    numGreater = SDL_SCANCODE_KP_GREATER,
    numAmpersand = SDL_SCANCODE_KP_AMPERSAND,
    numDblAmpersand = SDL_SCANCODE_KP_DBLAMPERSAND,
    numVerticalBar = SDL_SCANCODE_KP_VERTICALBAR,
    numDblVerticalBar = SDL_SCANCODE_KP_DBLVERTICALBAR,
    numColon = SDL_SCANCODE_KP_COLON,
    numHash = SDL_SCANCODE_KP_HASH,
    numSpace = SDL_SCANCODE_KP_SPACE,
    numAt = SDL_SCANCODE_KP_AT,
    numExclam = SDL_SCANCODE_KP_EXCLAM,
    numMemStore = SDL_SCANCODE_KP_MEMSTORE,
    numMemRecall = SDL_SCANCODE_KP_MEMRECALL,
    numMemClear = SDL_SCANCODE_KP_MEMCLEAR,
    numMemAdd = SDL_SCANCODE_KP_MEMADD,
    numMemSubtract = SDL_SCANCODE_KP_MEMSUBTRACT,
    numMemMultiply = SDL_SCANCODE_KP_MEMMULTIPLY,
    numMemDivide = SDL_SCANCODE_KP_MEMDIVIDE,
    numPlusMinus = SDL_SCANCODE_KP_PLUSMINUS,
    numClear = SDL_SCANCODE_KP_CLEAR,
    numClearEntry = SDL_SCANCODE_KP_CLEARENTRY,
    numBinary = SDL_SCANCODE_KP_BINARY,
    numOctal = SDL_SCANCODE_KP_OCTAL,
    numDecimal = SDL_SCANCODE_KP_DECIMAL,
    numHexadecimal = SDL_SCANCODE_KP_HEXADECIMAL,
    leftControl = SDL_SCANCODE_LCTRL,
    leftShift = SDL_SCANCODE_LSHIFT,
    leftAlt = SDL_SCANCODE_LALT,
    leftGUI = SDL_SCANCODE_LGUI,
    rightControl = SDL_SCANCODE_RCTRL,
    rightShift = SDL_SCANCODE_RSHIFT,
    rightAlt = SDL_SCANCODE_RALT,
    rightGUI = SDL_SCANCODE_RGUI,
    mode = SDL_SCANCODE_MODE,
    audioNext = SDL_SCANCODE_AUDIONEXT,
    audioPrev = SDL_SCANCODE_AUDIOPREV,
    audioStop = SDL_SCANCODE_AUDIOSTOP,
    audioPlay = SDL_SCANCODE_AUDIOPLAY,
    audioMute = SDL_SCANCODE_AUDIOMUTE,
    mediaSelect = SDL_SCANCODE_MEDIASELECT,
    www = SDL_SCANCODE_WWW,
    mail = SDL_SCANCODE_MAIL,
    calculator = SDL_SCANCODE_CALCULATOR,
    computer = SDL_SCANCODE_COMPUTER,
    acSearch = SDL_SCANCODE_AC_SEARCH,
    acHome = SDL_SCANCODE_AC_HOME,
    acBack = SDL_SCANCODE_AC_BACK,
    acForward = SDL_SCANCODE_AC_FORWARD,
    acStop = SDL_SCANCODE_AC_STOP,
    acRefresh = SDL_SCANCODE_AC_REFRESH,
    acBookmarks = SDL_SCANCODE_AC_BOOKMARKS,
    brightnessDown = SDL_SCANCODE_BRIGHTNESSDOWN,
    brightnessUp = SDL_SCANCODE_BRIGHTNESSUP,
    displaysWitch = SDL_SCANCODE_DISPLAYSWITCH,
    kbdIllumToggle = SDL_SCANCODE_KBDILLUMTOGGLE,
    kbdIllumDown = SDL_SCANCODE_KBDILLUMDOWN,
    kbdIllumUp = SDL_SCANCODE_KBDILLUMUP,
    eject = SDL_SCANCODE_EJECT,
    sleep = SDL_SCANCODE_SLEEP,
    app1 = SDL_SCANCODE_APP1,
    app2 = SDL_SCANCODE_APP2
}

/// Check whether the key associated with the ID is pressed. \
/// Do not reset the value.
bool isButtonDown(KeyButton button) {
    return _keys1[button];
}

/// Check whether the key associated with the ID is pressed. \
/// This function resets the value to false.
bool getButtonDown(KeyButton button) {
    const bool value = _keys2[button];
    _keys2[button] = false;
    return value;
}

/// Tells the application to finish.
void stopApplication() {
    _isRunning = false;
}

/// Check if the application's still running.
bool isRunning() {
    return _isRunning;
}

/// Capture les interruptions
extern (C) void signalHandler(int sig) nothrow @nogc @system {
    cast(void) sig;
    _isRunning = false;
}

/// Process and dispatch window, input, etc events.
bool processEvents() {
    SDL_Event sdlEvent;

    if (!_isRunning) {
        destroyWindow();
        return false;
    }

    while (SDL_PollEvent(&sdlEvent)) {
        switch (sdlEvent.type) {
        case SDL_QUIT:
            _isRunning = false;
            destroyWindow();
            return false;
        case SDL_KEYDOWN:
            if (sdlEvent.key.keysym.scancode >= _keys1.length)
                break;
            if (!sdlEvent.key.repeat) {
                _keys1[sdlEvent.key.keysym.scancode] = true;
                _keys2[sdlEvent.key.keysym.scancode] = true;
            }
            break;
        case SDL_KEYUP:
            if (sdlEvent.key.keysym.scancode >= _keys1.length)
                break;
            _keys1[sdlEvent.key.keysym.scancode] = false;
            _keys2[sdlEvent.key.keysym.scancode] = false;
            break;
        case SDL_CONTROLLERDEVICEADDED:
            //addController(sdlEvent.cdevice.which);
            break;
        case SDL_CONTROLLERDEVICEREMOVED:
            //removeController(sdlEvent.cdevice.which);
            break;
        case SDL_CONTROLLERDEVICEREMAPPED:
            //remapController(sdlEvent.cdevice.which);
            break;
        case SDL_CONTROLLERAXISMOTION:
            //setControllerAxis(sdlEvent.caxis.axis, sdlEvent.caxis.value);
            break;
        case SDL_CONTROLLERBUTTONDOWN:
            //setControllerButton(sdlEvent.cbutton.button, true);
            break;
        case SDL_CONTROLLERBUTTONUP:
            //setControllerButton(sdlEvent.cbutton.button, false);
            break;
        default:
            break;
        }
    }

    return true;
}

/// Main application loop
void runApplication() {
    createWindow();

    signal(SIGINT, &signalHandler);
    _isRunning = true;
    //initializeControllers();

    _tickStartFrame = Clock.currStdTime();

    // Script
    GrLibrary stdlib = grLoadStdLibrary();
    GrLibrary brumelib = loadBrumeLibrary();

    GrCompiler compiler = new GrCompiler;
    compiler.addLibrary(stdlib);
    compiler.addLibrary(brumelib);
    GrBytecode bytecode = compiler.compileFile("script/main.gr", GrOption.none);
    if (!bytecode)
        throw new Exception(compiler.getError().prettify());

    _engine = new GrEngine;
    _engine.addLibrary(stdlib);
    _engine.addLibrary(brumelib);
    _engine.load(bytecode);

    if (_engine.hasAction("main"))
        _engine.callAction("main");

    while (processEvents()) {
        //updateControllers(deltaTime);

        if (_engine.hasCoroutines)
            _engine.process();

        renderWindow();

        long deltaTicks = Clock.currStdTime() - _tickStartFrame;
        if (deltaTicks < (10_000_000 / _fps))
            Thread.sleep(dur!("hnsecs")((10_000_000 / _fps) - deltaTicks));

        deltaTicks = Clock.currStdTime() - _tickStartFrame;
        _tickStartFrame = Clock.currStdTime();
    }
}

/// Create the application window.
void createWindow() {
    enforce(loadSDL() >= SDLSupport.sdl202);
    enforce(loadSDLImage() >= SDLImageSupport.sdlImage200);
    enforce(loadSDLMixer() >= SDLMixerSupport.sdlMixer200);

    enforce(SDL_Init(SDL_INIT_EVERYTHING) == 0,
        "Could not initialize SDL: " ~ fromStringz(SDL_GetError()));

    enforce(Mix_OpenAudio(44_100, MIX_DEFAULT_FORMAT, MIX_DEFAULT_CHANNELS,
            1024) != -1, "No audio device connected.");
    enforce(Mix_AllocateChannels(16) != -1, "Could not allocate audio channels.");

    _width = CANVAS_WIDTH; // * 3;
    _height = CANVAS_HEIGHT; // * 3;

    enforce(SDL_CreateWindowAndRenderer(_width, _height,
            SDL_RENDERER_ACCELERATED | SDL_RENDERER_PRESENTVSYNC | SDL_WINDOW_RESIZABLE,
            &_sdlWindow, &_sdlRenderer) != -1, "Window initialization failed.");

    _renderTexture = SDL_CreateTexture(_sdlRenderer, SDL_PIXELFORMAT_RGBA8888,
        SDL_TEXTUREACCESS_TARGET, CANVAS_WIDTH, CANVAS_HEIGHT);

    SDL_RenderSetLogicalSize(_sdlRenderer, CANVAS_WIDTH, CANVAS_HEIGHT);

    setWindowTitle("Brume");
}

/// Cleanup the application window.
void destroyWindow() {
    //destroyControllers();

    if (_renderTexture !is null)
        SDL_DestroyTexture(_renderTexture);

    if (_sdlWindow)
        SDL_DestroyWindow(_sdlWindow);

    if (_sdlRenderer)
        SDL_DestroyRenderer(_sdlRenderer);

    Mix_CloseAudio();
}

/// Change the actual window title.
void setWindowTitle(string title) {
    SDL_SetWindowTitle(_sdlWindow, toStringz(title));
}

/// Change the icon displayed.
void setWindowIcon(string path) {
    if (_icon) {
        SDL_FreeSurface(_icon);
        _icon = null;
    }
    _icon = IMG_Load(toStringz(path));

    SDL_SetWindowIcon(_sdlWindow, _icon);
}

/// Render everything on screen.
void renderWindow() {
    SDL_SetRenderTarget(_sdlRenderer, _renderTexture);
    SDL_Rect destRect = {0, 0, _width, _height};

    { //Test
        SDL_SetRenderDrawColor(_sdlRenderer, 255, 255, 25, 255);
        const SDL_Rect rect = {5, 5, 1, 1};
        SDL_RenderFillRect(_sdlRenderer, &rect);
    }

    SDL_SetRenderTarget(_sdlRenderer, null);

    SDL_RenderCopy(_sdlRenderer, _renderTexture, null,
        &destRect);

    SDL_RenderPresent(_sdlRenderer);
}
