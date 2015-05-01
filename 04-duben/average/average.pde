
import processing.video.*;

Movie movie;

void setup(){
  size(720,540,P2D);
  frameRate(25);

  movie = new Movie(this,"/down/ZTRACENY_PRIPAD_FINAL_PRORess.mov");

  //movie = new GSPipeline(this, "videotestsrc");
  //movie = new GSPipeline(this, "filesrc location=\"/down/ZTRACENY_PRIPAD_FINAL_PRORess.mov\" ! decodebin ! autovideoconvert ! video/x-raw-rgb,width=720,height=540,framerate=25/1");
  //movie = new GSPipeline(this, "filesrc location='/archive/kof/Downloads/ZTRACENY_PRIPAD_FINAL_PRORess.mov'");
  //movie = new GSPipeline(this, "playbin uri=\"file:///down/ZTRACENY_PRIPAD_FINAL_PRORess.mov\"");

  movie.play();
}

void movieEvent(Movie _movie) {
  _movie.read();
}

void draw(){
  image(movie,0,0);
  analyze();
}

void analyze(){

  loadPixels();

  float r,g,b,c;
  r=0;
  b=0;
  g=0;
  c=0;

  for(int i = 0 ; i < pixels.length;i++){
    r += red(pixels[i])/255.0;
    g += green(pixels[i])/255.0;
    b += blue(pixels[i])/255.0;

    c++;
  }

  r=r/(c+0.0)*255.0;
  g=g/(c+0.0)*255.0;
  b=b/(c+0.0)*255.0;

  fill(r,g,b);
  noStroke(); 
  rect(0,0,width,height);
}
