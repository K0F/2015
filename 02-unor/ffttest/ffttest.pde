import ddf.minim.*;

Minim minim;
AudioPlayer player;

int step = 24;
float fade = 0;
boolean render = false;


void setup()
{
  size(1280, 720, OPENGL);
 
  frameRate(60);

  minim = new Minim(this);
  player = minim.loadFile("/home/kof/recordings/marathon/export/marathon_session_2015-01-28.mp3",1024);
  player.play();

}

void draw()
{
  background(0);
  stroke(255,200);
  
  // draw the waveforms
  // the values returned by left.get() and right.get() will be between -1 and 1,
  // so we need to scale them up to see the waveform
  // note that if the file is MONO, left.get() and right.get() will return the same value
 /*
  for(int i = 0; i < player.bufferSize() - 1; i++)
  {
    float x1 = map( i, 0, player.bufferSize(), 0, width );
    float x2 = map( i+1, 0, player.bufferSize(), 0, width );
    line( x1, 50 + player.left.get(i)*50, x2, 50 + player.left.get(i+1)*50 );
    line( x1, 150 + player.right.get(i)*50, x2, 150 + player.right.get(i+1)*50 );
  }
*/
  for(int i = 0; i < player.bufferSize() - 1; i+=1){
    float val1 =  player.left.get(i);
    float val2 =  player.right.get(i);




      float sx1 = (width/2+((cos(i/1024.0*PI-HALF_PI))*300.0) * map(val1,-1,1,0.01,1.1)) ;
      float sy1 = (height/2+((sin(i/1024.0*PI-HALF_PI))*300.0) * map(val1,-1,1,0.01,1.1)) ;

      float sx2 = (width/2+((cos(i/1024.0*PI+HALF_PI))*300.0) * map(val2,-1,1,0.01,1.1)) ;
      float sy2 = (height/2+((sin(i/1024.0*PI+HALF_PI))*300.0) * map(val2,-1,1,0.01,1.1)) ;


        stroke(#ffcc00,200);
        line(sx1,sy1,sx1,sy1+1);
        stroke(#ccff00,200);
        line(sx2,sy2,sx2,sy2+1);
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




