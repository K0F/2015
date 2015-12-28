
int NUM = 10000;
ArrayList walkers;

void setup(){
  size(1280,720,P2D);

  walkers = new ArrayList();

  for(int i = 0 ; i < NUM; i++)
  walkers.add(new Walker());
}



void draw(){

  background(0);

  for(int i = 0 ; i < walkers.size();i++){
  Walker walker = (Walker)walkers.get(i);
  walker.draw();
}
      

}

class Walker{
  PVector pos,vel,acc;
  ArrayList history;
  int sel = 0;
  int mez = 10;

  Walker(){
    pos = new PVector(width/2,height/2);
    vel = new PVector(0,0);
    acc = new PVector(0,0);
    history = new ArrayList();
    history.add(pos);
  }

  void draw(){

    if(frameCount%mez==0){
      acc.add(new PVector(random(-3,3)/10.0,random(-3,3)/10.0 ));
      history.add(new PVector(pos.x,pos.y));
    }

    acc.mult(0.1);
    pos.add(vel);
    vel.add(acc);

    float d = dist(pos.x,pos.y,width/2,height/2);
    if(d>200){
    //pos.x=width/2;
    //pos.y=height/2;
    vel=new PVector(-vel.x,-vel.y);
    }

    PVector curr = (PVector)history.get(sel);
    stroke(255,55);
    point(curr.x,curr.y);
    sel++;
    sel=sel%history.size();
    
  }


}

