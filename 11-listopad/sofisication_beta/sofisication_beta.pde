
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


//////////////////////////////////

class Network{
  ArrayList words,nodes;
  String filename;

  Network(String _filename){
    filename = _filename;
    words = new ArrayList();
    nodes = new ArrayList();
    String tmp[] = loadStrings(filename);

    analyze(tmp);
  }

  void analyze(String [] _tmp){
    for(int i = 0 ; i < _tmp.length;i++){
      words.add(new Word(_tmp[i]));

      for(int ii = 0 ; ii < _tmp[i].length();ii++){
        
       boolean has = false;
          String cc = "";
       check:
        for(int iii=0;iii<nodes.size();iii++){
          Node ctmp = (Node)nodes.get(iii);
          cc = ctmp.name;

          if(!(_tmp[i].charAt(ii)+"").equals(cc)){
          has = true;
          break check;
          }
        }
        if(!has)
            nodes.add(new Node(cc));
      }
    }
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
  fill(255);
  for(int i = 0 ; i < nodes.size();i++){
    Node n = (Node)nodes.get(i);
    text(n.name,10,i*10);
  }
  }
}

//////////////////////////////////

class Node{
  String name;
  float val;
  ArrayList conn;

  Node(String _c){
    name = _c;
  }

}

class Connection{
  Node a,b;

  Connection(Node _a,Node _b){
    a=_a;
    b=_b;
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
