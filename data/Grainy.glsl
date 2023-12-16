#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

#define PROCESSING_TEXTURE_SHADER

uniform sampler2D texture;
uniform vec2 texOffset;
uniform int grainyR;

varying vec4 vertColor;
varying vec4 vertTexCoord;

float easeInExpo(float x) {
    if (x == 0.0) {
        return 0.0;
    } else {
        return pow(2.0, 10.0 * x - 10.0);
    }
}

float easeInOutSine(float x) {
    return -(cos(3.141592653589793 * x) - 1.0) / 2.0;
}

float easeOutCirc(float x) {
    return sqrt(1.0 - pow(x - 1.0, 2.0));
}

void main(void) {
  
  float mixFactor = 0.5;
  vec4 orig = vec4(texture2D(texture, vertTexCoord.st).rgb,mixFactor);    //sampling
  
  int dotCount = 0;
  for (int i = -grainyR; i <= grainyR; i++) {
    for (int j = -grainyR; j <= grainyR; j++){
      if (distance(vec2(float(i),float(j)),vec2(0.0,0.0)) <= grainyR){
        vec2 offsetCoord = vertTexCoord.st + vec2(float(i), float(j)) * texOffset.st;
        if(vec4(texture2D(texture, offsetCoord)) != vec4(0.0,0.0,0.0,0.0)) dotCount++;
      }
    }
  }
  vec4 grainyLayer = vec4(0.0,0.0,0.0,0.0);

  for (int i = -grainyR; i <= grainyR; i++) {
    for (int j = -grainyR; j <= grainyR; j++){
      if (distance(vec2(float(i),float(j)),vec2(0.0,0.0)) <= grainyR){
        vec2 offsetCoord = vertTexCoord.st + vec2(float(i), float(j)) * texOffset.st;
        grainyLayer += vec4(texture2D(texture, offsetCoord));
      }
    }
  }
  
  grainyLayer /= dotCount;
  orig = mix(orig,grainyLayer,mixFactor);


  gl_FragColor = vec4(orig.rgb,1.0) * vertColor;  
}
