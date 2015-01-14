
/////////////////////////////////////////////
/// 2048 game autosolver test ///////////////
///////////////////////////// by kof 15 /////
/// feel free to modify /////////////////////
/////////////////////////////////////////////

Deck deck;

void setup(){
  size(600,600);
  deck = new Deck();
  deck.addStones();
}

void draw(){
  background(127);
  deck.plot();

}


/////////////////////////////////////////////
class Deck{
  float div;
  ArrayList stones;
  boolean matrix[][];

  Deck(){
    div = width/4;

    matrix = new boolean[4][4];
    for(int y = 0 ; y < matrix.length ; y++){
      for(int x = 0 ; x < matrix[y].length ; x++){
        matrix[x][y] = false;
      }
    }
  }

  void addStones(){

    stones = new ArrayList();

    stones.add(new Stone());
    stones.add(new Stone());


  }

  void plot(){
    for(int y = 0 ; y < matrix.length ; y++){
      for(int x = 0 ; x < matrix[y].length ; x++){
        fill(255);
        rect(x*div+2,y*div+2,div-4,div-4);
      }
    }

    for(int i = 0 ; i < stones.size();i++){
      Stone tmp = (Stone)stones.get(i);
      tmp.render();
    }
  }
}

class Stone{
  int val;
  PVector pos;
  color c;

  Stone(){
    val = ceil(random(2,4));
    pos = new PVector(random(0,3),random(0,3));

    deck.matrix[ceil(pos.x)][ceil(pos.y)] = true;

    if(deck.stones.size()>0){
      while(deck.matrix[ceil(pos.x)][ceil(pos.y)])
        pos = new PVector(random(0,3),random(0,3));

      deck.matrix[ceil(pos.x)][ceil(pos.y)] = true;
    }
  }

  void render(){

    fill(#ffcc00);
    rect(pos.x+2,pos.y+2,deck.div-4,deck.div-4);   
  }





}
