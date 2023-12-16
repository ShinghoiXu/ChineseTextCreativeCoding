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
