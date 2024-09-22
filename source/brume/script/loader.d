/** 
 * Copyright: Enalye
 * License: Zlib
 * Authors: Enalye
 */
module brume.script.loader;

import grimoire;

import brume.script.graphics, brume.script.input;

private GrModuleLoader[] _libLoaders = [
    &loadGraphicsLibrary, &loadInputLibrary
];

/// Loads all sub libraries
GrLibrary loadBrumeLibrary() {
    GrLibrary library = new GrLibrary(1);
    foreach (GrModuleLoader loader; _libLoaders) {
        library.addModule(loader);
    }
    return library;
}
