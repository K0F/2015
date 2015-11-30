import oscP5.*;
import netP5.*;

OscP5 osc;
NetAddress sc;

void setup(){
  osc = new OscP5(this,12000);
  sc = new NetAddress("127.0.0.1",57110);
}


void draw(){
  if(frameCount%60==0)
  msg( new Object[]{new Object[]{15,1000,"fadeTime",4}} );
}

void msg(Object [] data){
  osc.send("#bundle",data,sc);
}
