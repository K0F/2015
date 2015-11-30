
boolean debug = true;
Network net;

void setup(){

  size(800,800);
  net  = new Network("short.txt");
  textFont(createFont("Semplice Regular",8,false));
}



void draw(){
  background(127);
  net.draw();
}


class Reader{
  Network parent;
  Node target;
  String history;
  ArrayList memory;
  float speed = 3.3;
  PVector pos;

  Reader(Network _parent){
    parent = _parent;
    history="";
    memory = new ArrayList();
    target=(Node)parent.nodes.get((int)random(parent.nodes.size()));
    pos = new PVector(0,0);
  }

  void getNext(){
    history+=""+target.name;
    memory.add(target);
    try{
    target=target.getNext();
    }catch(Exception e){;}
  }

  void draw(){
    
    pushMatrix();
        pos.add(new PVector((target.pos.x-pos.x)/speed,(target.pos.y-pos.y)/speed));
    if(dist(target.pos.x,target.pos.y,pos.x,pos.y)<2){
      getNext();
    }

    translate(width/2,height/2);
    fill(255);
    text(history,20,20,width-60,height-60);

beginShape();
    stroke(255,25);
    noFill();
    for(int i = 0 ; i<memory.size();i++){
      Node m = (Node)memory.get(i);
      vertex(m.pos.x,m.pos.y);
    }
    endShape();


    if(history.length()>100){
    history = history.substring(1,history.length());
    memory.remove(0);
    }
    
rectMode(CENTER);
    rect(pos.x,pos.y,3,3);

  popMatrix();
  }

}

//////////////////////////////////

class Network{
  ArrayList words,nodes,connections;
  String filename;
  Reader reader;

  Network(String _filename){
    filename = _filename;
    words = new ArrayList();
    nodes = new ArrayList();
    connections = new ArrayList();
    String tmp[] = loadStrings(filename);

    analyze(tmp);
    castNodes();
    makeConnections();

    reader = new Reader(this);
  }

  void analyze(String [] _tmp){
    for(int i = 0 ; i < _tmp.length;i++){
      words.add(new Word(_tmp[i]));
    }


  }

  void castNodes(){

    for(int i = 0 ; i < words.size();i++){
      Word w = (Word)words.get(i);

      boolean has = false;
      String cc = "";
      int last = 0;

check:
      for(int ii=0;ii<w.word.length();ii++){

        cc = w.word.charAt(ii)+"";        

        for(int iii = 0 ; iii < nodes.size();iii++){
          Node n = (Node)nodes.get(iii);

          if((cc).equals(n.name)){
            has = true;
            break check;
          }
        }
      }

      if(!has)
        nodes.add(new Node(cc,this));
    }
  }

  void makeConnections(){
    for(int i = 0 ; i < words.size();i++){
      Word w = (Word)words.get(i);
      for(int ii = 1 ; ii < w.word.length();ii++){
        Node a = getNodeByName(w.word.charAt(ii-1)+"");
        Node b = getNodeByName(w.word.charAt(ii)+"");
        connections.add(new Connection(a,b,this));
        if(a!=null&&b!=null)
        a.addConnection(b);
      }
    } 
  }

  Node getNodeByName(String _input){

    Node result = null;

search:
    for(int i = 0 ; i < nodes.size();i++){
      Node n = (Node)nodes.get(i);
      if(n.name.equals(_input)){
        result = n;
        break search;

      }

    }
    return result;

  }



  void draw(){
    float x,y;
    x=y=0;
    /*
       for(int i = 0 ; i < words.size();i++){
       Word w = (Word)words.get(i);
       pushMatrix();

       translate(x,y);
       w.draw();
       popMatrix();


       x = w.binary.length()+5;


       if(x>=width){
       x=0;
       y+=5;
       }
       }
     */
    for(int i = 0 ; i < nodes.size();i++){
      Node n = (Node)nodes.get(i);
      n.draw();
    }
/*
    for(int i = 0 ; i < connections.size();i++){
      Connection c = (Connection)connections.get(i);
      c.draw();
    }
*/
    reader.draw();
  }
}

//////////////////////////////////

class Node{
  String name;
  float val;
  ArrayList connections;
  PVector pos;
  Network parent;

  Node(String _c,Network _parent){
    name = _c+"";
    parent = _parent;

    connections = new ArrayList();

    pos = new PVector(random(-200,200),random(-200,200));
  }

  Node getNext(){
    float [] ratios = new float[connections.size()];
    float sum =0;
    for(int i = 0 ; i< connections.size();i++){
      Connection c = (Connection)connections.get(i);
      ratios[i] = c.num;
      sum+=c.num;
    }
    for(int i = 0 ; i<ratios.length;i++){
      if(ratios[i]>random(sum)){
        Connection _b = (Connection)connections.get(i);
        return _b.b;

        }
    }
    

    Connection _b = (Connection)connections.get((int)random(connections.size()));
    return _b.b;
  }

  void addConnection(Node b){
    if(b!=null)
    connections.add(new Connection(this,b,parent));
  }

  void draw(){
    fill(255);
    pushMatrix();
    translate(width/2,height/2);
    text(name,pos.x,pos.y);
    popMatrix();

  }

}

class Connection{
  Node a,b;
  Network parent;
  int num = 1;

  Connection(Node _a,Node _b,Network _parent){

    parent = _parent;
    a=_a;
    b=_b;

    for(int i = 0 ; i < parent.connections.size();i++){
      Connection cc = (Connection)parent.connections.get(i);
      if(cc.a==a&&cc.b==b){
      cc.num++;
      parent.connections.remove(this);
      }
    }

  }

  void draw(){
    pushMatrix();
    translate(width/2,height/2);
    stroke(255,num/255.0);
    if(a!=null&&b!=null)
      line(a.pos.x,a.pos.y,b.pos.x,b.pos.y);

    popMatrix();
  }
}


/////////////////////////////////

class Word{
  String word;
  boolean [] hash;
  String binary;

  Word(String _text){
    word = _text;
    hash = toBinary(_text);
    //println(hash);
  }

  void draw(){
    //text(word,0,0);

    for(int i = 0 ; i< hash.length ; i++){
      stroke(hash[i]?255:0);
      line(i,0,i,5);
    }
  }

  boolean [] toBinary(String _text){
    ArrayList binar = new ArrayList();
    int cnt = 0;

    for(int i = 0 ; i < _text.length();i++){
      String temp = binary(_text.charAt(i));
      binar.add(temp);
      cnt+=temp.length();
    }

    boolean result[] = new boolean[cnt];
    binary = "";

    for(int i = 0 ; i < binar.size(); i++){
      String ch = (String)binar.get(i);
      for(int ii = 0 ; ii<ch.length() ; ii++){
        String ttmp = ch.charAt(ii)+"";
        result[ii] = ttmp.equals("1")?true:false;
        binary += ttmp;
      }
    }
    return result;
  }
}
