

int raster = 10;

float scale = 1;
float speed = 1;
float ammount = 1;

void setup(){

  size(1280,720,P2D);
  noiseSeed(2015);
  rectMode(CENTER);
}


void draw(){


  speed = noise(frameCount/1013450.1,0,0)*100.0;
  scale = noise(0,frameCount/10090.1,0)*1000.0;
  ammount = noise(0,0,frameCount/110000.1)*1.0;

  background(255);
  noStroke();
  fill(0);
  for(int y = 0 ; y <= height;y+=raster) 
    for(int x = 0 ; x <= width;x+=raster){
      pushMatrix();
      float angle = 0;
      angle = (noise(x/scale,y/scale,frameCount/speed)*TWO_PI*ammount);
      translate(x,y);
      rotate(angle);
      rect(0,0,5,PI*5);
      popMatrix();
    }


}
