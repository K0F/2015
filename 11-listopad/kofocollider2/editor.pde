/*

Kofocollider interface to SuperCollider written in processing and using OpenObject
Copyright (C) 2015 Krystof Pesek

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

////////////////////////////////////////////////////////////////

class Editor{
  ArrayList lines;

  int currln = 0;
  int carret = 0;

  int rozpal = 11;
  PVector pos;
  PVector dimm;

  float w =0,wc =0;
  boolean execute = false;
  float fade = 0;
  String name;

  Editor(String _name){
    name = _name+"";
    lines = new ArrayList();
    textFont(loadFont("AnonymousPro-11.vlw"),11);

    pos = new PVector(100,100);

    lines.add("~"+name+".ar(2);");
    lines.add("~"+name+"={");
    lines.add("");
    lines.add("};");
    lines.add("~"+name+".fadeTime=5;");
    lines.add("~"+name+".quant=2;");
    lines.add("~"+name+".play;");
  }

  void render(){

try{
    //carret = constrain(carret,0,((String)lines.get(currln)).length()-1);

    fade += execute ? 255 : -15;
    fade = constrain(fade,0,255);

    pushMatrix();
    translate(pos.x,pos.y);

    float maxW = 0;
    for(int i =0 ; i < lines.size();i++){
      String curr = (String)lines.get(i);
      maxW = max(maxW,textWidth(curr));
    }

    dimm = new PVector(maxW,lines.size()*rozpal);

    rectMode(CORNER);
    stroke(255,45);
    fill(255,15);
    rect(-20,-20,dimm.x+40,dimm.y+20);

    noStroke();
    for(int i =0 ; i < lines.size();i++){
      String curr = (String)lines.get(i);
      fill(255);
      text(curr,0,i*rozpal);


        fill(#ffcc00,fade);
    rect(-20,-20,dimm.x+40,dimm.y+20);
        //rect(-5,i*rozpal+2,w+5,-rozpal);

      if(i==currln){
      w = textWidth(curr);
      wc = textWidth(curr.substring(0,carret));



      
        fill(#ff0000,(sin(millis()/25.0)+1.0)/2*255);
        rect(wc-1,i*rozpal-9,2,12);


      }
    }

    popMatrix();

    if(execute){
      String tmp="";
      for(int ii = 0 ; ii < lines.size();ii++){
        String ttmp = (String)lines.get(ii);
        tmp+=ttmp;
      }
      println(tmp);
      execute(tmp);
      execute = false;
    }
    }catch(Exception e){println("errr!");}
  }

}


