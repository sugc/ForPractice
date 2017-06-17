
attribute vec4 Position;
attribute vec2 TextureCoords;
attribute vec2 TextureCoordsMask;
varying vec2 TextureCoordsOut;
varying vec2 TextureCoordsOutMask;

void main(void)
{
    gl_Position = Position;
    TextureCoordsOut = TextureCoords;
    TextureCoordsOutMask = TextureCoordsMask;
}
