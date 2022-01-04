module brume.script.loader;

import grimoire;

import brume.script.window, brume.script.drawable, brume.script.texture,
    brume.script.primitive, brume.script.sprite, brume.script.text,
    brume.script.triangle;

/// Loads all sub libraries
GrLibrary loadBrumeLibrary() {
    GrLibrary library = new GrLibrary;
    loadBrumeLibWindow(library);
    loadBrumeLibDrawable(library);
    loadBrumeLibTexture(library);
    loadBrumeLibPrimitive(library);
    loadBrumeLibSprite(library);
    loadBrumeLibText(library);
    loadBrumeLibTriangle(library);
    return library;
}
