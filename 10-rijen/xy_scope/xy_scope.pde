import ddf.minim.*;

Minim minim;
AudioInput in;

void setup()
{
  size(512,512,OPENGL);

  frameRate(30); 
  minim = new Minim(this);

  // use the getLineIn method of the Minim object to get an AudioInput
  in = minim.getLineIn(Minim.STEREO,735*2);
}

void draw()
{
  if(frameCount<10)
  frame.setLocation(10,10);

  fill(0,180);
  noStroke();
  rect(0,0,width,height);
  strokeWeight(2);  
  stroke(255,150);

  pushMatrix();
  translate(width/2,height/2);
  rotate(radians(90)); 
  // draw the waveforms so we can see what we are monitoring
  for(int i = 0; i < in.bufferSize()-1; i++)
  {
    float theta = TWO_PI/512.0*1000.0;//mouseX / 10.0;
    float ampl = in.left.get(i)*theta;
    float ampr = in.right.get(i)*theta;
    //float ampl2 = in.left.get(i+1)*theta;
    //float ampr2 = in.right.get(i+1)*theta;

    float l = cos(ampl)*200+ampl;
    float r = sin(ampr)*200+ampr;
    //float l2 = cos(ampl2)*200+ampl2;
    //float r2 = sin(ampr2)*200+ampr2;
    //line(l,r,l2,r2);
    line(l,r,l+2,r);
  }

  popMatrix();

  String monitoringState = in.isMonitoring() ? "enabled" : "disabled";
  text( "Input monitoring is currently " + monitoringState + ".", 5, 15 );
}

void keyPressed()
{
  if ( key == 'm' || key == 'M' )
  {
    if ( in.isMonitoring() )
    {
      in.disableMonitoring();
    }
    else
    {
      in.enableMonitoring();
    }
  }
}
