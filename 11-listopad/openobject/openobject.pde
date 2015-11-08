


import oscP5.*;
import netP5.*;


OscP5 osc;
NetAddress sc;

Boid boid;

void setup(){

  size(320,240,P2D);

  boid = new Boid("mat");

  rectMode(CENTER);

  osc = new OscP5(this,12000);
  sc = new NetAddress("127.0.0.1",57120);
  msg("test","amp",0.5);  
}

float vals[];

void draw(){
  background(255);

  vals = new float[20];
  for(int i = 0 ; i < vals.length ; i++)
  vals[i] = noise(frameCount/100.0/(i+1.0))*1000;

  boid.draw();

}

void msg(String obj,String key,float val){
  osc.send("/oo",new Object[] {obj,"set",key,val},sc);
}

void msg(Object [] data){
  osc.send("/oo",data,sc);
}

void stop(){
  super.stop();
}

class Boid{
  PVector pos,acc,vel;
  String ctl;
  ArrayList history;
  int rew =0;
  float speed = 10.0;

  Boid(String _ctl){
    ctl = _ctl;
    pos = new PVector(width/2,height/2);
    acc  =new PVector(0,0);
    vel = new PVector(0,0);
    history=new ArrayList();
  }

  void draw(){
    move(); 
    fill(0);
    noStroke();
    rect(pos.x,pos.y,5,5);

    rew+=speed;
    rew=rew%history.size();
    PVector tmp = (PVector)history.get(rew);
    rect(tmp.x,tmp.y,3,3);
    
    msg(ctl,"phase",map(tmp.x,0,width,-PI,PI));
    msg(ctl,"amp",map(tmp.y,0,height,1,0.01));

    beginShape();
    stroke(0);
    noFill();
    for(int i = 0;i<history.size();i++){
      PVector curr = (PVector)history.get(i);
      vertex(curr.x,curr.y);
    }
    endShape();

  }

  void move(){
    acc.mult(0.9);
    vel.mult(0.9);
    pos.add(vel);
    vel.add(acc);
    acc.add(new PVector(random(-0.1,0.1),random(-0.1,0.1)));
    pos.x=constrain(pos.x,1,width);
    pos.y=constrain(pos.y,1,height);

    history.add(new PVector(pos.x,pos.y));
    if(history.size()>1000)
      history.remove(0);
  }

}
