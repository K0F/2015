

String filename = "source.txt";
int Nth = 2;

boolean debug = true;

Markov chain;

void setup(){

  size(320,240);
  chain = new Markov(filename,Nth);

  textFont(createFont("Inconsolata",9,true));
}

void draw(){
  background(0);
  fill(255);
  chain.map();
}


class Markov{
  int N;
  String filename;
  String [] raw;

  float percent;
  boolean done = false;

  ArrayList chars;

  Markov(String _filename,int _N){
    N = _N;
    filename = _filename;
    raw = loadStrings(filename);

    percent = 0.0;
    castChars();
  }

  void castChars(){
    chars = new ArrayList();
    int count = 0;
    for(int i = 0 ; i < raw.length;i++){
      String line = raw[i];
      for(int ii = 0 ;ii < line.length()-N;ii++){
        String next = "";
        for(int iii = 1 ;iii <= N;iii++){
          next+=line.charAt(ii+iii)+"";
        }
        chars.add(new Character(this,line.charAt(ii),next,count));
        count++;
      }
    }
  }

  void map(){
    for(int i = 0;i<chars.size();i++){
      Character tmp = (Character)chars.get(i);
      for(int ii = 0;ii<tmp.following.size();ii++){
        String fol = (String)tmp.following.get(ii);
        if(ii==0)
          text(tmp.c+" -> "+fol,20,(i+ii)*12+20);
        else
          text("    "+fol,20,(i+ii)*12+20);

      }
    }
  }
}

class Character{
  char c;
  int index;
  ArrayList following;
  Markov parent;
  String next;

  Character(Markov _parent,char _c,String _next,int _index){
    c = _c;
    index = _index;
    next = _next;
    parent = _parent;

    following = new ArrayList();

    checkIfExists();
  }

  void checkIfExists(){
    boolean none = false;
check:
    for(int i = 0 ; i<parent.chars.size();i++){
      Character tmp = (Character)parent.chars.get(i);
      if(tmp!=this && tmp.c == c){
        if(debug)
          println("ok already got: "+c+" .. adding followings: "+next);
        tmp.addFollowing(next);
        parent.chars.remove(this);
        break check;
      }
    }

    addFollowing(next);
  }

  void addFollowing(String _tmp){
    following.add(_tmp);
  }
}
