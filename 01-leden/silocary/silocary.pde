////////////////////////////////////////////////
///////// SILOCARY /// kof @ 15 ///////////////
//////////////////////////////////////////////



void setup(){

  size(400,400,P3D);

  ortho();

}





void draw(){
  background(0);
  noFill();
  stroke(255,15);

  pushMatrix();
  translate(width/2,height/2,0);
  pushMatrix();

  rotateX(frameCount/100.0);
  float R = 300;

  for(float i = 0 ;i < 1000;i++){
    float x1 = (noise(frameCount*i/1000.0,frameCount*i/200000.0,frameCount*i/300000.0)-0.5)*R;
    float y1 = (noise(frameCount*i/10000.0,frameCount*i/2000.0,frameCount*i/30000.0)-0.5)*R;
    float z1 = (noise(frameCount*i/100000.0,frameCount*i/20000.0,frameCount*i/3000.0)-0.5)*R;

    float x2 = (noise(frameCount/i/100.0,frameCount/i/200.0,frameCount/i/30.0)-0.5)*R;
    float y2 = (noise(frameCount/i/1000.0,frameCount/i/2000.0,frameCount/i/300.0)-0.5)*R;
    float z2 = (noise(frameCount/i/100.0,frameCount/i/20.0,frameCount/i/3000.0)-0.5)*R;

    bezier(-R/2,0,0,x1,y1,z1,x1,y1,z1,R/2,0,0);
  } 
  popMatrix();
  popMatrix();



}
