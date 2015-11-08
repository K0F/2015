

void mousePressed(){
  editors.add(new Editor("syn"+editors.size(),mouseX,mouseY));
  currEdit = editors.size()-1;
}
/*

void mouseDragged(){
  println("starting recording of envelope");
  Editor tmp = (Editor)editors.get(currEdit);
  Envelope tenv = (Envelope)tmp.envelopes.get(tmp.envelopes.size()-1);
  tenv.recording = true;
}

void mouseReleased(){
  Editor tmp = (Editor)editors.get(currEdit);
  Envelope tenv = (Envelope)tmp.envelopes.get(tmp.envelopes.size()-1);

  try{
    tenv.recording = false;
    tenv.recorded = true;

  }catch(Exception e){
    println("envelope creation err");
  }
}


*/

class Envelope{

  Editor parent;
  ArrayList vals;
  int pointer = 0;
  String name;
  PVector pos;
  int ctlId;
  float output;

  boolean recorded;
  boolean recording;


  Envelope(Editor _parent,String _name,int _ctlId){
    parent = _parent;
    vals = new ArrayList();
    ctlId = _ctlId;
    name = _name;


    pointer = 0;
    pos = new PVector(0,height-200);
    println("casting envelope: "+ name);
  }



  void draw(){

    
    vals.add(noise((frameCount+(editors.indexOf(parent)*1000.0))/(100.0*(ctlId+1.0))) );

    if(vals.size()>200)
      vals.remove(0);

    noFill();
    stroke(255,127);
    beginShape();
    for(int i = 0 ; i< vals.size();i++){
      Float tmp = (Float)vals.get(i);
      vertex(i+parent.maxW+20,(tmp*12)+12*(ctlId+1)-36);
    }
    endShape();

    pointer++;
    pointer=pointer%vals.size();

    output = (Float)vals.get(pointer);
    fill(255);
    noStroke();
  }


}
