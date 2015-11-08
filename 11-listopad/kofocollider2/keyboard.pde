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
////////////////////////////////////////////////////////////////

void keyPressed(){
  Editor editor = (Editor)editors.get(currEdit);

  if(keyCode==17){
    editor.execute=true;
  }

/*
  // warning, getModifiersEx() requires java 1.4
  // (will break on mac with firefox or ie)
  int modifiers = keyEvent.getModifiersEx() ;
  String modString = "modifiers = " + modifiers ;
  String tmpString = KeyEvent.getModifiersExText(modifiers) ;
  if (tmpString.length() > 0)
  {
    modString += " (" + tmpString + ")" ;
  }
  else
  {
    modString += " (no modifiers)" ;
  }
  println(modString) ;

  println("action key? " + (keyEvent.isActionKey() ? "YES" : "NO")) ;
*/


  if(keyCode==ENTER){
    editor.lines.add("");
    editor.currln++;
  }

  if(keyCode==LEFT)
    editor.carret--;

  if(keyCode==RIGHT)
    editor.carret++;

  if(keyCode==DOWN){
    editor.currln++;
    editor.currln=constrain(editor.currln,0,editor.lines.size()-1);


  }

  if(keyCode==UP){
    if(editor.currln>0)
      editor.currln--;
    editor.currln=constrain(editor.currln,0,editor.lines.size()-1);
  }

  if(keyCode==BACKSPACE && editor.carret>0){
    String tmp = (String)editor.lines.get(editor.currln);
    if(tmp.length()>0){
      editor.lines.set(editor.currln,tmp.substring(0,editor.carret-1)+""+tmp.substring(editor.carret,tmp.length()));
      editor.carret--;
    }
  }

  if(keyCode==DELETE){
    String tmp = (String)editor.lines.get(editor.currln);
    if(tmp.length()>0){
      editor.lines.set(editor.currln,tmp.substring(0,editor.carret)+""+tmp.substring(editor.carret+1,tmp.length()));
      editor.carret--;
    }
  } 

  if((int)key>=24 && (int)key <= 126){
    String tmp = (String)editor.lines.get(editor.currln);
    editor.lines.set(editor.currln,tmp.substring(0,editor.carret)+""+key+tmp.substring(editor.carret,tmp.length()));
    editor.carret++;
  }


  editor.carret = constrain(editor.carret,0,((String)editor.lines.get(editor.currln)).length());
  editor.currln = constrain(editor.currln,0,editor.lines.size()-1);
}

