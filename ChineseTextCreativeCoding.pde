PGraphics t_buffer,r_buffer;
PFont font1;
PShader testShader; 
//int i = 1;
String[] myTextLines;
int lineCounter = 0;
float secPerLine = 0.0f;
color lineColor;
int previousSec = 0;

void setup() {
  size(640, 640, P2D);
  colorMode(HSB);
  font1 = createFont("喜鹊乌冬面(简+繁体).ttf",128);
  myTextLines = loadStrings("testText.txt");
  lineColor = randomColorGenHSB();
  previousSec = millis();
  secPerLine = myTextLines[0].length()*0.42f;
  t_buffer = createGraphics(width,height,P2D);
  t_buffer.beginDraw();
  t_buffer.textAlign(CENTER,CENTER);
  t_buffer.textFont(font1);
  t_buffer.colorMode(HSB);
  t_buffer.endDraw();
  drawText();
  r_buffer = createGraphics(t_buffer.width,t_buffer.height,P2D);
  //testShader = loadShader("Grainy.glsl");  //you can play with another shader as well
  testShader = loadShader("Grainy2.glsl");
  testShader.set("grainyR",min(t_buffer.height,t_buffer.width)/20);
  testShader.set("brightnessLowThreshold",0.1f);
  testShader.set("brightnessHighThreshold",0.8f);
  testShader.set("easeSelector",4);

  frameRate(10);  //delete this for higher frameRate
}

void draw() {
  background(0);

  copyGraphics(t_buffer,r_buffer);
  testShader.set("time",millis() / 1000.0);
  r_buffer.filter(testShader);
  
  //i++;
  //testShader.set("grainyR",i);  //one way to play around with the parameter
  
  image(r_buffer,0,0,width,height);
  String txt_fps = String.format(getClass().getName()+ " [fps %6.2f]", frameRate);
  surface.setTitle(txt_fps);
  
  /*
  while(myTextLines[lineCounter].length()==0 && (lineCounter+1) <= myTextLines.length){
    lineCounter++;
  }
  */
  
  if ((millis() - previousSec) > (secPerLine * 1000) && lineCounter <= myTextLines.length - 1){
    lineColor = randomColorGenHSB();
    drawText();
    previousSec = millis();
    secPerLine = max(2.2f,myTextLines[lineCounter].length()*0.42f);
    if (myTextLines[lineCounter].length()==0) secPerLine = 0.9f;
    println(lineCounter+" "+secPerLine);
    lineCounter++;
  }
  
  saveFrame("PoemTest-######.jpg");
  //saveFrame("我爱你-######.png");
  //if(frameCount >= 90) exit();
  if (lineCounter >= myTextLines.length && (millis() - previousSec) > (secPerLine * 1000)) exit();

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

color randomColorGenHSB()
{
  return color(random(255),110,230);
}

void drawText(){
  t_buffer.beginDraw();
  t_buffer.clear();
  t_buffer.background(0);
  t_buffer.fill(lineColor);
  if (myTextLines[lineCounter].length()!=0) t_buffer.textSize(t_buffer.width/myTextLines[lineCounter].length()*0.8f);
  t_buffer.text(myTextLines[lineCounter], t_buffer.width/2, t_buffer.height/2);
  t_buffer.text(myTextLines[lineCounter], t_buffer.width/2, t_buffer.height/2);
  t_buffer.endDraw();
}
