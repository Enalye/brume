module brume.font;

import std.uni: toLower;

private ulong[256] _font = [
    0b00000_00000_01110_10001_10001_10001_10001_10001_01110, //0
    0b00000_00000_00100_01100_10100_00100_00100_00100_11111, //1
    0b00000_00000_01110_10001_00001_00010_00100_01000_11111, //2
    0b00000_00000_01110_10001_00001_00110_00001_10001_01110, //3
    0b00000_00000_00011_00101_01001_10001_11111_00001_00001, //4
    0b00000_00000_11111_10000_10000_01110_00001_10001_01110, //5
    0b00000_00000_01110_10001_10000_11110_10001_10001_01110, //6
    0b00000_00000_11111_00001_00001_00010_00100_01000_10000, //7
    0b00000_00000_01110_10001_10001_01110_10001_10001_01110, //8
    0b00000_00000_01110_10001_10001_01111_00001_10001_01110, //9
    0b00000_00000_01110_10001_10001_11111_10001_10001_10001, //A
    0b00010_00100_01110_10001_10001_11111_10001_10001_10001, //Á
    0b01000_00100_01110_10001_10001_11111_10001_10001_10001, //À
    0b01110_00000_01110_10001_10001_11111_10001_10001_10001, //Â
    0b01010_00000_01110_10001_10001_11111_10001_10001_10001, //Ä
    0b00000_00000_01111_10100_10100_11110_10100_10100_10111, //Æ
    0b00000_00000_11110_10001_10001_11110_10001_10001_11110, //B
    0b00000_00000_01110_10001_10000_10000_10000_10001_01110, //C
    0b00000_00000_01110_10001_10000_10000_10001_01110_11000, //Ç
    0b01110_00000_01110_10001_10000_10000_10000_10001_01110, //Ĉ
    0b00000_00000_11110_10001_10001_10001_10001_10001_11110, //D
    0b00000_00000_11111_10000_10000_11110_10000_10000_11111, //E
    0b00010_00100_11111_10000_10000_11110_10000_10000_11111, //É
    0b01000_00100_11111_10000_10000_11110_10000_10000_11111, //È
    0b01110_00000_11111_10000_10000_11110_10000_10000_11111, //Ê
    0b01010_00000_11111_10000_10000_11110_10000_10000_11111, //Ë
    0b00000_00000_11111_10000_10000_11110_10000_10000_10000, //F
    0b00000_00000_01110_10001_10001_10000_10111_10001_01110, //G
    0b01110_00000_01110_10001_10001_10000_10111_10001_01110, //Ĝ
    0b00000_00000_10001_10001_10001_11111_10001_10001_10001, //H
    0b01110_10001_10001_00000_10001_11111_10001_10001_10001, //Ĥ
    0b00000_00000_11111_00100_00100_00100_00100_00100_11111, //I
    0b00010_00100_11111_00100_00100_00100_00100_00100_11111, //Í
    0b01000_00100_11111_00100_00100_00100_00100_00100_11111, //Ì
    0b01110_00000_11111_00100_00100_00100_00100_00100_11111, //Î
    0b01010_00000_11111_00100_00100_00100_00100_00100_11111, //Ï
    0b00000_00000_11111_00100_00100_00100_10100_10100_01100, //J
    0b01110_00000_11111_00100_00100_00100_10100_10100_01100, //Ĵ
    0b00000_00000_10001_10010_10100_11000_10100_10010_10001, //K
    0b00000_00000_10000_10000_10000_10000_10000_10000_11111, //L
    0b00000_00000_10001_11011_10101_10001_10001_10001_10001, //M
    0b00000_00000_10001_11001_10101_10011_10001_10001_10001, //N
    0b00000_00000_01110_10001_10001_10001_10001_10001_01110, //O
    0b00010_00100_01110_10001_10001_10001_10001_10001_01110, //Ó
    0b01000_00100_01110_10001_10001_10001_10001_10001_01110, //Ò
    0b01110_00000_01110_10001_10001_10001_10001_10001_01110, //Ô
    0b01010_00000_01110_10001_10001_10001_10001_10001_01110, //Ö
    0b00000_00000_11110_10001_10001_11110_10000_10000_10000, //P
    0b00000_00000_01110_10001_10001_10001_10001_01110_00001, //Q
    0b00000_00000_11110_10001_10001_11110_10100_10010_10001, //R
    0b00000_00000_01110_10001_10000_01110_00001_10001_01110, //S
    0b01110_00000_01110_10001_10000_01110_00001_10001_01110, //Ŝ
    0b00000_00000_11111_00100_00100_00100_00100_00100_00100, //T
    0b00000_00000_10001_10001_10001_10001_10001_10001_01110, //U
    0b00010_00100_10001_10001_10001_10001_10001_10001_01110, //Ú
    0b01000_00100_10001_10001_10001_10001_10001_10001_01110, //Ù
    0b01110_00000_10001_10001_10001_10001_10001_10001_01110, //Û
    0b01010_00000_10001_10001_10001_10001_10001_10001_01110, //Ü
    0b10001_01110_00000_10001_10001_10001_10001_10001_01110, //Ŭ
    0b00000_00000_10001_10001_01010_01010_01010_00100_00100, //V
    0b00000_00000_10001_10001_10001_10101_10101_10101_01010, //W
    0b00000_00000_10001_10001_01010_00100_01010_10001_10001, //X
    0b00000_00000_10001_01010_00100_00100_00100_00100_00100, //Y
    0b00000_00000_11111_00001_00010_00100_01000_10000_11111, //Z

];

private dchar[] _symbols = [
    '0',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    'a',
    'á',
    'à',
    'â',
    'ä',
    'æ',
    'b',
    'c',
    'ç',
    'ĉ',
    'd',
    'e',
    'é',
    'è',
    'ê',
    'ë',
    'f',
    'g',
    'ĝ',
    'h',
    'ĥ',
    'i',
    'í',
    'ì',
    'î',
    'ï',
    'j',
    'ĵ',
    'k',
    'l',
    'm',
    'n',
    'o',
    'ó',
    'ò',
    'ô',
    'ö',
    'p',
    'q',
    'r',
    's',
    'ŝ',
    't',
    'u',
    'ú',
    'ù',
    'û',
    'ü',
    'ǔ',
    'v',
    'w',
    'x',
    'y',
    'z',
];

private size_t[dchar] _table;

void initFont() {
    for(size_t i; i < _symbols.length; ++i) {
        _table[_symbols[i]] = i;
    }
}

ulong getGlyphData(dchar ch) {
    size_t* p = ch.toLower in _table;
    return p ? _font[*p] : 0;
}
