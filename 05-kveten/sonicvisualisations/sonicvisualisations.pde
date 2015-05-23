
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
  fill(0,230);
  noStroke();
  rect(0,0,width,height);
  stroke(255,200);
  opto.phase(1);
}

