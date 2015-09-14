

import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress remote;

int cc = 0;
int NUM = 10000;
ArrayList tickers;
color C;

void setup(){
  size(320,240,P2D);

  frameRate(25);

  oscP5 = new OscP5(this,12000);


  tickers = new ArrayList();

  int step = 25;
  for(int i = 0 ; i < NUM;i++){
    tickers.add(new Ticker(step));
    step += 1;
  }


}

void send(){
  remote = new NetAddress("127.0.0.1",10000);
  OscMessage myMessage = new OscMessage("/test");
  myMessage.add(cc);
  oscP5.send(myMessage, remote);
}

void draw(){


  cc = 0;
  for(int i = 0 ;i < tickers.size();i++){
    Ticker tmp = (Ticker)tickers.get(i);
    tmp.draw();
  }

  send();
  background(cc);

}

class Ticker{
  int mod;
  color c;
  boolean tick;

  Ticker(int _mod){
    mod = _mod;
    c = color(255);//color(random(255),random(255),random(255));
  }

  void draw(){
    if(frameCount%(mod+1)==0){
      tick = true;
    }else{
      tick = false;
    }   

    if(tick){
      cc += 1;
    }
  }

}
