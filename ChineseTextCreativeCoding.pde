PGraphics t_buffer;
PFont font1;
PShader edges; 
    
void setup() {
  size(640, 640, P2D);
  font1 = createFont("喜鹊乌冬面(简+繁体).ttf",128);
  t_buffer = createGraphics(640,640);
  t_buffer.beginDraw();
  t_buffer.background(100);
  t_buffer.fill(234,128,185);
  t_buffer.textAlign(CENTER);
  t_buffer.textFont(font1);
  t_buffer.text("我爱你", t_buffer.width/2, t_buffer.height/2);
  t_buffer.endDraw();
  image(t_buffer,0,0);
  
  //edges = loadShader("edges.glsl");
}

void draw() {
  //shader(edges);
  //image(img, 0, 0);
}
