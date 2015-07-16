import java.io.*;

////////////////////////////////////////////////////////////////

ArrayList editors;
Timeline timeline;
int currEdit = 0;

ArrayList files;

String sketchAbsPath = "/sketchBook/2015/01-leden/kofocollider";
String PATH = "/home/kof/annex/kof/";

////////////////////////////////////////////////////////////////

void init(){

  /*
     frame.removeNotify();
     frame.setUndecorated(true);
     frame.addNotify();
   */

  super.init();
}

void setup(){
  size(800,900);

  files = new ArrayList();
  String tmp[] = getFileNames(PATH);
  for(int i = 0;i<tmp.length;i++){
    files.add(tmp[i]);
  }


  editors = new ArrayList();

  editors.add(new Editor((String)files.get(1),1));
  currEdit=0;

  timeline = new Timeline(8);
}

void initNext(int _id){
  editors.add(new Editor((String)files.get(_id+1),_id+1));
}

String [] getFileNames(String _path){
  PATH=_path;
  File dir = new File(PATH);
  String[] list = dir.list();
  if (list == null) {
    println("Folder does not exist or cannot be accessed.");
  } else {
    println(list);
  } 
  return list;
}

////////////////////////////////////////////////////////////////
void draw(){

  if(frameCount==5)
    frame.setLocation(0,0);

  background(0);

  for(Object o : editors){
    Editor tmp = (Editor)o;
    tmp.render();
  }

  timeline.render();
}
////////////////////////////////////////////////////////////////

class Timeline{

  float timer;
  float cap = 512;
  float bars;

  Timeline(float _bars){
    timer = 0;
    bars = _bars;
  }

  void update(){


  }

  void render(){

    float div = width / bars;
    stroke(255);
    for(int i = 0; i < bars;i++){
      line(i*div,height-5,i*div,height-10);
    }

    stroke(255,0,0);
    float pos = map(timer,0,cap,0,width);
    line(pos,height-5,pos,height-10);

    timer++;
    /* 
       if(timer%(int)div==0){
       editor.generate();     
       }
     */

    if(timer>=cap)
      timer = 0;


  }


}
////////////////////////////////////////////////////////////////

class Editor{
  ArrayList lines;
  float tstart,t;
  boolean recording=false;
  boolean recorded = false;
  boolean prepared = false;

  int currln = 0;
  int carret = 0;
  int id;
  int rozpal = 14;
  PVector pos;
  PVector dimm;

  float w =0,wc =0;
  boolean execute = false;
  float fade = 0;
  String name;
  String code[];
  int cnt=0;

  Editor(String _name,int _id){
    id = _id;
    name = _name+"";
    lines = new ArrayList();
    textFont(loadFont("LiberationMono-12.vlw"));

    code = loadStrings(PATH+"/"+name);

    for(int i = 0;i<code.length;i++){
      if(code[i].indexOf("s.boot")==-1)
        if(code[i].indexOf("ProxySpace.push")==-1)
          if(code[i].indexOf("//")==-1)
            lines.add(code[i]+"");
    }

    pos = new PVector(100,100);

    execute("rm /tmp/lang ; mkfifo /tmp/lang ; chmod 775 /tmp/lang");
    execute("killall scsynth");
    execute("killall sclang");
    execute("killall supercollider");
    delay(2500);
    execute("tail -f /tmp/lang | supercolliderJs");
    delay(5000);


    sclang("p=ProxySpace.push(s.reboot)");
    delay(10000);

  }

  void prepareRecord(){
    prepared=true;
    sclang("s.prepareForRecord('/home/kof/recordings/"+name+".aiff');");
    delay(1000);
    startRecording();
  }

  void startRecording(){
    tstart=millis();
    recording=true;
    sclang("s.record;");
    delay(1000);

    execute=true;
  }

  void stopRecord(){
    recording = false;
    recorded = true;
    sclang("s.stopRecording;");
    delay(5000);
    sclang("s.freeAll;");
    delay(1000);
  }

  void render(){

    if(cnt>300 && !recording && !recorded)
      prepareRecord();

    cnt++;



    if(recording){
      fill(255,0,0);
      text("recording",10,10);
    }

    //carret = constrain(carret,0,((String)lines.get(currln)).length()-1);

    fade += execute?255:-15;
    fade = constrain(fade,0,255);

    pushMatrix();
    translate(pos.x,pos.y);

    float maxW = 0;
    for(int i =0 ; i < lines.size();i++){
      String curr = (String)lines.get(i);
      maxW = max(maxW,textWidth(curr));
    }

    dimm = new PVector(maxW,lines.size()*14);

    stroke(255,45);
    fill(255,15);
    rect(0,-20,dimm.x+40,dimm.y+20);

    noStroke();
    for(int i =0 ; i < lines.size();i++){
      String curr = (String)lines.get(i);
      fill(255);
      text(curr,20,i*rozpal);

      if(i==currln){
        fill(#ffcc00,fade);
        rect(20-2,i*rozpal+2,w+12,-11);

        w = textWidth(curr);
        wc = textWidth(curr.substring(0,carret));


        fill(#ff0000,(sin(millis()/25.0)+1.0)/2*255);
        rect(wc+20-2,i*rozpal-10,2,12);


      }
    }

    popMatrix();

    if(recording && !recorded && millis()-tstart > 60000){
      stopRecord();
    }

    if(execute){
      String tmp="";
      for(int ii = 0 ; ii < lines.size();ii++){
        String ttmp = (String)lines.get(ii);
        tmp+=ttmp;
      }

      sclang(tmp);
      execute = false;
    }

    if(recorded){
      editors.remove(this);
      initNext(id);
    }

  }

}
////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////

void keyPressed(){
  Editor editor = (Editor)editors.get(currEdit);

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

    //  if(editor.currln>editor.lines.size()-1){
    //   editor.lines.add(new String(""));
    //  editor.carret = 0;
    //  editor.currln++;
    //}else{
    // }


  }

  if(keyCode==UP){
    if(editor.currln>=0)
      editor.currln--;
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

////////////////////////////////////////////////////////////////

class Executer implements Runnable{
  String command;

  Executer(String _command){
    command = _command;
  }

  void run(){

    String s = null;

    try{

      Runtime runtime = Runtime.getRuntime();

      String cmd[] = {"/bin/sh","-c",command};
      String env[] = {"PATH=/bin/:/usr/bin/:/usr/local/bin/","DISPLAY=:0.0","SHELL=/bin/bash","USER=kof"};

      Process p = runtime.exec(cmd);

      BufferedReader stdInput = new BufferedReader(new
          InputStreamReader(p.getInputStream()));

      BufferedReader stdError = new BufferedReader(new
          InputStreamReader(p.getErrorStream()));

      // read the output from the command
      //System.out.println("Here is the standard output of the command:\n");
      while ((s = stdInput.readLine()) != null) {
        System.out.println(s);
      }

      // read any errors from the attempted command
      //System.out.println("Here is the standard error of the command (if any):\n");
      while ((s = stdError.readLine()) != null) {
        System.out.println(s);
      }

    }
    catch (IOException e) {
      System.out.println("exception happened - here's what I know: ");
      e.printStackTrace();
    }
  }
}

////////////////////////////////////////////////////////////////
///// some functions global ////////////////////////////////////
////////////////////////////////////////////////////////////////

void execute(String _in){
  Runnable runnable = new Executer(_in);
  Thread thread = new Thread(runnable);
  thread.start();
}

void sclang(String _in){
  execute("echo -n \""+_in+"\" | scall");
}


void exit(){
  sclang("s.freeAll");
  execute("pkill scsynth");
  super.exit();
}
