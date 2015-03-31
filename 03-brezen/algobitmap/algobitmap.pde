/*
Coded by Kof @ 
Sun Mar 22 17:03:38 CET 2015



   ,dPYb,                  ,dPYb,
   IP'`Yb                  IP'`Yb
   I8  8I                  I8  8I
   I8  8bgg,               I8  8'
   I8 dP" "8    ,ggggg,    I8 dP
   I8d8bggP"   dP"  "Y8ggg I8dP
   I8P' "Yb,  i8'    ,8I   I8P
  ,d8    `Yb,,d8,   ,d8'  ,d8b,_
  88P      Y8P"Y8888P"    PI8"8888
                           I8 `8,
                           I8  `8,
                           I8   8I
                           I8   8I
                           I8, ,8'
                            "Y8P'
*/

PGraphics velky;

float diameter = 400;

void setup(){

  size(862,284,P2D);

  background(0);
  stroke(255);


  velky=createGraphics(round(8622/3.0*2),round(2846/3.0*2));

  velky.beginDraw();
  for(int i = 0 ; i < velky.width;i+=1){
    if(i%2==0)
      velky.stroke(i/(velky.width+0.0)*255);
    else
      velky.stroke(255-(i/(velky.width+0.0)*255));
    velky.line(i,0,i,velky.height);
  }


  for(int i = 0 ; i < velky.height;i+=1){
    if(i%2==0)
      velky.stroke(0,i/(velky.height+0.0)*255);
    else
      velky.stroke(255,255-(i/(velky.height+0.0)*255));
    velky.line(0,i,velky.width,i);
  }
  velky.endDraw();
  velky.save("/tmp/shot.png");


}

void glitch(){

  noiseSeed(29);

  velky.loadPixels();
  int step = 100;
  int shift = 0;
  int cnt = 1;

  for(int i = 0;i<velky.pixels.length;i++){

    if(cnt%step==0){
      cnt=1;
      step=(int)random(10,300);
      shift = (int)random(-512,512)+velky.width/2;
    }

    if(i%velky.width==0)
      cnt++;

    int x = i%velky.width;
    int xg = (i+shift)%velky.width;
    int y = i/velky.width;

    color c = velky.pixels[i];
    color c2 = velky.pixels[y*velky.width+xg];
    float re = red(c);
    float gr = green(c2);
    float bl = blue(c2);

    velky.pixels[i]=color(re,gr,bl);
  }
  velky.updatePixels();


}

void draw(){
  velky.loadPixels();
  for(int i = 0;i<velky.pixels.length;i++){

    int x = i%velky.width;
    int y = i/velky.width;
    float d = dist(x,y,velky.width/2,velky.height/2);

    if(d<(sin(frameCount/100.0)+1.0)*diameter){
      color c = lerpColor(velky.pixels[i],velky.pixels[ (y-((int)random(-2,2)))*velky.width+(x-((int)random(-2,2))) ],0.01);
      velky.pixels[i]=c;
    }
  }
  velky.updatePixels();

  image(velky,0,0,width,height);

}

void keyPressed(){
  glitch();
  velky.save("/tmp/shot.png");
  keyPressed=false;
}
