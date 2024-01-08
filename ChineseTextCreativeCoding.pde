PGraphics t_buffer,r_buffer;
PFont font1;
PShader testShader; 
int i = 1;
    
void setup() {
  
  size(640, 640, P2D);
  font1 = createFont("喜鹊乌冬面(简+繁体).ttf",128);
  t_buffer = createGraphics(640,640,P2D);
  t_buffer.beginDraw();
  t_buffer.background(0);
  t_buffer.fill(234,128,185);
  t_buffer.textAlign(CENTER);
  t_buffer.textFont(font1);
  t_buffer.text("我爱你", t_buffer.width/2, t_buffer.height/2);
  t_buffer.endDraw();
  
  r_buffer = t_buffer;
  //testShader = loadShader("Grainy.glsl");
  //testShader.set("grainyR",100);
  testShader = loadShader("Grainy.glsl");
  

}

void draw() {
  r_buffer = t_buffer;
  i++;
  //testShader.set("grainyR",i);
  r_buffer.filter(testShader);
  image(t_buffer,0,0);
  //saveFrame("我爱你-######.jpg");
  //if(frameCount > 90) exit();
}
