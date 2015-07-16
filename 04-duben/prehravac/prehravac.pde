import processing.video.*;

Movie myMovie;

String name = "test.mpg";
boolean newFrame = false;
float duration = 0;
int counter = 0;

void init(){
  frame.removeNotify();
  frame.setUndecorated(true);
  frame.addNotify();
  super.init();
}

void setup() {
  size(720/4,540/4,P2D);

  myMovie = new Movie(this, "/down/"+name);
  myMovie.play(); 
}


void draw() {



  if(newFrame){
    image(myMovie,0,0,width,height);
    analyze();
    println(counter);
    counter++;



    newFrame=false;

    if(counter>=86250){
      exit();
    }
  }

}
void movieEvent(Movie m) {
  m.read();
  newFrame=true;
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
  save("romanAvg/fr"+nf(counter,5)+".png");
}

