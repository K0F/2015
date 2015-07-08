/*
   Optosonic transoder by Kof 2015-06-01
   Copyright (C) 2015 Krystof Pesek

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, see <http://www.gnu.org/licenses/>.

 */

import ddf.minim.*;
import ddf.minim.analysis.*;
///////////////////////////////////////////////

class OptoVizer {

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

  PGraphics printer;

  OptoVizer(PApplet _parent) {

    // papplet
    parent= _parent;

    // sound system
    minim = new Minim(parent);
    input = minim.getLineIn(Minim.STEREO, 1024);

    // fft
    fftLog = new FFT(input.bufferSize(), input.sampleRate());
    fftLog.logAverages(22, 3);

    // vals
    amps = new ArrayList();

    printer = createGraphics(144,630,P2D);

  }

  void phase(int _phase) {
    switch(_phase) {
      case 0:
        one();
        break;
      case 1:
        two();
        break;
      case 2:
        three();
        break;
      case 3:
        four();
        break;
      default:
        voids();
    }
  }

  void voids() {
    ;
  }

  ///////

  void one() {
    compute();
    plotOne();
  }


  void plotOne() { 
    pushMatrix();
    translate(width/2, 0);
    int cnt = 0;
    float sm = 0;
    for (Object o : amps) {
      pushMatrix();
      translate(0, cnt);
      float val = (Float)o;
      sm += (val-sm)/10.0;
      line(-sm, 0, sm, 0);
      popMatrix();
      cnt++;
    }
    popMatrix();
  }

  ////////

  void two() {
    compute();
    plotTwo();
  }

  void plotTwo() {
    int cnt=0;
    for (Object o : amps) {
      pushMatrix();
      translate(0, cnt);
      float val = (Float)o;
      stroke(val*1.5);
      line(0, 0, width, 0);
      popMatrix();
      cnt++;
    }
  }
  ////////

  void three() {
    compute();
    plotThree();
  }

  void plotThree() {
    int cnt=0;
    for (Object o : amps) {
      pushMatrix();
      translate(0, cnt);
      float val = (Float)o;
      stroke(val);
      for(int i = 0 ; i < val/4;i++){
      float r = random(width);
      line(r, 0, r+1, 0);
      }
      popMatrix();
      cnt++;
    }
  }

  ////////

  void four() {
    compute();
    plotFour();
  }

  void plotFour() {
    pushMatrix();
    translate(0, 0);
    int cnt = 0;
    float sm = 0;
    for (Object o : amps) {
      pushMatrix();
      translate(0, cnt);
      float val = (Float)o;
      sm += (val-sm)/10.0;
      line(0,0, sm/2, 0);
      popMatrix();
      cnt++;
    }
    popMatrix();
   }


  ///////
  void compute() {

    //SCALE += ((sslope*SCALAR)-SCALE)/2.0;

    float levels[] = UROVNE;
    slope = 0;

    float sm = 0;

    for (int i = 0; i < input.bufferSize() - 1; i++) {
      float base = (input.left.get(i) + input.right.get(i))/2.0;
      float amp = map(base, levels[0], levels[1], 0, SCALE);

      sm += (amp-sm)/10.0;

      amps.add(sm);

      if (amps.size()>height) {
        amps.remove(0);
      }
    }
    slope += abs(levels[0]-levels[1]);
    sslope += (slope - sslope) / 2.0;
  }

  float averages()[]{
    float [] avg = new float[2];
    for (int i = 0; i < input.bufferSize() - 1; i++)
    {
      float base = (input.left.get(i) + input.right.get(i))/2.0;
      avg[0] = min(base, avg[0]);
      avg[1] = max(base, avg[1]);
    }
    return avg;
  }
}
