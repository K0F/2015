import processing.opengl.*;
import supercollider.*;
import oscP5.*;

PImage mapa;

int carret = 0;
int speed = 2;


boolean vid=  false;

boolean refresh = false;

boolean txt = false;

  ArrayList curr = new ArrayList();
Synth s[];

int siz = 128;

String time = "";
String text = "";
String ttmp = "this is process not product!";

void setup(){

  size(1024,768,OPENGL);
  frameRate(100);





  println(PFont.list());

  textFont(createFont("Monospace",siz));



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
  if(keyCode == DELETE)
  ttmp = "";

    ttmp += ""+key;
      //curr = new ArrayList();

      //curr.add(ttmp+"");

  //  reload();

}
void draw(){
  background(0);

  fill(255);



  cnt =0;
  y = 0;


    //  while(y<height){
    
      //curr.add(ttmp[cnt+skip]);
    //  cnt++;
    //  y = cnt*siz;
   // }

    //String tmp = (String)curr.get(i);
    textAlign(LEFT);
    text(ttmp,10,height/2,width,height);

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
