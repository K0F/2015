
int width = 1600;
int height = 900;


ArrayList ents;

void setup(){
  size(1600,900);


  ents = new ArrayList();
  smooth();


  for(int i =0;i<100;i++)
    ents.add(new Ent(i));

  background(0);
}

void draw(){

  for(Object o:ents){
    Ent tmp = (Ent)o;
    tmp.compute();
    tmp.draw();

  }

}


class Ent{
  PVector pos,acc,vel;
  float rot;
  int index;
  float radi;

  Ent(int _index){
    index = _index;

    pos = new PVector(width/2.0,height/2.0);
    vel = new PVector(0,0);
    acc = new PVector(0,0);
  }


  void compute(){
    vel.mult(0.995);

    pos.add(vel);
    vel.add(acc);

    acc = new PVector(random(-1,1),random(-1,1));

    radi = noise(frameCount*index/1000.0) * 80;

    border();
  }

  void border(){
    if(pos.x>(width+radi/2.0))pos.x=(radi/2.0)*-1;
    if(pos.x<radi/2.0*-1)pos.x=(width+radi/2.0);
    if(pos.y>(height+radi/2.0))pos.y=radi/2.0*-1;
    if(pos.y<radi/2.0*-1)pos.y=height+radi/2.0;
  }

  void draw(){
    noStroke();
    fill(frameCount%2==0?255:0,200);
    ellipse(pos.x,pos.y,radi,radi);
  }

}
