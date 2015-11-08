

/*
   void mousePressed(){
   editors.add(new Editor("syn"+editors.size(),mouseX,mouseY));
   currEdit = editors.size()-1;
   }

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



void mousePressed(){
  for(int i = 0 ; i < envelopes.size();i++){
    Envelope en  =(Envelope)envelopes.get(i);
    if(en.over){
      en.recording = true;
      en.vals = new ArrayList();
    }
  }
}

void mouseReleased(){
  for(int i = 0 ; i < envelopes.size();i++){
    Envelope en  =(Envelope)envelopes.get(i);
    en.recording = false;
  }
}

class Envelope{

  ArrayList vals;
  int pointer = 0;
  String name;
  PVector pos;
  int ctlId;
  float output;

  boolean recorded;
  boolean recording;

  PVector dim;

  boolean over;

  ArrayList connections;

  Envelope(float _x,float _y){
    vals = new ArrayList();

    pos = new PVector(_x,_y);
    dim = new PVector(200,75);

    pointer = 0;
    println("casting envelope: "+ name);

    connections = new ArrayList();
  }

  void record(){
    if(recording)
      vals.add(constrain(map(mouseY,pos.y,pos.y+dim.y,0,1),0.001,1));

  }

  boolean over(){
    if(mouseX>pos.x&&mouseX<pos.x+dim.x&&mouseY>pos.y&&mouseY<pos.y+dim.y)
      return true;
    else
      return false;
  }


  void draw(){

    over = over();

    record();

    fill(25);
    stroke(255);
    rect(pos.x,pos.y,dim.x,dim.y);

    if(vals.size()>0){
      /*
         vals.add(noise((frameCount+(editors.indexOf(parent)*1000.0))/(100.0*(ctlId+1.0))) );
       */

      if(!recording){
        float first = (Float)vals.get(0);
        vals.remove(0);
        vals.add(first);
      }

      pushMatrix();
      translate(pos.x,pos.y);
      noFill();
      stroke(255);
      beginShape();
      for(int i = 0 ; i< vals.size();i++){
        Float tmp = (Float)vals.get(i);
        vertex(map(i,0,vals.size(),0,dim.x),tmp*dim.y);
      }
      endShape();
      
      output = 1.0-(Float)vals.get(vals.size()-1)+0.001;
      fill(output*255);
      rect(0,dim.y,10,10);
      popMatrix();

    }
  }
}
