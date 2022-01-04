module brume.render.drawable;

import brume.core;

/// Renderable class
abstract class Drawable {
    /// Render on screen
    void draw(const Vec2f position);
}