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







// 片元着色器
#version 330 core
out vec4 FragColor;

in vec2 TexCoord; // 假设这是当前像素的纹理坐标

uniform sampler2D texture1;
uniform float time; // 时间，用于生成随机数
uniform int paintingMode; // 绘画模式
uniform float endR; // 最终半径
uniform int density; // 密度

// 伪随机数生成器
float random(vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898,78.233))) * 43758.5453123 + time);
}

// 计算两点之间的距离
float dist(vec2 p1, vec2 p2) {
    return length(p1 - p2);
}

// 缓动函数，如 easeInExpo
float easeInExpo(float x) {
    return x == 0.0 ? 0.0 : pow(2.0, 10.0 * x - 10.0);
}

void main()
{
    vec4 color = texture(texture1, TexCoord);
    vec2 center = vec2(0.5, 0.5); // 假设纹理的中心
    float r = dist(TexCoord, center) * endR; // 计算当前像素与中心的距离

    // 根据 paintingMode 应用不同的半径计算逻辑
    if (paintingMode == 1) {
        r = easeInExpo(r);
    }
    // 其他模式...

    // 根据半径和密度决定是否绘制颗粒
    if (random(TexCoord) < float(density) / r) {
        color.rgb = vec3(0.0); // 或者其他颗粒颜色
    }

    FragColor = color;
}
