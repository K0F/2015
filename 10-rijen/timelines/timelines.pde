import java.util.Collections;

ArrayList items;
String names[] = {"alfa","beta","gamma","delta","epsilon","pi"};
boolean md = false;
int last = 0;

void setup(){
  size(800,600,P2D);

  items = new ArrayList();

  for(int i = 0 ; i < names.length;i++)
    items.add(new Item(names[i]));

  textFont(createFont("Semplice Regular",6,false));
}

void draw(){
  background(127);

  Collections.sort(items);

  fill(255);

  for(int i = 0 ; i < items.size();i++){
    Item tmp = (Item)items.get(i);
    tmp.draw();
  }
}


class Item implements Comparable{

  int id;
  int x,y,w,h,ox,oy;
  PGraphics skin;
  PImage assets[];
  String name;
  Connection con;

  Item(String _name){
    name = _name;
    id = items.size();
    x = (int)random(width);
    y = (int)random(height);

    w = (int)textWidth(name)+32+16;
    h = 16;

    ox = 0;
    oy = 0;

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
    skin.stroke(255);
    skin.line(0,0,w-16,0);
    skin.line(0,h-1,w-16,h-1);
    skin.endDraw();
  }

  void draw(){
    if(!md){
      id = items.indexOf(this);
      attract();
    }


    if(last==id && md){
      x = mouseX-ox;
      y = mouseY-oy;
    }else{
      if(over()){
        noTint();
      }else{
        tint(255,150);
      }
    }


    image(skin,x,y);
    fill(255);
    text(name+id,x+2,y+10);
  }

  void attract(){
    try{
      Item other = (Item)items.get(items.indexOf(this)-1);
      x += ((other.x+w-16)-x)/10.0;
      y += (other.y-y)/10.0;

    }
    catch(Exception e)
    {;}
  }

  int compareTo(Object o){
    Item other = (Item)o;
    return (x>=other.x?1:-1);
  }

  boolean over(){
    if(mouseX>x&&mouseX<x+w&&mouseY>y&&mouseY<y+h && !md){
      ox = mouseX-x;
      oy = mouseY-y;
      last = id;
      return true;

    }else{
      return false;
    }
  }

}

class Connection{
  Item A,B;

  Connection(Item _A,Item _B){
    A=_A;
    B=_B;
  }
}


void mousePressed(){
  md = true;
}

void mouseReleased(){
  md = false;
}
