import processing.video.*;

import oscP5.*;
import netP5.*;


OscP5 oscP5;
NetAddress myRemoteLocation;

Movie mov[];

PImage huge;
PFont font;

boolean CTL = false;
boolean bang = false;
ArrayList notes;
float START = 0;
float LAST = 0;
float MIN = 22000;
float MAX = 0;
float FREQ =0;
float TIME =0;
float RTIME = 0;


int LIMIT = 500;
int sel = 0;

void setup() {
  size(1024,1024,P2D);
  noiseSeed(2015);

  mov=  new Movie[5];
  mov[0] = new Movie(this,"one.mpg");
  mov[1] = new Movie(this,"two.mpg");
  mov[2] = new Movie(this,"three.mpg");
  mov[3] = new Movie(this,"four.mpg");
  mov[4] = new Movie(this,"five.mpg");

  for(int i = 0 ; i<mov.length;i++){
    mov[i].play();
    mov[i].pause();
  }

  font = createFont("Monospaced",96);
  textFont(font,96);

  oscP5 = new OscP5(this,12000);
  notes = new ArrayList();
}
void movieEvent(Movie m) {
  m.read();
}
void draw(){
  background(0);
  /*
     noStroke();
     fill(0,35);
     rectMode(CORNERS);
     rect(0,0,width,height);
   */
  if(bang){
    notes.add(new Note(TIME,FREQ));
  }

  if(notes.size()>LIMIT){
    notes.remove(0);

    Note first = (Note)notes.get(0);
    START = first.time;
  }

  bang = false;

  RTIME = millis()/1000.0;

  for(Object o:notes){
    Note tmp = (Note)o;
    tmp.draw();
  }

/*
     mov[sel].play();//jump(map(mouseX,0,width,0,mov.duration()));

     mov[sel].jump(map(mouseX,0,width,0,mov[sel].duration()));
     mov[sel].pause();//jump(map(mouseX,0,width,0,mov.duration()));
      image(mov[sel],0,0);
*/
  colorMode(HSB);
  for(int i = 0 ; i < mov.length;i++){
    tint(noise((frameCount+((i+1)*100.0))/10.0)*255,255,255,70);
    image(mov[i],0,0);
  }
}

void mousePressed(){
  sel++;
  sel = sel%5;
}

class Note{
  int id;
  float time;
  float rtime;
  float freq;
  float fade;

  Note(float _time,float _freq){
    id = notes.size();
    time = _time;
    freq = _freq;
    rtime = RTIME;

    if(id==0){
      START = time;
    }else{
      LAST = time;
    }

    MIN = min(freq,MIN);
    MAX = max(freq,MAX);

    fade = 150;
  }

  void draw(){
    rectMode(CENTER);
    noStroke();
    fill(255,120);
    rect(map(rtime,RTIME-100,RTIME,20,width-20),map(freq,MIN,MAX,height/3,-height/3)+height/2,3,3);

    if(fade>=0){
      fade-=4;
      //noFill();
      //strokeWeight(3);
      noStroke();
      //colorMode(HSB);
      fill(255,fade);
      textAlign(CENTER,CENTER);
      text(round(freq),width/2,height/2);
      /* 
         pushMatrix();
         translate(0,height/2);
         beginShape();
         for(int i = 0 ; i < 200;i++){
         float val = noise(i/100.0+(freq/100.0)*(fade/1000.0))*200.0;

         float x = map(i,0,200,0,width);
         float y = sin(TWO_PI/200.0*i) * val;

         vertex(x,y);
         }
         endShape();
         popMatrix();
       */
    }

  }


}

void oscEvent(OscMessage theOscMessage) 
{  
  // get the first value as an integer
  float time = theOscMessage.get(0).floatValue();
  float freq = theOscMessage.get(1).floatValue();

  FREQ=freq;
  TIME=time;

  if(CTL){
    String [] control = {"seek "+(round(map(FREQ,MIN,MAX,10,90)*100.0)/100.0) +" 1"};

    saveStrings("ctl",control);
  }


  bang = true;
  //String thirdValue = theOscMessage.get(2).stringValue();

  // print out the message
  println(time + ": " + freq);
}
