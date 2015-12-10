import processing.serial.*;
import cc.arduino.*;


import promidi.*;

MidiIO midiIO;
Arduino arduino;

ArrayList buttons;


void setup(){



  Arduino arduino;
  for(int i = 0; i < sw.length; i++) {
    arduino.pinMode(sw[i], Arduino.INPUT);
    arduino.digitalWrite(sw[i], Arduino.HIGH);
  }
  arduino.pinMode(13, Arduino.INPUT);
  for(int i = 0; i < led.length; i++) {
    arduino.pinMode(led[i], Arduino.OUTPUT);
  }

  midiIO = MidiIO.getInstance(this);
  println("printPorts of midiIO");
  midiIO.printDevices();
  println();

  println("printDevices recoded 1");
  midiIO.printInputDevices();
  midiIO.printOutputDevices();
  println("<<<<<<<<<   >>>>>>>>>>>>>>>>>>>>>");
  println();

  println("printDevices recoded 2");
  println("<< inputs: >>>>>>>>>>>>>>>>>>>>>>");
  for(int i = 0; i < midiIO.numberOfInputDevices();i++){
    println("input  "+nf(i,2)+": "+midiIO.getInputDeviceName(i));
  }
  println("<< outputs: >>>>>>>>>>>>>>>>>>>>>");
  for(int i = 0; i < midiIO.numberOfOutputDevices();i++){
    println("output "+nf(i,2)+": "+midiIO.getOutputDeviceName(i));
  }
  println("<<<<<<<<<   >>>>>>>>>>>>>>>>>>>>>");


  buttons = new ArrayList();

  float x,y;
  x=y=10;
  for(int i = 1 ; i <= 16;i++){

    buttons.add(new Button(i,x,y));

    x+=10;
    if(i%4==0){
      y+=10;
      x=10;
    }
  }
}

void draw(){

  background(0);

  for(Object o:buttons){
    Button tmp = (Button)o;
    tmp.draw();
  }

}

class Button{
  PVector pos;
  int id;
  boolean down;

  Button(int _id,float _x, float _y){
    id = _id;
    pos = new PVector(_x,_y);
  }

  void down(){
    down = true; 
  }

  void up(){
    down= false;
  }

  void draw(){
    pushMatrix();
    translate(pos.x,pos.y);
    noFill();
    fill(down?#ffcc00:255);
    rect(0,0,10,10);
    popMatrix();
  }
}
