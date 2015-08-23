import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

Minim minim;
MultiChannelBuffer buffer;

AudioOutput output;
Sampler sampler;

Editor editor;

Interpreter interpreter;

void setup() {
  size(400, 400);
  surface.setResizable(false);
  
  frameRate(10);



  interpreter = new Interpreter(this);
  editor = new Editor(this);
  
  interpreter.set();
}

void draw() {
  background(0);

  editor.draw();
}


class Interpreter {


  PApplet parent;
  
  int BUFFER_SIZE = 4410;
  int SAMPLE_RATE = 44100;
  int CHANNELS = 2;
  float AMP = 0.5;
  double time = 0;
  
  float raw[];

  Interpreter(PApplet _parent) {
  
    parent = _parent;
    
    raw = new float[BUFFER_SIZE];

    minim = new Minim(parent);
    output = minim.getLineOut();

    buffer = new MultiChannelBuffer(1, BUFFER_SIZE);
    buffer.setBufferSize(BUFFER_SIZE);
    
    for (int i = 0; i < BUFFER_SIZE; i++) {
      buffer.setSample(0, i, 0.0);
    }

    sampler = new Sampler(buffer, SAMPLE_RATE, CHANNELS);
    sampler.patch( output );
    sampler.looping = true;
    sampler.trigger();
  }



  void set() {
    for (int t = 0; t < BUFFER_SIZE; t++) {
      raw[t] = sin((float)time/800.0) * AMP;
      
      if(t<100)
      t *= map(t,0,100,0,1);
      
      if(t>BUFFER_SIZE-100)
      t *= map(t,BUFFER_SIZE-100,BUFFER_SIZE,1,0);
      
      buffer.setSample(0, t, raw[t]);
      time++;
    }
  }
  /*
  void stop(){
   minim.stop();
   parent.super.stop();
  }
  
  ???
  */
}

class Editor {
  ArrayList txt;
  int pos;
  PApplet parent;
  PFont font;
  int size = 10;
  int line = 0;

  Editor(PApplet _parent) {
    parent = _parent;
    txt = new ArrayList();
    font = loadFont("Monospaced.plain-10.vlw");
    textFont(font, size);
    pos = 0;

    txt.add("test");
    txt.add("test");
    txt.add("test");
  }

  void draw() {

    fill(255);
    int ln = 0;
    for (Object o : txt) {
      String tmp = (String)o+"";
      text(tmp, 10, 20+size*ln);
      ln++;
    }
  }

  String currLn() {
    return (String)txt.get(line);
  }

  void addTxt(String _txt) {
    String tmp = (String)txt.get(line);
    tmp += _txt;
    txt.set(line, tmp);
  }

  void backspace() {

    String tmp = (String)txt.get(line);
    if (tmp.length()>=1) {

      tmp  = tmp.substring(0, tmp.length()-1);
      txt.set(line, tmp);
    }
  }
}

void keyPressed() {

  if (key >= 20 && key <= 126) {
    println(key);
    editor.addTxt(key+"");
  }

  if (keyCode==BACKSPACE) {
    editor.backspace();
  }
}


void stop(){
 minim.stop();
 super.stop();
}