import processing.video.*;

Capture video;

PGraphics gsw;

int prevX;
int prevY;

void setup(){
  size(640, 480);
  background(255);
  video = new Capture(this, width, height, 60);
  video.start();
  gsw = createGraphics(width, height);  
  
  prevX = -1;
  prevY = -1;
}

void draw(){
  video.loadPixels();
  int avgX = 0;
  int avgY = 0;
  int count = 0;
  
  for(int x = 0; x < width; x++){
    for(int y = 0; y < height; y++){
      int loc = x + y * width;
      color c = video.pixels[loc];
      float r = red(c);
      float g = green(c);
      float b = blue(c);
      
      float r1 = 10;
      float g1 = 38;
      float b1 = 28;
      
      if(distSq(r,r1,g,g1,b,b1) < 5*5){
        avgX += x;
        avgY += y;
        count++;
      }
    }
  }
  if(mousePressed){
    if(count != 0){
      if(prevX == -1){
        prevX = avgX/count;
        prevY = avgY/count;
        drawOnGraphics(avgX/count, avgY/count, prevX, prevY);
      }else{
        drawOnGraphics(avgX/count, avgY/count, prevX, prevY);
      }
      prevX = avgX/count;
      prevY = avgY/count;
    }
  }else{
    prevX = -1;
    prevY = -1;
  }
  
  pushMatrix();
  translate(width,0);
  scale(-1,1); 
  image(video,0,0);
  image(gsw,0,0);
  popMatrix();
  //if(mousePressed){
  //  int loc = mouseX + mouseY * width;
  //  color c = video.pixels[loc];
  //  float r = red(c);
  //  float g = green(c);
  //  float b = blue(c);
  //  System.out.println(r + " " + g + " " + b);
  //}
}

void drawOnGraphics(int x, int y, int prevX, int prevY){
  gsw.beginDraw();
  gsw.fill(0,255,255);
  gsw.stroke(0,255,255);
  gsw.strokeWeight(10);
  gsw.line(x,y,prevX,prevY);
  gsw.endDraw();
}

void captureEvent(Capture video){  
  video.read();
}

double distSq(float r, float r1, float g, float g1, float b, float b1){
  double d = (r-r1)*(r-r1) + (g-g1)*(g-g1) + (b-b1)*(b-b1);
  return d;
}