
int NUM = 10;
ArrayList walkers;

void setup(){
  size(320,320);

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
  PVector pos;
  ArrayList history;
  int sel = 0;
  int mez = 2;

  Walker(){
    pos = new PVector(random(width),random(height));
    history = new ArrayList();
    history.add(pos);
  }

  void draw(){

    if(frameCount%mez==0){
      pos.add(new PVector(random(-1,1),random(-1,1)));
      history.add(new PVector(pos.x,pos.y));
    }

    PVector curr = (PVector)history.get(sel);
    stroke(255);
    point(curr.x,curr.y);
    sel++;
    sel=sel%history.size();
    
  }


}

