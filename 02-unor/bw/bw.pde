

float fade = 0;
boolean render = false;

void setup(){

  size(1280,720,P2D);

  noSmooth();

}



void draw(){

  background(0);
  noStroke();

  fill(255,fade);


  for(int y = 0 ; y < height ; y += 8){
    for(int x = 0 ; x < width ; x += 8){
      float sx = (noise(frameCount/100.0+x/200.0,y)-0.5)*100.0;
      float sy = (noise(x,frameCount/100.0+y/200.0)-0.5)*100.0;

      float dist = dist(x+sx,y+sy,width/2,height/2);

      sx += cos((y+frameCount)/100.0)*100.0;
      sy += sin((x+frameCount)/100.0)*100.0;

      dist = dist(x+sx,y+sy,width/2,height/2);

      if(dist<300)
        rect(x+sx,y+sy,2,2);
    }
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
