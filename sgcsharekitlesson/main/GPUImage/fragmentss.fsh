precision highp float;
varying highp vec2 textureCoordinate;

uniform sampler2D inputImageTexture;


void main()
{

    vec4  mask = texture2D(inputImageTexture, textureCoordinate);
    
    for(int i = 0; i < 4; i ++ ){
        if (mask[i] < 0.5) {
            mask[i] += 0.5;
        }
    }
    gl_FragColor = vec4(mask.rgb, 0.1);
}
