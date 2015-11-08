

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



void mouseDragged(){
  for(int i = 0 ; i < envelopes.size();i++){
    Envelope en  =(Envelope)envelopes.get(i);
    if(en.over){
      en.recording = true;
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

  boolean over();

  ArrayList connections;
  


  Envelope(){
    vals = new ArrayList();

    pos = new PVector(0,height-200);
    dim = new PVector(200,100);

    pointer = 0;
    println("casting envelope: "+ name);

    connections = new ArrayList();
  }

  void record(){
    if(recording)
      vals.add(map(mouseY,pos.y,pos.y+dim.y,1,0));

  }

  
  void over(){
    if(mouseX>pos.x&&mouseX<pos.x+dim.x&&mouseY>pos.y&&mouseY<pos.y+dim.y)
    return true;
    else
    return false;

  }


  void draw(){
    
    over = over();

    record();

/*
    vals.add(noise((frameCount+(editors.indexOf(parent)*1000.0))/(100.0*(ctlId+1.0))) );

    if(vals.size()>200)
      vals.remove(0);
*/

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
