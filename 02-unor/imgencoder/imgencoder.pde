
import supercollider.*;
import oscP5.*;


Synth s[];

void setup(){

  size(800,600);
  frameRate(100);

  s = new Synth[width];

  for(int i = 0 ; i<s.length;i++){
    s[i] = new Synth("oscill");
    s[i].set("freq",map(i,0,width,0,22000));
    s[i].set("amp",0);
    s[i].create();
  }

}




void draw(){

  background(0);

  fill(255);
  noStroke();
  ellipse(width/2,height/2,300,300);

  int y = frameCount%height;


  stroke(255);
  strokeWeight(5);
  line(0,0,width,height);




  loadPixels();
  for(int i = 0 ; i < width;i++){
    float val = map(brightness(pixels[y*width+i]),0,255,0,0.005);
    s[i].set("amp",val);
  }

  stroke(255);
  line(0,y,width,y);

}

void exit(){
  for(int i = 0 ; i < width;i++)
    s[i].free();

  super.exit();

}
