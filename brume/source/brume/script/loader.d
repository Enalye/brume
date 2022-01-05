module brume.script.loader;

import grimoire;

import brume.script.graphics;

/// Loads all sub libraries
GrLibrary loadBrumeLibrary() {
    GrLibrary library = new GrLibrary;
    loadGraphicsLibrary(library);
    return library;
}
