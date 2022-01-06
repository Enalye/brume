module brume.script.loader;

import grimoire;

import brume.script.graphics, brume.script.input;

/// Loads all sub libraries
GrLibrary loadBrumeLibrary() {
    GrLibrary library = new GrLibrary;
    loadGraphicsLibrary(library);
    loadInputLibrary(library);
    return library;
}
