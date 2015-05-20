

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
  chain.dream();
}


class Markov{
  int N;
  String filename;
  String [] raw;

  float percent;
  boolean done = false;

  String text = "T";

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
    String rraw = "";

    for(int i = 0 ; i < raw.length;i++){
      rraw += raw[i]+"\n";
    }

    for(int i = 0 ;i < rraw.length()-N;i++){
      String next = "";
      for(int ii = 1 ;ii <= N;ii++){
        next+=rraw.charAt(i+ii)+"";
      }
      chars.add(new Character(this,rraw.charAt(i),next,chars.size()-1));
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

  void dream(){
    try{
      int seek = 1;
      boolean hasF = false;
      char last = 'a';
      Character tmp = null;
      Following flw = null;

      while(!hasF || flw==null){
        last = text.charAt(text.length()-seek);
        tmp = getByChar(last);
        try{ 
          hasF = tmp.following!=null?true:false;
          flw = tmp.getProbableFollowing();
          hasF=true;
        }catch(Exception e){
          seek++;
        }

      }

      if(text.length()>10000){
        last = text.charAt(text.length()-1);
        text = last+"";
      }
      text += flw.txt;
    }catch(Exception e){;}
    text(text,20,20,width-40,height-40);

  }

  Character getByChar(char _c){
    Character tmp = null;
search:
    for(int i = 0 ; i < chars.size();i++){
      Character ch = (Character)chars.get(i);
      if(_c==ch.c){
        tmp = ch;
        break search;
      }
    }
    return tmp;
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
    boolean none = true;
check:
    for(int i = 0 ; i<parent.chars.size();i++){
      Character tmp = (Character)parent.chars.get(i);
      if(tmp!=this && tmp.c == c){
        none = false;
        if(debug)
          println("ok already got: "+c+" .. adding followings: "+next);
        tmp.addFollowing(next);
        parent.chars.remove(index);
        break check;
      }else{
        addFollowing(next);
      }
    }

  }

  void addFollowing(String _tmp){
    following.add(new Following(this,_tmp,following.size()-1));
  }

  Following getProbableFollowing(){
    if(following==null)
      return null;

    ArrayList options = new ArrayList();
    for(int i = 0 ; i < following.size();i++){
      Following fol = (Following)following.get(i);
      for(int ii = 0 ;ii<fol.count;ii++){
        options.add(fol);
      }
    }


    return (Following)options.get((int)random(0,following.size()));
  }

}

class Following{
  String txt = "";
  int count;
  int index = 1;
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
