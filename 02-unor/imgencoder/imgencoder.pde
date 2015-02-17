
import supercollider.*;
import oscP5.*;
import processing.opengl.*;
import codeanticode.gsvideo.*;

PImage mapa;

int carret = 0;


GSCapture video;

boolean vid=  false;

boolean refresh = false;

boolean txt = true;

Synth s[];

int siz = 36;

void setup(){

  size(800,600,OPENGL);
  frameRate(100);

  mapa = loadImage("mapa.jpg");
  mapa.filter(INVERT);

  textFont(createFont("Monospaced",siz));

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

  image(mapa,width-mapa.width,0);

  fill(255);
  noStroke();


  int y = carret%height;



  line(0,0,width,height);

  for(int i = 0 ;i<1000;i++){
  stroke(255,noise((i+carret)/133.0)*25);
    float x = width*noise(carret/100.0+i/1000.0);
    line(x,0,x,height);
  }

  if(vid){
    if(video.available()){
      video.read();
      video.filter(GRAY);
    }

    if(video!=null){
      image(video,0,0,width,height);
    }
  }

  ellipse(width/2,height/2,100,100);


  if(txt)
  if(carret%(siz)==0){
    refresh = true;
    time = millis()+"";
    String tmp = "--------";
    //while(textWidth(tmp)<width)
     // tmp+=(char)(int)random(64,104);

    text = time+" "+tmp;
  }else{
    refresh = false;
  }

  if(txt)
  text(text,10,siz+y-(y%(siz)));

  loadPixels();
  for(int i = 0 ; i < width;i++){
    float val = map(brightness(pixels[y*width+i]),0,255,0,2.0);
    val = pow(val,2);
    val /= 255.0;
    s[i].set("amp",val);
  }

  stroke(255);
  line(0,y,width,y);

  carret += 1;
}

void exit(){
  for(int i = 0 ; i < width;i++)
    s[i].free();

  super.exit();

}
