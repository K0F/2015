import ddf.minim.*;
import ddf.minim.ugens.*;
import processing.video.*;

Movie movie;

Minim minim;
MultiChannelBuffer buf;

AudioOutput output;
Sampler sampler;


float lpf[];
boolean buffer[][];

int BIT_DEPTH = 16;
int BUFFER_SIZE = 512;
int SPREAD = 4;

void setup(){

  size(1280/2,720/2);
  minim = new Minim(this);
  output = minim.getLineOut();

  movie = new Movie(this,"mov.mpeg");
  movie.play();

  buf = new MultiChannelBuffer(1,BUFFER_SIZE);
  lpf = new float[BUFFER_SIZE];
  buf.setBufferSize(BUFFER_SIZE);
  for(int i = 0 ; i < BUFFER_SIZE;i++){
    buf.setSample(0,i,0.0);
  }

  sampler = new Sampler(buf,44100,2);
  sampler.patch( output );
  sampler.looping = true;
  sampler.trigger();

  buffer = new boolean[BUFFER_SIZE][BIT_DEPTH];
  for(int x = 0;x<buffer.length;x++){
    for(int y = 0;y<BIT_DEPTH;y++){
      if(random(255)>127)
        buffer[x][y] = true;
    }
  }
}

void movieEvent(Movie _movie) {
  _movie.read();
}


void evolve(){
  loadPixels();
  for(int x = 0;x<buffer.length;x++){
    //float smpl = map((float)ToInt(buffer[x]),100000.0,-100000.0,-1,1);
    //lpf[x] += ((smpl+sin(x/((frameCount)%80+1.0)))/4.0-lpf[x])/2.0;
    //lpf[x] += (smpl-lpf[x])/200.0;
    //if(random(255)<(sin(frameCount/100.0)+1.0)*127 )
    //  buffer[x][y] = buffer[(x+(int)random(-SPREAD,SPREAD)+width)%(buffer.length)][(y+(int)random(-SPREAD,SPREAD)+16)%16];
    float s = brightness(pixels[(height/2)*width+(x%(buffer.length))]);
    buf.setSample(0,x,map(s,0,255,-1,1));
  }
}

void draw(){


  background(0);
  
  /*
  noFill();
  stroke(255);
  
  beginShape();
  for(int x = 0;x<buffer.length;x++){
    float bit = lpf[x]*200;//-((float)ToInt(buffer[x]))/1000.0;
    vertex(x,bit+height/3);
    for(int y = 0;y<BIT_DEPTH;y++){
      if(buffer[x][y])
        set(x,y+height-17,color(255));
    }
  }

  endShape();
*/
  image(movie,0,0,width,height);
  evolve();
  
}


int ToInt(boolean[] arr){
  int n = 0;
  for (boolean b : arr)
    n = (n << 1) | (b ? 1 : 0);
  return n;
}
