


ArrayList boxes;

void settings(){
  size(320,240,P3D);

  boxes = new ArrayList();
  boxes.add(new Box("box.obj"));
} 


void draw(){
  background(255);

  for(Object o:boxes){
    Box tmp = (Box)o;
    tmp.draw();
  }

}




class Box extends Thing{
  Box(String _fn){
    super(_fn);
  }
}


class Thing{
  PVector pos;
  PVector rot;
  PShape model;

  String filename;

  Thing(String _filename){
    filename = _filename+"";

    pos = new PVector(0,0,0);
    rot = new PVector(0,0,0);

    println(filename);
    try{
      model = loadShape(filename);
    }catch(Exception e){
      println(e);
    }
  }


  void draw(){


  }
}
