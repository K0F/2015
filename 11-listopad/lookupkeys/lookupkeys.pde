

float source[];
float guess[];

float best[] = {1,1};

float err = 10000000.0;
float res = 1;

void zadani(){
  for(int i = 1 ; i < source.length;i++){
    source[i] = (i)%50;
  }



}

void setup(){
  size(320,240);

  source = new float[width];
  guess = new float[width];

  best[0] = frameCount;
  best[1] = 1.0;

  zadani();
  err = err(1,1);


}


void draw(){

  background(0);
  plot();

  for(int i = 1 ; i<100;i++){
    res = (sin(frameCount/(i+0.0))+1.0)*100.0;
    float neu = err(frameCount,res);

    if(err > neu){
      best[0] = frameCount;
      best[1] = res;

      err = neu;
    }
  }

}

void plot(){
  stroke(255,127);

  for(int i = 1 ; i < source.length;i++){
    line(i,source[i-1]+height/3-50,i,source[i]+height/3-50);
  }

  noiseSeed((int)best[0]);
  for(int i = 1 ; i < guess.length;i++){
    line(i,noise(i-1/best[1])*100.0-50+(height/3*2),i,noise(i/best[1])*100.0-50+(height/3*2));
  }
}

float err(int seed,float res){

  float err =0;
  noiseSeed(seed);

  for(int i = 0;i<source.length;i++){
    guess[i] = noise(i/res)*100;
  }

  for(int i = 0;i<source.length;i++){
    err += abs(source[i]-guess[i]);
  }

  return err;

}
