#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

#define PROCESSING_TEXTURE_SHADER

uniform sampler2D texture;
uniform vec2 texOffset;

uniform float time;
uniform int grainyR;
uniform float brightnessLowThreshold;
uniform float brightnessHighThreshold;
uniform int easeSelector;
float mixFactor = 1.0f;

varying vec4 vertColor;
varying vec4 vertTexCoord;

float easeOutExpo(float x) {
    return x == 1.0 ? 1.0 : 1.0 - pow(2.0, -10.0 * x);
}

float easeInOutSine(float x) {
    return -(cos(3.141592653589793 * x) - 1.0) / 2.0;
}

float easeOutCirc(float x) {
    return sqrt(1.0 - pow(x - 1.0, 2.0));
}

float easeOutQuint(float x) {
    return 1.0 - pow(1.0 - x, 5.0);
}

float easeOutBounce(float x) {
    const float n1 = 7.5625;
    const float d1 = 2.75;

    if (x < 1.0 / d1) {
        return n1 * x * x;
    } else if (x < 2.0 / d1) {
        x -= 1.5 / d1;
        return n1 * x * x + 0.75;
    } else if (x < 2.5 / d1) {
        x -= 2.25 / d1;
        return n1 * x * x + 0.9375;
    } else {
        x -= 2.625 / d1;
        return n1 * x * x + 0.984375;
    }
}

float easeFunc(float x){
  if (easeSelector == 1){
    return easeOutExpo(x);
  }
  else if (easeSelector == 2){
    return easeInOutSine(x);
  }
  else if (easeSelector == 3){
    return easeOutCirc(x);
  }
  else if (easeSelector == 4){
    return easeOutQuint(x);
  }
  else if (easeSelector == 5){
    return easeOutBounce(x);
  }
}

vec3 rgbToHsb(vec3 c){
    vec4 K = vec4(0.0, -1.0/3.0, 2.0/3.0, -1.0);
    vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
    vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));

    float d = q.x - min(q.w, q.y);
    float e = 1.0e-10;
    return vec3(abs((q.w - q.y) / (6.0 * d + e) + K.z), d / (q.x + e), q.x);
}

float random(vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898,78.233))) * 43758.5453123 + time);
}

vec3 randomColorOffset(vec3 color) {  //[-0.1, 0.1]
    vec3 newColor = color + vec3(random(vec2(color.r+color.g,color.g+color.b)) * 0.1 - 0.05,random(vec2(color.r+color.g,color.g+color.b)) * 0.1 - 0.05,random(vec2(color.r+color.g,color.g+color.b)) * 0.1 - 0.05);
    newColor = clamp(newColor, 0.0, 1.0);
    return newColor;
}

void main(void) {
  vec4 orig = vec4(texture2D(texture, vertTexCoord.st).rgb,1);    //sampling
  int dotCount = 0;
  vec4 grainyLayer = vec4(0.0,0.0,0.0,0.0);

  for (int i = -grainyR; i <= grainyR; i++) {
    for (int j = -grainyR; j <= grainyR; j++){
      if (distance(vec2(float(i),float(j)),vec2(0.0,0.0)) <= grainyR){  //traverse all the pixels in the circle around the current pixel
        vec2 offsetCoord = vertTexCoord.st + vec2(float(i), float(j)) * texOffset.st;
        vec4 offsetPixel = vec4(texture2D(texture, offsetCoord));
        if(rgbToHsb(orig.rgb).z < brightnessLowThreshold //threshold for pixels to receive light
            && rgbToHsb(offsetPixel.rgb).z > brightnessHighThreshold)  //threshold for pixels to emit light     
        {
          if (random(vertTexCoord.st+offsetCoord.st) > 0.99f
            && random(offsetCoord.st) > easeFunc(distance(vec2(float(i),float(j)),vec2(0.0,0.0))/grainyR))
            //calculate "light" falloff using Monte Carlo algorithm. It calculates decays so the inequality sign is reversed
            {
              dotCount++; 
              grainyLayer += vec4(randomColorOffset(offsetPixel.rgb),1.0f);
            }
        }   
      }
    }
  }
  
  if (dotCount!=0) grainyLayer /= dotCount;
    else grainyLayer = orig;
  orig = mix(orig,grainyLayer,mixFactor);
  gl_FragColor = vec4(orig.rgb,1.0) * vertColor;  
}
