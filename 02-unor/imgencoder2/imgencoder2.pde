import processing.opengl.*;
import supercollider.*;
import oscP5.*;

PImage mapa;

int carret = 0;
int speed = 2;


boolean vid=  false;

boolean refresh = false;

boolean txt = false;

Synth s[];

int siz = 18;

String time = "";
String text = "";
String ttmp[];

void setup(){

  size(800,600,OPENGL);
  frameRate(100);


  ttmp = loadStrings("/tmp/all.txt");



  println(PFont.list());

  textFont(createFont("Liberation Sans",siz));



  s = new Synth[width];

  for(int i = 0 ; i<s.length;i++){
    s[i] = new Synth("oscill");
    s[i].set("freq",map(i,0,width,0,22000));
    s[i].set("amp",0);
    s[i].create();
  }

}


void reload(){

  mapa = loadImage("mapa.jpg");
  mapa.filter(INVERT);


}

int cnt = 0;
int y = 0;
int skip = 0;

void keyPressed(){
  if(key==' '){

    reload();

  }
}
void draw(){
  background(0);

  fill(255);


  
  cnt =0;
  y = 0;

  ArrayList curr = new ArrayList();

  while(y<height){
    curr.add(ttmp[cnt+skip]);
    cnt++;
    y = cnt*siz;
  }

  for(int i = 0 ; i < curr.size();i++){
    String tmp = (String)curr.get(i);
    text(tmp,10,siz+siz*i);
  }

  sonify();
}

void sonify(){

  loadPixels();
  for(int i = 0 ; i < width;i++){
    float val = map(brightness(pixels[carret*width+i]),0,255,0,2.0);
    val = pow(val,2);
    val /= 255.0;
    s[i].set("amp",val);
  }

  stroke(255);
  line(0,carret,width,carret);

  carret += speed;

  if(carret>=height){
    carret=0;
    skip += cnt;
  }

}

void exit(){
  for(int i = 0 ; i < width;i++)
    s[i].free();

  super.exit();

}
