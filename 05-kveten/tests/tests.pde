
ArrayList obj;
PVector center;

void setup(){

  size(320,240,P2D);

  center = new PVector(0,0);
  obj = new ArrayList();

  for(int i = 0; i < 10;i++)
    obj.add(new Obj());

}




void draw(){
  background(0);

  center= new PVector(0,0);
  for(Object o:obj){
    Obj tmp = (Obj)o;
    center.add(new PVector(tmp.pos.x,tmp.pos.y));
  }

  center.mult(1/(obj.size()+0.0));

  pushMatrix();
  translate(-center.x+160,-center.y+120);
  for(Object o:obj){
    Obj tmp = (Obj)o;
    tmp.draw();
  }

  popMatrix();
}

class Obj{
  PVector pos,vel,acc;
  float friction = 0.99;
  float radius = 100;
  ArrayList trail;

  Obj(){
    pos = new PVector(random(320),random(240));
    vel = new PVector(0,0);
    acc = new PVector(0,0);
    trail = new ArrayList();
  }

  void interact(){
    pos.add(vel);
    vel.add(acc);
    vel.mult(friction);
    acc.mult(0.0);

    for(Object o:obj){
      Obj tmp = (Obj)o;
      if(tmp!=this){
        float d = dist(tmp.pos.x,tmp.pos.y,pos.x,pos.y);
        if(d>radius){

          acc.add(new PVector((tmp.pos.x-pos.x)/d,(tmp.pos.y-pos.y)/d));
        }else{
          acc.sub(new PVector((tmp.pos.x-pos.x)/d,(tmp.pos.y-pos.y)/d));

        }
        acc.normalize();
      }
    }
  }

  void trailing(){
    trail.add(new PVector(pos.x,pos.y));

    if(trail.size()>100)
      trail.remove(0);
    noFill();
    int cnt=0;
    beginShape();
    for(Object o:trail){
      stroke(255,map(cnt,0,trail.size(),0,25));
      PVector tmp = (PVector)o;
      curveVertex(tmp.x,tmp.y);
      cnt++;
    }
    endShape();
  }

  void draw(){
    interact();
    trailing();
    ellipse(pos.x,pos.y,10,10);
  }

}
