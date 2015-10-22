import gab.opencv.*;
import processing.video.*;
import java.awt.*;

Capture video;
OpenCV opencv;

String cameras[];
PVector pos,dim;

PGraphics oblicej;
PImage mask;

ArrayList images,positions;

float ratio = 1;
float crop = 28;

void init(){
  frame.removeNotify();
  frame.setUndecorated(true);
  frame.addNotify();
  super.init();
}

void setup() {
  size(1600,900,P2D);
  cameras = Capture.list();

  /*
     for(int i = 0 ; i < cameras.length;i++){
     println(i+" ~ "+cameras[i]);
     }
   */
  frameRate(30);

  images = new ArrayList();
  positions = new ArrayList();
  mask = loadImage("mask.png");

  pos = new PVector(width/4,height/2);
  dim = new PVector(1,1);

  video = new Capture(this, 320 ,240,"/dev/video1",30);
  opencv = new OpenCV(this, 320, 240);
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);  

  video.start();

  oblicej = createGraphics(150,175,P2D);

  background(0);
}

void draw() {

  if(frameCount<5)
    frame.setLocation(0,0);

  pushMatrix();
  //  scale(2);
  try{

    oblicej.beginDraw();
    oblicej.imageMode(CENTER);
    oblicej.image(video, -pos.x+(320/2+oblicej.width/4), -pos.y+(120+oblicej.width/4) );
    oblicej.endDraw();


    //background(0);

  }catch(Exception e){
    ;
  }
  popMatrix();
  noFill();

  background(0);
  try{
    oblicej.mask(mask);


    oblicej.loadPixels();
    PImage tmp = createImage(oblicej.width,oblicej.height,ARGB);
    tmp.pixels = oblicej.pixels;
    images.add(tmp);
    positions.add(new PVector(map(pos.x,0,320,width,0),map(pos.y,0,240,0,height)));
  }catch(Exception e){
    ;
  }

  int counter = 0;

  try{
    /*
       PGraphics neu = createGraphics(64,32,JAVA2D);

       neu.beginDraw();
       neu.image(oblicej,0,0);
       neu.endDraw();
     */
    int w = 0;
    int h = 0;
render:
    for(int i = 0 ; i < images.size();i++){
      PImage tmp = (PImage)images.get(i);
      PVector poss = (PVector)positions.get(i);
      image(tmp,w,h,tmp.width/ratio,tmp.height/ratio);
      counter++;
      w+=tmp.width/ratio-crop;
      if(w>width){
        w=0;
        h+=tmp.height/ratio-crop;
      }
      if(h>height-100)
        break render;
    }

  }catch(Exception e){;}

  if(images.size()>counter){
    images.remove(0);
    positions.remove(0);
  }





  Rectangle[] faces = opencv.detect();

  noStroke();
  for (int i = 0; i < faces.length; i++) {
    //println(faces[i].x + "," + faces[i].y);
    if(i==0){
      pos.x+=((faces[i].x)-pos.x)/2;
      pos.y+=(faces[i].y-pos.y)/2;
      dim.x+=(faces[i].width-dim.x)/2;
      dim.y+=(faces[i].height-dim.y)/2;
    }
    //rect(faces[i].x, faces[i].y, faces[i].width, faces[i].height);
  }
  noStroke();
  fill(#ffcc00);
  //ellipse(width-(pos.x*2),pos.y*2,dim.x/8,dim.y/8);


  try{

    image(oblicej,0,0);
  }catch(Exception e){;}

}

void captureEvent(Capture c) {
  c.read();
  opencv.loadImage(video);
}
