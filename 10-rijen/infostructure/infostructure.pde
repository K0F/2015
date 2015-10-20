
ArrayList signals;
ArrayList neurons;

int NUM = 400;
int NUMC = 7;
int BORDER = 150;

void setup(){
  size(800,800,P2D);
  neurons = new ArrayList();

  for(int i = 0 ; i < NUM;i++){
    neurons.add(new Neuron(i,NUMC));
  }

  for(int i = 0 ; i < neurons.size();i++){
    Neuron tmp = (Neuron)neurons.get(i);
    tmp.makeConnections();
  }

  signals = new ArrayList();
  signals.add(new Signal(0));
}

void draw(){

  background(255);

  for(int i = 0 ; i < neurons.size();i++){
    Neuron tmp = (Neuron)neurons.get(i);
    tmp.draw();
  }

  for(int i = 0 ; i < signals.size();i++){
    Signal sig = (Signal)signals.get(i);
    sig.move();
    sig.draw();
  }
}


class Neuron{
  PVector pos;
  ArrayList connections;
  int numC;
  int id;

  Neuron(int _id,int _numC){
    id = _id;
    numC=_numC;
    pos = new PVector(random(BORDER,width-BORDER),random(BORDER,height-BORDER));
  }

  void makeConnections(){

    connections = new ArrayList();
    for(int i = 0 ; i < neurons.size() ; i++){
      int idx = i;
      if(idx!=neurons.indexOf(this)){
        boolean isConnected = false;
        Neuron other = (Neuron)neurons.get(idx);
        /*
check:
for(int ii = 0 ; ii < other.connections.size();ii++){
Connection cc = (Connection)other.connections.get(ii);
if(cc.b==this){
isConnected=true;
break check;
}
}
         */

if(!isConnected)
  connections.add(new Connection(this,(Neuron)neurons.get(idx)));
  }
}

connections = new ArrayList(getClosest(numC));
}

ArrayList getClosest(int _num){
  ArrayList sorted = new ArrayList();

  int idx = 0;
  for(int i = 0 ; i < _num;i++){
    float d = dist(0,0,width,height);
    Connection c = (Connection)connections.get(0);
    Connection shortest = c;
    for(int ii = 0 ; ii < connections.size() ; ii++){
      c = (Connection)connections.get(ii);
      if(c.d<d){
        d = c.d;
        shortest = c;
        idx = ii;
      }
    }
    sorted.add(shortest);
    connections.remove(idx);
  }

  return sorted;

}

void draw(){


  noStroke();
  fill(0);
  rectMode(CENTER);
  rect(pos.x,pos.y,3,3);

  for(int i = 0 ; i < connections.size();i++){
    Connection c  = (Connection)connections.get(i);
    c.draw();
  }
}

}


class Connection{
  float weight;
  boolean visited;
  Neuron a,b;
  float d;

  Connection(Neuron _a, Neuron _b){
    a=_a;
    b=_b;
    d = dist(a.pos.x,a.pos.y,b.pos.x,b.pos.y);
    weight = 0.2;
  }

  void draw(){
    if(visited)
      stroke(255,0,0,weight*127/2.0);
    else
      stroke(0,weight*127/2.0);
    line(a.pos.x,a.pos.y,b.pos.x,b.pos.y);

    if(weight>=1.9)
      weight=0.2;
  }
}

class Signal{
  Connection c;
  ArrayList route;
  PVector pos,origin,destination;
  float percent = 0;

  Signal(int start){
    Neuron n = (Neuron)neurons.get(start);
    c = (Connection)n.connections.get((int)random(n.connections.size()));//(Connection)n.connections.get(0);
    pos = new PVector(c.a.pos.x,c.a.pos.y);
    origin = new PVector(c.a.pos.x,c.a.pos.y);
    destination = new PVector(c.b.pos.x,c.b.pos.y);
    route = new ArrayList();
    route.add(c.a);
  }

  void move(){

    pos = new PVector(lerp(origin.x,destination.x,percent),lerp(origin.y,destination.y,percent));
    percent+=0.05;

    if(percent>=1.0){
      c.visited = true;
      c.weight+=0.1;
      if(random(100)<10)
        signals.add(new Signal(c.b.id));

      if(signals.size()>5000)
        signals.remove(0);

      percent=0.0;
      c=next();
      //route.add(c.a);
      origin = new PVector(c.a.pos.x,c.a.pos.y);
      destination = new PVector(c.b.pos.x,c.b.pos.y);


    }
  }

  void draw(){
    fill(255,0,0,30);
    noStroke();
    ellipse(pos.x,pos.y,10,10);
  }


  Connection next(){
    float w = 0;
    int choice = 0;
    for(int i = 0 ; i < c.b.connections.size();i++){
      Connection tmp = (Connection)c.b.connections.get(i);

      if(w<tmp.weight){
        w = tmp.weight;
        choice = i;
      }
    }

    return (Connection)c.b.connections.get(choice);
  }
}
