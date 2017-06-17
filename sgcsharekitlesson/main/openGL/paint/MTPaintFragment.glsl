
precision highp float;


uniform sampler2D Texture;
uniform sampler2D TextureMask;
varying vec2 TextureCoordsOut;
varying vec2 TextureCoordsOutMask;

uniform vec4 SourceColor;

void main(void){
    
    vec4 mask = texture2D(Texture, TextureCoordsOut);
    vec4 mask2 = texture2D(TextureMask,TextureCoordsOutMask);
    float gray = mask[0]*0.3+mask[1]*0.59+mask[2]*0.11;
    mask[0] = gray;
    mask[1] = gray;
    mask[2] = gray;

    float grey = dot(mask2.rgb, vec3(0.3,0.6,0.1));
    vec4 result = mask * (1.0 - grey) + gray * grey;
    
    
    gl_FragColor = vec4(mask.rgb,grey);
    
}

