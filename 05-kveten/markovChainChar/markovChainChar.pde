

String filename = "source.txt";
int Nth = 2;

boolean debug = false;

Markov chain;

void setup(){

  size(800,870);
  chain = new Markov(filename,Nth);
  textFont(loadFont("SempliceRegular-8.vlw"));
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
    for(int i = 0 ; i < raw.length;i++){
      String line = raw[i];
      for(int ii = 0 ;ii < line.length()-N;ii++){
        String next = "";
        for(int iii = 1 ;iii <= N;iii++){
          next+=line.charAt(ii+iii)+"";
        }
        chars.add(new Character(this,line.charAt(ii),next,chars.size()-1));
      }
    }
  }

  void map(){
    int cnt = 0;
    for(int i = 0;i<chars.size();i++){
      Character tmp = (Character)chars.get(i);
      for(int ii = 0;ii<tmp.following.size();ii++){
        Following fol = (Following)tmp.following.get(ii);
        String name = fol.txt;
        int count = fol.count;
        if(ii==0)
          text(tmp.c+" -> "+name+" "+count+"x",20,(cnt)*12+20);
        else
          text("    "+name+" "+count+"x",20,(cnt)*12+20);
        cnt++;
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
        parent.chars.remove(index);
        break check;
      }
    }

    addFollowing(next);
  }

  void addFollowing(String _tmp){
    following.add(new Following(this,_tmp,following.size()-1));
  }
}

class Following{
  String txt = "";
  int count;
  int index;
  Character parent;

  Following(Character _parent,String _txt,int _index){
    txt = _txt;
    parent = _parent;
    index = _index;
    check();
  }

  void check(){
check:
    for(int i = 0;i<parent.following.size();i++){
      Following tmp = (Following)parent.following.get(i);
      if(tmp.txt.equals(txt) && tmp!=this){
        tmp.count++;
        parent.following.remove(index);
        break check;
      }
    }
  }
}
