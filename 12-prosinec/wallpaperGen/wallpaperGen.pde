
void setup(){
  size(1600,900);
  textFont(createFont("Semplice Regular",8,false));
}


void draw(){
  background(0);
  stroke(125);
  /*
     for(int i = 0 ; i < width ; i+=2){
     stroke(255,noise(i/10.0)*20);
     line(i,-1,i,height+1);
     }
   */
  stroke(255,50);

  line(0,1,width,1);
  for(int i = 0 ; i < width ; i+=100){
    line(i,-1,i,height+1);
  }

  for(int i = 1 ; i < height ; i+=100){
    line(-1,i,width+1,i);
  }

  fill(255,50);
  for(int y = 0 ; y < height;y+=100)
    for(int x = 0 ; x < width;x+=100){
      text((x/100)+":"+(y/100),x+2,y);
    }

  stroke(#9C9032);
  noFill();
  rect(0,0,320,240);
  rect(0,0,640,480);
  rect(0,0,720,576);
  rect(0,0,800,600);
  rect(0,0,1024,768);
//  rect(0,0,1152,864);
//  rect(0,0,1360,768);
  rect(0,0,1280,720);



  fill(#9C9032);

  translate(2,0);
  text("320x240",320,240);
  text("640x480",640,480);
  text("720x576",720,576);
  text("800x600",800,600);
  text("1024x768",1024,768);
//  text("1152x864",1152,864);
//  text("1360x768",1360,768);
  text("1280x720",1280,720);

}

void keyPressed(){

  save("/home/kof/wallpapers/gen.png");
  exit();

}



