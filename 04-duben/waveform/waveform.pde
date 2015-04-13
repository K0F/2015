import ddf.minim.*;

Minim minim;
AudioInput in;

int step = 24;
float fade = 0;
boolean render = false;

int bufs=800;

void init(){
  /*
     frame.removeNotify();
     frame.setUndecorated(true);
     frame.addNotify();
   */
  super.init();
}

ArrayList stack,hold;

void setup()
{
  size(800,240, OPENGL);

  noSmooth();
  frameRate(60);

  stack = new ArrayList();
  hold = new ArrayList();


  minim = new Minim(this);
  in = minim.getLineIn(Minim.STEREO, bufs);
  in.enableMonitoring();
  in.mute();
  background(0);
}


class Hold{
  ArrayList list;
  float alp,cnt;

  Hold(ArrayList _list){
  list = new ArrayList();
  for(int i = 0 ; i <_list.size();i++){
    list.add((PVector)_list.get(i));
  }
    alp = 250.0;
  }

  void draw(){
    stroke(255,alp);
    if(list.size()>1){
      beginShape();
      for(int i = 1; i < list.size() - 1; i++)
      {
        float x1 = map(i-1,0,list.size(),0,width);
        float x2 = map(i,0,list.size(),0,width);
        PVector tmp = (PVector)list.get(i);
        float y = (tmp.x+tmp.y)*100.0+height/2;
        vertex(x1,y,x2,y);
      }
      endShape();
    }


    if(cnt>60)
      alp-=(250/10.0);
    cnt++;

    if(alp<=0)
      hold.remove(this);
  }


}

void draw()
{
  if(frameCount<5)
    frame.setLocation(800,0);

  background(0);
  noFill();
  for(int i = 0; i < in.bufferSize() - 1; i++)
  {
  if(i%10==0)
    stack.add(new PVector(in.left.get(i),in.right.get(i)));

    if(stack.size()>bufs*4){
      hold.add(new Hold(stack));
      stack = new ArrayList();
    }
  }

  if(hold.size()>0)
    for(int i = 0;i<hold.size();i++){
      Hold tmp = (Hold)hold.get(i);
      tmp.draw();
    }
}




