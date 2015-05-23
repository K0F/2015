

import ddf.minim.*;
import ddf.minim.analysis.*;
///////////////////////////////////////////////

class OptoVizer{

  Minim minim;
  FFT fftLog;

  AudioInput input;

  PApplet parent;
  int phase;

  float SCALE = 150.0;
  float SCALAR = 30000.0;

  float slope = 0;
  float sslope = 0;
  float samp = 0;

  ArrayList amps;
  ArrayList scales;

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

    //SCALE += ((sslope*SCALAR)-SCALE)/2.0;

    float levels[] = averages();
    slope = 0;

    for(int i = 0; i < input.bufferSize() - 1; i++){
      float base = (input.left.get(i) + input.right.get(i))/2.0;
      float amp = map(base,levels[0],levels[1],0,SCALE);

      amps.add(amp);

      if(amps.size()>height){
        amps.remove(0);
      }
    }
    slope += abs(levels[0]-levels[1]);
    sslope += (slope - sslope) / 2.0;
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
