/*
Pentagraph by kof
Copyright (C) 2015 Krystof Pesek

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, see <http://www.gnu.org/licenses/>.


Coded by Kof @ 
Wed Jul 15 23:58:07 CEST 2015



   ,dPYb,                  ,dPYb,
   IP'`Yb                  IP'`Yb
   I8  8I                  I8  8I
   I8  8bgg,               I8  8'
   I8 dP" "8    ,ggggg,    I8 dP
   I8d8bggP"   dP"  "Y8ggg I8dP
   I8P' "Yb,  i8'    ,8I   I8P
  ,d8    `Yb,,d8,   ,d8'  ,d8b,_
  88P      Y8P"Y8888P"    PI8"8888
                           I8 `8,
                           I8  `8,
                           I8   8I
                           I8   8I
                           I8, ,8'
                            "Y8P'

*/

////////////////////////////////////////////////

Hero hero;

int num_leg = 5;
int num_seg = 10;
int seg_len = 75;

int tail_len = 250;

float ratio = 0.75;

float low = 20;
float high = 255;

float speed = 100.0;

////////////////////////////////////////////////

void setup(){
  size(1280,720,OPENGL);
  hero = new Hero();
}

void draw(){
  background(0);
  hero.draw();
}

////////////////////////////////////////////////

class Hero{

  ArrayList legs;
  PVector pos;

  Hero(){
    pos = new PVector(width/2,height/2);
    legs = new ArrayList();

    for(int i = 0 ; i < num_leg;i++)
      legs.add(new Leg(this,i));
  }

  void draw(){

 //   pos.x=mouseX;
 //   pos.y=mouseY;

//    pushMatrix();
//    translate(pos.x,pos.y);

    for(int i = 0;i<legs.size();i++){
      Leg l = (Leg)legs.get(i);
      l.draw();
    }

//    popMatrix();
  }
}
////////////////////////////////////////////////

class Leg{
  ArrayList segments;
  Hero parent;
  Segment root;
  int numSeg = num_seg;
  int id;

  Leg(Hero _parent,int _id){
    parent = _parent;
    id = _id;

    segments = new ArrayList();

    root = new Segment(this);
    segments.add(root);

    for(int i = 0 ; i < numSeg;i++){
      segments.add(new Segment(this,(Segment)segments.get(segments.size()-1),i+1));
    }
  }

  void draw(){
    for(int i = 0 ; i < segments.size();i++){
      Segment tmp = (Segment)segments.get(i);
      tmp.draw();
    }
  }


}
////////////////////////////////////////////////

class Segment{
  PVector pos;
  float absRot,rot,tarrot;
  float len;
  int id;
  boolean root;


  ArrayList trail;

  Segment parent;
  Leg leg;

  Segment(Leg _leg){
    leg = _leg;
    id = 0;
    root = true;
    parent = this;
    pos = new PVector(0,0);
    rot = 0;
    len = seg_len;
    trail = new ArrayList();
    tarrot = random(-TWO_PI,TWO_PI);
  }

  Segment(Leg _leg,Segment _parent,int _id){
    leg = _leg;
    id = _id;
    parent = _parent;
    pos = getPos();
    rot = 0;//random(-PI,PI);
    len = parent.len*ratio;

    tarrot = random(-TWO_PI,TWO_PI);
    trail = new ArrayList();
  }

  PVector getPos(){
    if(root)
      return new PVector(hero.pos.x,hero.pos.y);

    PVector ppos = new PVector(parent.pos.x+cos(parent.absRot)*parent.len,parent.pos.y+sin(parent.absRot)*parent.len);
    return ppos;
  }

  PVector endPos(){
    return new PVector(pos.x+cos(absRot)*len,pos.y+sin(absRot)*len);
  }

  void draw(){

    tarrot=(noise((leg.id*0.1+frameCount)/10.0,frameCount/(noise(frameCount/100.1)*1000.0)+(id*100.0+0.1))-0.5)*TWO_PI*2+(leg.id*(PI/(num_leg+0.0)));// = (noise(leg.id*100.0+id*100,frameCount/100.0+id*120,frameCount/100.0+id*1000.0)-0.5)*TWO_PI;

    if(root)
    tarrot+=frameCount/40.0;
    
    rot += (tarrot-rot)/40.0;
    

    //if(random(100)<5)

    pos = getPos();
    absRot = (parent.rot+rot);

/*
    fill(255,10);
    noStroke();
    pushMatrix();
    translate(pos.x,pos.y);
    rotate(absRot);
    rect(0,-2.5,len,5);
    popMatrix();
*/
    trail.add(endPos());

    if(trail.size()>tail_len)
      trail.remove(0);

    if(trail.size()>1)
      for(int i = 1 ; i < trail.size();i++){
        PVector p1 = (PVector)trail.get(i-1);
        PVector p2 = (PVector)trail.get(i);
    
        stroke(255,high/map(trail.size()-i,0,trail.size(),1,low));
        line(p1.x,p1.y,p2.x,p2.y);

        p1.x+=(p2.x-p1.x)/speed;
        p1.y+=(p2.y-p1.y)/speed;
 

        p1.x+=(width/2-p1.x)/speed;
        p1.y+=(height/2-p1.y)/speed;
      }
    noStroke();
  }
}
////////////////////////////////////////////////
