/*
   Optosonic transoder
   Copyright (C) 2015 Krystof Pesek

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, see <http://www.gnu.org/licenses/>.

 */


// rozsah min, max >> je lepsi to mozna stelovat na zvukovce

float UROVNE[] = {0.001 ,0.1 };

boolean printing = false;

OptoVizer opto;

////////////////////////
int width = 768;
int height = 1024;

int phase = 0;
////////////////////////

void setup()
{
  size(768,1024,P2D);
  frameRate(100);
  opto = new OptoVizer(this);
}

void draw(){
  fill(0,230);
  noStroke();
  rect(0,0,width,height);
  stroke(255,200);
  opto.phase(phase);

  if(printing&&frameCount%120==0)
    printFrame(true);

  if(printing){
    fill(255);
    rect(10,10,10,10);
  }
}

void keyPressed(){
  if(key==' '){
    phase++;

    phase = phase % 4;
  }

  if(key=='p'){
    println("printing..");
    printing = !printing;

  }

}
