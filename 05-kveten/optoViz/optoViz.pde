import ddf.minim.*;
import ddf.minim.analysis.*;

OptoVizer opto;
////////////////////////
int width = 768;
int height = 1024;

////////////////////////
void setup()
{
  size(768,1024,P2D);

  frameRate(100);

  opto = new OptoVizer(this);


}

void draw(){
  background(0);
  stroke(255);
  opto.phase(1);
}

///////////////////////////////////////////////

class OptoVizer{

  Minim minim;
  FFT fftLog;

  AudioInput input;

  PApplet parent;
  int phase;

  float SCALE = 30.0;

  float slope = 0;
  float sslope = 0;
  float samp = 0;
  ArrayList amps;

  OptoVizer(PApplet _parent){
    
    // papplet
    parent= _parent;
    
    // sound system
    minim = new Minim(parent);
    input = minim.getLineIn(Minim.STEREO,1024);
    
    // fft
    fftLog = new FFT(input.bufferSize(), input.sampleRate());
    fftLog.logAverages(22, 3);
    
    // vals
    amps = new ArrayList();
  }

  void phase(int _phase){
    switch(_phase){
      case 1:
        one();
        break;
      default:
        voids();
    }
  }

  void voids(){;}

  void one(){
    compute();
    plotOne();
  }

  void plotOne(){
    pushMatrix();
    translate(width/2,0);
    int cnt = 0;
    for(Object o:amps){
      pushMatrix();
      translate(0,cnt);
      float val = (Float)o;
      line(-val,0,val,0);
      popMatrix();
      cnt++;
    }
    popMatrix();
  }

  void compute(){
    float levels[] = averages();
    slope = 0;
    for(int i = 0; i < input.bufferSize() - 1; i++)
    {
      float base = (input.left.get(i) + input.right.get(i))/2.0;
      float amp = map(base,levels[0],levels[1],0,SCALE);

      if(amps.size()>0)
        slope += abs((Float)amps.get(amps.size()-1)-amp);

      amps.add(amp);



      if(amps.size()>height){
        amps.remove(0);
      }
    }
    slope /= (float)input.bufferSize();
    sslope += (slope - sslope) / 10.0;
  }

  float averages()[]{
    float [] avg = new float[2];
    for(int i = 0; i < input.bufferSize() - 1; i++)
    {
      float base = (input.left.get(i) + input.right.get(i))/2.0;
      avg[0] = min(base,avg[0]);
      avg[1] = max(base,avg[1]);
    }
    return avg;
  }
}
