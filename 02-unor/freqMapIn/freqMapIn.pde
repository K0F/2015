import ddf.minim.*;

Minim minim;
AudioInput in;

int step = 24;
float fade = 0;
boolean render = false;


void init(){

  frame.removeNotify();
  frame.setUndecorated(true);
  frame.addNotify();
  super.init();
}

void setup()
{
  size(800,900, OPENGL);

  frameRate(60);

  minim = new Minim(this);
  in = minim.getLineIn(Minim.STEREO, 2048);
  in.enableMonitoring();
  in.mute();
  background(0);
}

void draw()
{
  if(frameCount<5)
    frame.setLocation(0,0);

  background(0);
  noFill();

  // draw the waveforms
  // the values returned by left.get() and right.get() will be between -1 and 1,
  // so we need to scale them up to see the waveform
  // note that if the file is MONO, left.get() and right.get() will return the same value
  /*
     for(int i = 0; i < in.bufferSize() - 1; i++)
     {
     float x1 = map( i, 0, in.bufferSize(), 0, width );
     float x2 = map( i+1, 0, in.bufferSize(), 0, width );
     line( x1, 50 + in.left.get(i)*50, x2, 50 + in.left.get(i+1)*50 );
     line( x1, 150 + in.right.get(i)*50, x2, 150 + in.right.get(i+1)*50 );
     }
   */
  for(int i = 0; i < in.bufferSize() - 1; i+=3){
    float val1 =  in.left.get(i);
    float val2 =  in.right.get(i);



    /*
       float sx1 = (width/2+((cos(i/1024.0*PI-HALF_PI))*300.0) * map(val1,-1,1,-1.1,1.1)) ;
       float sy1 = (height/2+((sin(i/1024.0*PI-HALF_PI))*300.0) * map(val1,-1,1,-1.1,1.1)) ;

       float sx2 = (width/2+((cos(i/1024.0*PI+HALF_PI))*300.0) * map(val2,-1,1,-1.1,1.1)) ;
       float sy2 = (height/2+((sin(i/1024.0*PI+HALF_PI))*300.0) * map(val2,-1,1,-1.1,1.1)) ;
     */      
    float r1 = map(val1,-1,1,-30,30)+i/1.25;
    float r2 = map(val2,-1,1,-30,30)+i/1.25;

    pushMatrix();
    translate(width/4,height/4);
    scale(0.5);
    

    pushMatrix();
    translate(width/2-30,height-50);
    pushMatrix();
    rotate(radians(-45+10));
    stroke(255,60);
    arc(0,0,r1,r1,PI*3/2,TWO_PI);
    popMatrix();
    popMatrix();


    pushMatrix();
    translate(width/2+30,height-50);
    pushMatrix();
    rotate(radians(-45-10));
    stroke(255,60);
    arc(0,0,r2,r2,PI*3/2,TWO_PI);
    popMatrix();
    popMatrix();

    popMatrix();
  }

  if(fade<=100)
    fade += 1;

  if(frameCount>=3000-100)
    fade-=1;

  if(frameCount==3000)
    exit();

  if(render)
    saveFrame("/home/kof/render/bw/fr#####.png");
}




