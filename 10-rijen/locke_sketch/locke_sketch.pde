
import ddf.minim.*;
import ddf.minim.ugens.*;

Minim minim=new Minim(this);
MultiChannelBuffer buffer=null;

AudioOutput output = minim.getLineOut();
Sampler sampler=null;

boolean edgeSmoothing=true;
int timeStretch=2;
int simplifier=1;

String formula = "salksl";
float raw[];
int t = 0;

int ATOMIC_BUFFER_SIZE = 1024;

void ResetBuffer() {
  int size=timeStretch*ATOMIC_BUFFER_SIZE/simplifier;
  raw = new float[size];
  buffer = new MultiChannelBuffer(1,size);
  buffer.setBufferSize(size);
  for(int i = 0 ; i < ATOMIC_BUFFER_SIZE/simplifier;i++ )
    for ( int j=0; j < timeStretch; j++ )
      buffer.setSample(0,i*timeStretch+j,0.5);
  if ( sampler != null ) sampler.stop();
  sampler = new Sampler(buffer,16384,2);
  sampler.patch( output );
  sampler.looping = true;
  sampler.trigger();
}

void UpdateSample(){
  int size=timeStretch*ATOMIC_BUFFER_SIZE/simplifier;
  int last=size-1;
  float s = 0.5;
  float step = 0.1;
  for(int t = 0 ; t < ATOMIC_BUFFER_SIZE/simplifier;t++){

    switch(formula.charAt(t%formula.length())){
      case 'a': step-=0.01; break;
      case 's': s+=step; break;
      case 'k': s-=step; break;
      case 'l': step+=0.01; break;
    }

    // Clamp
    if(s>1.0) s=-1.0;
    if(s<-1.0) s=1.0;

    for ( int j=0; j<timeStretch; j++ ) {
      int idx=t*timeStretch+j;
      raw[idx] += (s-raw[idx])/10.0;
      if ( edgeSmoothing ) { raw[0]=0.0; raw[last]=0.0; }
      buffer.setSample(0,t,raw[idx]);
    }
  }
}

void setup(){
  size(1024,240);

  textFont(createFont("Semplice Regular",8));
  textLeading(9);

  noSmooth();

  ResetBuffer();
  UpdateSample();
}


void draw(){
  background(0);
  fill(255);
  text(formula,10,10,width-20,height-20);
  text("Time: "+timeStretch,width-100,40);
  text("Simp: "+simplifier,width-100,60);
  text("Size: "+(timeStretch*ATOMIC_BUFFER_SIZE/simplifier),width-100,80);

  noFill();
  stroke(255);
  int len=ATOMIC_BUFFER_SIZE/simplifier;
  beginShape();
  for(int i = 0 ; i<ATOMIC_BUFFER_SIZE/simplifier;i++){
    float f = map(raw[i*timeStretch],-1.0,1.0,0,100);
    float x = map(i,0,ATOMIC_BUFFER_SIZE/simplifier,10,width-10);
    fill(x/width,f%2*127+127,0);
    stroke(255,x/width,f%2*127+127);
    vertex(x,f+120);
  }
  endShape();
}

void keyPressed(){
  boolean delta=false;
  if(key=='a'||key=='s'||key=='k'||key=='l'){
    formula = formula+key+"";
    delta=true;
  }

  if(keyCode==BACKSPACE) {
    if(formula.length()>1) {
      formula = formula.substring(0,formula.length()-1);
      delta=true;
    }
  }

  if(keyCode==DELETE) { formula = formula.substring(0,1); delta=true; }

  if(keyCode==ENTER) { edgeSmoothing=!edgeSmoothing; delta=true; }

  if ( delta ) {
    UpdateSample();
  }

  delta=false;

  if (keyCode==LEFT) { timeStretch-=1; if ( timeStretch < 1 ) timeStretch=1; delta=true; }
  else
    if (keyCode==RIGHT) { timeStretch+=1; if ( timeStretch > 16 ) timeStretch=16; delta=true; }

  if (keyCode==UP) { simplifier-=1; if ( simplifier < 1 ) simplifier=1; delta=true; }
  else
    if (keyCode==DOWN) { simplifier+=1; if ( simplifier > 256 ) simplifier=256; delta=true; }

  if ( delta ) {
    ResetBuffer(); UpdateSample();
  }
} 
