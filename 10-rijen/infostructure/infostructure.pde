

ArrayList neurons;

int NUM = 200;
int NUMC = 5;
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
}

void draw(){

  background(255);

  for(int i = 0 ; i < neurons.size();i++){
    Neuron tmp = (Neuron)neurons.get(i);
    tmp.draw();
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
    stroke(0,c.weight*127/2.0);
      line(pos.x,pos.y,c.b.pos.x,c.b.pos.y);
    }
  }

}


class Connection{
  float weight;
  Neuron a,b;
  float d;

  Connection(Neuron _a, Neuron _b){
    a=_a;
    b=_b;
    d = dist(a.pos.x,a.pos.y,b.pos.x,b.pos.y);
    weight = random(0,2);
  }


}
