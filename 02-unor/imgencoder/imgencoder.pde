
import supercollider.*;
import oscP5.*;
import processing.opengl.*;
import codeanticode.gsvideo.*;
   
GSCapture video;

boolean vid=  false;

boolean refresh = false;

Synth s[];

void setup(){

  size(800,600);
  frameRate(100);

  textFont(createFont("Monaco",29));

  video = new GSCapture(this,640,480);
  video.start();


  s = new Synth[width];

  for(int i = 0 ; i<s.length;i++){
    s[i] = new Synth("oscill");
    s[i].set("freq",map(i,0,width,0,22000));
    s[i].set("amp",0);
    s[i].create();
  }

}




String time = "";
String text = "";

void draw(){
  background(0);


  fill(255);
  noStroke();
  

  int y = frameCount%height;

  

  stroke(255);
  line(0,0,width,height);

if(vid){
  if(video.available()){
    video.read();
  video.filter(GRAY);
  }

  if(video!=null){
    image(video,0,0,width,height);
  }
}


if(frameCount%30==0){
refresh = true;
time = millis()+"";
String tmp = "";
while(textWidth(tmp)<width)
  tmp+=(char)(int)random(64,104);

text = time+" "+tmp;
}else{
refresh = false;
}

  text(text,10,30+y-(y%30));

  loadPixels();
  for(int i = 0 ; i < width;i++){
    float val = map(brightness(pixels[y*width+i]),0,255,0,2.0);
    val = pow(val,2);
    val /= 255.0;
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
