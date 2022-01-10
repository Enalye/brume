module brume.image;

final class Image {
    package {
        uint _width;
        uint _height;
        ubyte[] _texels;
    }

    // Cteur
    this(uint width_, uint height_) {
        _width = width_;
        _height = height_;

        _texels = new ubyte[](_width * _height);
    }
}
