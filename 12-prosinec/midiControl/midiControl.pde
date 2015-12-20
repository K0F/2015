import themidibus.*; //Import the library
import processing.serial.*;

/*

import cc.arduino.*;


Arduino arduino;
*/


MidiBus busA; //The first MidiBus

Serial port;

/////////////////////////////////////////////////////////////////
String name = "VirMIDI [default]";
//String name = "MPD218 [hw:2,0,0]";

boolean debug = false;
int X = 0;
int Y = 0;
int w = 20;


char hs[] = {'W','E','R','T','Y','U'};
char ls[] = {'S','D','F','G','H','J'};

ArrayList buttons;
int notes[] = {
  48,49,50,51,
  44,45,46,47,
  40,41,42,43,
  36,37,38,39
};
//int notes[] = {36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51};
int channel = 9;
////////////////////////////////////////////////////////////////

void setup() {
  size(400, 400);
  background(0);

  println(Serial.list());
port = new Serial(this, Serial.list()[0], 9600);

  

  

  frameRate(30);

  buttons = new ArrayList();
  for(int i = 0 ; i< notes.length;i++){
    buttons.add(new Button(notes[i],i));
  }

  MidiBus.list(); //List all available Midi devices. This will show each device's index and name.
/*
  //This is a different way of listing the available Midi devices.
  println(); 
  println("Available MIDI Devices:"); 

  System.out.println("----------Input (from availableInputs())----------");
  String[] available_inputs = MidiBus.availableInputs(); //Returns an array of available input devices
  for (int i = 0;i < available_inputs.length;i++) System.out.println("["+i+"] \""+available_inputs[i]+"\"");

  System.out.println("----------Output (from availableOutputs())----------");
  String[] available_outputs = MidiBus.availableOutputs(); //Returns an array of available output devices
  for (int i = 0;i < available_outputs.length;i++) System.out.println("["+i+"] \""+available_outputs[i]+"\"");

  System.out.println("----------Unavailable (from unavailableDevices())----------");
  String[] unavailable = MidiBus.unavailableDevices(); //Returns an array of unavailable devices
  for (int i = 0;i < unavailable.length;i++) System.out.println("["+i+"] \""+unavailable[i]+"\"");
*/
  busA = new MidiBus(this, name, name, name); //Create a first new MidiBus attached to the IncommingA Midi input device and the OutgoingA Midi output device. We will name it busA.

  busA.addOutput(name); //Add a new output device to busA called OutgoingC
  busA.addInput(name); //Add a new input device to busB called IncommingC
}

void draw() {
  background(0);


  for(int i = 0 ; i < buttons.size();i++){
    Button tmp = (Button)buttons.get(i);
    tmp.draw();
  } 

}




void noteOn(int channel, int pitch, int velocity, long timestamp, String bus_name) {

  if(debug){
    println();
    println("Note On:");
    println("--------");
    println("Channel:"+channel);
    println("Pitch:"+pitch);
    println("Velocity:"+velocity);
    println("Timestamp:"+timestamp);
    println("Recieved on Bus:"+bus_name);
  }

  Button tmp = getByNum(pitch);
  tmp.on=!tmp.on;
  tmp.send();

}

void noteOff(int channel, int pitch, int velocity, long timestamp, String bus_name) {
  if(debug){
    println();
    println("Note Off:");
    println("--------");
    println("Channel:"+channel);
    println("Pitch:"+pitch);
    println("Velocity:"+velocity);
    println("Timestamp:"+timestamp);
    println("Recieved on Bus:"+bus_name);
  }
  /*
     Button tmp = getByNum(pitch);
     tmp.on=false;
     tmp.send();
   */
}

void controllerChange(int channel, int number, int value, long timestamp, String bus_name) {
  if(debug){
    println();
    println("Controller Change:");
    println("--------");
    println("Channel:"+channel);
    println("Number:"+number);
    println("Value:"+value);
    println("Timestamp:"+timestamp);
    println("Recieved on Bus:"+bus_name);
  }

}

Button getByNum(int in){
  Button tmp;
  int index = 0;

search:
  for(int i = 0 ; i < buttons.size();i++){

    Button ttmp = (Button)buttons.get(i);
    if(ttmp.num==in){
      index = i;
      break search;
    }
  }

  return (Button)buttons.get(index);
}



void delay(int time) {
  int current = millis();
  while (millis () < current+time) Thread.yield();
}


class Button{
  int num;
  int id;
  boolean on = false;
  PVector pos;

  Button(int _num,int _id){
    num = _num;
    id = _id;
    pos = new PVector(X*w,Y*w);
    X+=1;
    if(X>=4){
      X=0;
      Y++;
    }
  }

  void send(){
    int channel = 9;
    int pitch = num;
    int velocity = 127;

if(id<6)
    if(on){
      busA.sendNoteOn(channel, pitch, velocity); //Send a noteOn to OutgoingA and OutgoingC through busA
      port.write(hs[id]);
    }else{
      busA.sendNoteOff(channel, pitch, velocity); //Send a noteOff to OutgoingA and OutgoingC through busA
      port.write(ls[id]);
    }
  }

  void draw(){
    pushMatrix();
    translate(pos.x,pos.y);
    fill(on?#ff0000:#ffffff);
    rect(0,0,w,w);
    popMatrix();
    send();

  }

}
