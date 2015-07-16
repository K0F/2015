
import oscP5.*;
import supercollider.*;

Buffer buffer;

void setup ()
{
  size(256, 256);
  background(0);
  stroke(255);
  
  buffer = new Buffer(width, 1);
  buffer.alloc(this, "done");
}

void draw ()
{
  buffer.getn(1, buffer.frames, this, "getn");
}
void done (Buffer buffer)
{
  Synth synth = new Synth("recordbuf_1");
  synth.set("bufnum", buffer.index);
  synth.set("loop", 1);
  synth.create();
}

void getn (Buffer buffer, int index, float [] values)
{
  background(0);
  stroke(255); 
  for (int i = 0; i < values.length; i++)
  {
    line(i, (256 * 0.5) + (values[i] * 256 * 0.5),i,0);
  }
}
