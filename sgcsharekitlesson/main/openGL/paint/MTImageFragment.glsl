
precision highp float;

uniform sampler2D Texture;
varying vec2 TextureCoordsOut;

void main(void)
{
    vec4 mask = texture2D(Texture, TextureCoordsOut);
    gl_FragColor = vec4(0.5, 0.4, 0.8, 1.0);
    
}
