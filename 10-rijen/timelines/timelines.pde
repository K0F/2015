

ArrayList items;
int NUM = 10;
String names[] = {"alfa","beta","gamma","delta","epsilon","pi"};

void setup(){
  size(800,600,P2D);

  items = new ArrayList();

  for(int i = 0 ; i < names.length;i++)
    items.add(new Item(names[i]));

  textFont(createFont("Semplice Regular",8,false));
}

void draw(){
  background(127);

  fill(255);

  for(int i = 0 ; i < items.size();i++){
    Item tmp = (Item)items.get(i);
    tmp.draw();

  }
}


class Item{
  int id;
  int x,y,w,h;
  PGraphics skin;
  PImage assets[];
  String name;

  Item(String _name){
    name = _name;
    id = items.size();
    x = (int)random(width);
    y = (int)random(height);

    w = (int)textWidth(name)+32+16;
    h = 16;

    assets = new PImage[2];
    assets[1] = loadImage("arrow.png");
    assets[0] = loadImage("arrowL.png");

    renderSkin();

  }

  void renderSkin(){
    skin = createGraphics(w,h,JAVA2D);
    skin.beginDraw();
    skin.fill(0);
    skin.noStroke();
    skin.rect(16,0,w-32,h);
    skin.image(assets[0],0,0);
    skin.image(assets[1],w-16,0);
    skin.fill(255);
    skin.text(name,16,12);
    skin.stroke(255);
    skin.line(0,0,w-16,0);
    skin.line(0,h-1,w-16,h-1);
    skin.endDraw();
  }

  void draw(){
    image(skin,x,y);
    //text(name,x,y);   
  }

}
