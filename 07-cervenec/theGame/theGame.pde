

Hero hero;

int num_leg = 6;
int num_seg = 7;
int seg_len = 75;

void setup(){
  size(600,400,OPENGL);
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
    pushMatrix();
    translate(pos.x,pos.y);

    for(int i = 0;i<legs.size();i++){
      Leg l = (Leg)legs.get(i);
      l.draw();
    }

    popMatrix();
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
    len = parent.len*0.75;

    tarrot = random(-TWO_PI,TWO_PI);
    trail = new ArrayList();
  }

  PVector getPos(){
    if(root)
      return new PVector(0,0);

    PVector ppos = new PVector(parent.pos.x+cos(parent.absRot)*parent.len,parent.pos.y+sin(parent.absRot)*parent.len);
    return ppos;
  }

  PVector endPos(){
    return new PVector(pos.x+cos(absRot)*len,pos.y+sin(absRot)*len);
  }

  void draw(){
    tarrot=(noise(frameCount/100.0+(id*10.0+0.1))-0.5)*TWO_PI+(leg.id*(PI/(num_leg+0.0)));// = (noise(leg.id*100.0+id*100,frameCount/100.0+id*120,frameCount/100.0+id*1000.0)-0.5)*TWO_PI;
    rot += (tarrot-rot)/40.0;

    //if(random(100)<5)

    pos = getPos();
    absRot = (parent.rot+rot);

    fill(255,100);
    noStroke();
    pushMatrix();
    translate(pos.x,pos.y);
    rotate(absRot);
    rect(0,-2.5,len,5);
    popMatrix();

    trail.add(endPos());

    if(trail.size()>100)
      trail.remove(0);

    stroke(255,30);
    if(trail.size()>1)
      for(int i = 1 ; i < trail.size();i++){
        PVector p1 = (PVector)trail.get(i-1);
        PVector p2 = (PVector)trail.get(i);
        line(p1.x,p1.y,p2.x,p2.y);
      }
    noStroke();
  }
}
////////////////////////////////////////////////
