PGraphics t_buffer,r_buffer;
PFont font1;
PShader testShader; 
int i = 1;
float time;
    
void setup() {
  
  size(640, 640, P2D);
  font1 = createFont("喜鹊乌冬面(简+繁体).ttf",128);
  t_buffer = createGraphics(width,height,P2D);
  t_buffer.beginDraw();
  t_buffer.smooth();
  t_buffer.background(0);
  t_buffer.fill(234,128,185);
  t_buffer.textAlign(CENTER);
  t_buffer.textFont(font1);
  t_buffer.text("我爱你", t_buffer.width/2, t_buffer.height/2);
  t_buffer.endDraw();
  r_buffer = createGraphics(width,height,P2D);
  //testShader = loadShader("Grainy.glsl");
  testShader = loadShader("Grainy2.glsl");
  testShader.set("grainyR",12);
  
}

void draw() {
  background(0);
  copyGraphics(t_buffer,r_buffer);
  time = millis() / 1000.0;
  testShader.set("time",time);
  r_buffer.filter(testShader);
  
  //i++;
  //testShader.set("grainyR",i);
  r_buffer.beginDraw();
  r_buffer.fill(234,128,185);
  r_buffer.textAlign(CENTER);
  r_buffer.textFont(font1);
  r_buffer.text("我爱你", t_buffer.width/2, t_buffer.height/2);
  r_buffer.endDraw();
  
  image(r_buffer,0,0);
  String txt_fps = String.format(getClass().getName()+ " [fps %6.2f]", frameRate);
  surface.setTitle(txt_fps);
  saveFrame("我爱你-######.jpg");
  if(frameCount >= 90) exit();
}

void copyGraphics(PGraphics a, PGraphics b)
{
  // b = a;
  a.loadPixels();
  b.loadPixels();
  b.beginDraw();
  for (int i = 0; i < b.pixels.length; i++) 
  {
    b.pixels[i] = a.pixels[i];
  }
  //a.updatePixels();
  b.updatePixels();
  b.endDraw();
}
