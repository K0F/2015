

boolean [][] pix;

void settings(){
  size(320,320);
  pix = new boolean[width][height];
  background(0);

}

void draw(){
  for(int y = 0 ; y<height/2;y++){
    for(int x = 0 ; x<width/2;x++){
      if(pix[x][y])
      set(x,y,color(255));
    }
  }

}
