

float source[];
float guess[];

float best[] = {1,1};

float err = 10000000.0;
float res = 50;

void zadani(){
  for(int i = 1 ; i < source.length;i++){
    source[i] = (sin(i/10.0)+1.0)*25;
  }
}

void setup(){
  size(320,240);

  textFont(createFont("Semplice Regular",8,false));

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

iterate:
  for(int i = 1 ; i<10000;i+=100){
    //  res = (sin(frameCount/(i+0.0))+1.001)*25;
    res=random(1000.0);
    float neu = err(i+frameCount,res);

    if(err > neu){
      best[0] = i+frameCount;
      best[1] = res;

      err = neu;
      break iterate;
    }
  }

  fill(255);
  text("err: "+err,10,20);
  text("seed: "+best[0],10,30);
  text("res: "+best[1],10,40);
}

void plot(){
  stroke(255,127);

  for(int i = 1 ; i < source.length;i++){
    line(i,source[i-1]+height/3-50,i,source[i]+height/3-50);
  }

  for(int i = 1 ; i < guess.length;i++){
    line(i,sin((i-1+best[0])/best[1])*25+(height/3*2),i,noise((i+best[0])/best[1])*25+(height/3*2));
  }
}

float err(int seed,float res){
  float err = 0;

  for(int i = 0;i<source.length;i++){
    guess[i] = sin(i+(seed)/res)+1.0*25;
  }

  for(int i = 0;i<source.length;i++){
    err += abs(source[i]-guess[i]);
  }

  return err;
}
