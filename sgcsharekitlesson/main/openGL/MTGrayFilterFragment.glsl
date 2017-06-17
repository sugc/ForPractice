
precision mediump float;

uniform sampler2D Texture;
uniform sampler2D TextureMask;
varying vec2 TextureCoordsOut;
varying vec2 TextureCoordsOutMask;

void main(void){

    vec4 mask = texture2D(Texture, TextureCoordsOut);
    float gray = mask[0]*0.3+mask[1]*0.59+mask[2]*0.11;
    mask[0] = gray ;
    mask[1] = gray;
    mask[2] = gray;
    gl_FragColor = vec4(mask.rgb, 1.0);

}

