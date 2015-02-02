

float tc;

int seq[] = {25};

void setup(){

  size(1280,720);

  frameRate(25);

  textFont(createFont("Monaco",7,false));
}



void draw(){

  tc += 1/25.0;

  background(0);
  fill(255);
 
  for(int i = 0;i<seq.length;i++){
  if( ((int)(tc*25))%seq[i]==0 )
  text(tc,width/2,height/2);
  }
}
