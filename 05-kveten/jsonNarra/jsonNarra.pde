//////////////////////////////////////////////////////
String token;

//String NARRA_URL="192.168.1.100";
String NARRA_URL = "api.narra.eu";

String filename = "projects_faif_items.json";
String port = "80";

///////////////////////////////////////////////////////

//Test test;
Project project;

boolean ONLINE = true;
boolean DEBUG = true;
boolean LOAD_THUMBS = false;

int textSize = 12;

void setup(){

  size(1600,900,P2D);

  smooth();

  token = loadStrings("token.txt")[0];

  project = new Project("faif",filename);

  textFont(createFont("Inconsolata",textSize,true));
}

void draw(){
  background(255);
  project.draw();
}

////////////////////////////////////////////////

class Test{

  String ip;
  String hash;

  Test(){
    try{
      ip = getIp();
      hash = getHash(ip);
      println("My ip is "+ip+" with MD5 hash "+hash);
    }catch(Exception e){
      println("It seems you are trying to run code oflline.");
    }
  }

  String getIp(){
    JSONObject _ip = loadJSONObject("http://ip.jsontest.com");
    return _ip.getString("ip");
  }

  String getHash(String _text){
    JSONObject tmp = loadJSONObject("http://md5.jsontest.com/?text="+_text);
    return tmp.getString("md5");
  }

};
////////////////////////////////////////////////

class Project{

  JSONObject root;
  String name;
  String filename;

  ArrayList items;
  ArrayList sequences;

  Project(String _name,String _filename){

    name = _name;
    if(ONLINE){
      root = loadJSONObject("http://"+NARRA_URL+":"+port+"/v1/projects/"+name+"/items?token="+token);
    }
    else{
      filename = _filename;
      root = loadJSONObject(_filename);
    }

    parse();
    //getSequences();

    if(DEBUG)
      println(root);
  }

  void getSequences(){

    JSONObject ttmp = loadJSONObject("http://"+NARRA_URL+":"+port+"/v1/projects/"+name+"/sequences?token="+token);
    JSONArray tmp;
    tmp = ttmp.getJSONArray("sequences");

    sequences = new ArrayList();

    for(int i = 0 ; i < tmp.size();i++){
      JSONObject o = tmp.getJSONObject(i);
      sequences.add(new Sequence(o,this));
    }
  }

  void parse(){
    JSONArray _items = root.getJSONArray("items");
    items = new ArrayList();

    for(int i = 0 ; i < _items.size();i++){
      JSONObject tmp = _items.getJSONObject(i);
      items.add(new Item(tmp,30,70+20*i,this));
    }
  }

  void draw(){
    fill(0);
    text("project: "+name,20,20);


    for(int i = 0 ; i < items.size();i++){
      Item tmp = (Item)items.get(i);
      tmp.draw();
    }
    /*
       for(int i = 0 ; i < sequences.size();i++){
       Sequence tmp = (Sequence)sequences.get(i);
       tmp.draw();
       }
     */
  }

};
////////////////////////////////////////////////

class Item{

  JSONObject data;
  JSONArray metadata;
  String name;
  String video_proxy_lq;
  String video_proxy_hq;
  String audio_proxy;
  String id;
  String type;
  String [] thumbnails;
  String url;

  float in,out;

  ArrayList thumbs;
  Project parent;

  float W;
  PVector pos;

  Item(JSONObject _data, float _x, float _y,Project _parent){
    pos = new PVector(_x,_y);
    data = _data;
    id = data.getString("id");
    data = getItem(id);
    parent = _parent;
    parse();

    W = textWidth(name);
  }

  JSONObject getItem(String _id){
    JSONObject tmp = new JSONObject();

    if(!ONLINE)
      tmp = loadJSONObject("items_"+_id+".json");
    else
      tmp = loadJSONObject("http://"+NARRA_URL+":"+port+"/v1/items/"+_id+"?token="+token);

    return tmp.getJSONObject("item"); 
  }


  void parse(){

    name = data.getString("name");
    type = data.getString("type");

    if(type.equals("video")){

      url = data.getString("url");
      video_proxy_hq = data.getString("video_proxy_hq");
      video_proxy_lq = data.getString("video_proxy_lq");
      audio_proxy = data.getString("audio_proxy");
      metadata = data.getJSONArray("metadata");

      JSONArray tmp = data.getJSONArray("thumbnails");
      thumbnails = new String[tmp.size()];
      thumbs = new ArrayList();

      for(int ii = 0; ii < tmp.size();ii++){
        thumbnails[ii] = tmp.getString(ii);
        if(LOAD_THUMBS)
          thumbs.add(loadImage(thumbnails[ii]));

        if(ii==0)
          thumbs.add(loadImage(thumbnails[ii]));

      }
    }
  }

  boolean over(){
    if(
        mouseX >= pos.x && 
        mouseX <= pos.x+W+25 &&
        mouseY >= pos.y &&
        mouseY <= pos.y + textSize + 7
      )
      return true;
    else 
      return false;
  }

  void draw(){
    fill(0);
    //text(name,10,10);

    fill(!over()?#fafafa:#ffcc00);
    stroke(0,10);
    rect(pos.x-5,pos.y-1,W+25,textSize+5);
    fill(0,120);
    text(name,pos.x,pos.y+textSize);

    if(over()){
    float Y = 0;
      for(int i = 0 ; i < metadata.size();i++){
        JSONObject tmp = metadata.getJSONObject(i);
        text(tmp.getString("name")+": "+tmp.getString("value"),mouseX+50+25,mouseY+i*textSize);
        Y = mouseY+i*textSize+10;
      }
        image((PImage)thumbs.get(0), mouseX+50+25 , Y );
    }
  }
}

////////////////////////////////////////////////

class Library{
  String id;
  String name;
};

////////////////////////////////////////////////

class Sequence{

  JSONObject root;
  JSONArray marks;

  Project parent;

  String name;
  String id;

  ArrayList itms;


  Sequence(JSONObject _root, Project _parent){
    root = _root;


    parent = _parent;
    id = root.getString("id");
    name = name = root.getString("name");
    root = loadJSONObject("http://"+NARRA_URL+":"+port+"/v1/projects/"+parent.name+"/sequences/"+id+"?token="+token).getJSONObject("sequence");
    marks = root.getJSONArray("marks");

    parse();

  }

  Item getItemByName(String _name){
    Item tmp = null;
    for(int i = 0 ; i < parent.items.size();i++){
      Item ttmp = (Item)parent.items.get(i);
      if(ttmp.name.equals("name"))
        tmp = ttmp;
    }

    return tmp;
  }

  void parse(){

    itms = new ArrayList();

    for(int i = 0 ; i < marks.size(); i++){
      JSONObject tmp = marks.getJSONObject(i);
      JSONObject clip = tmp.getJSONObject("clip");
      Item it = getItemByName(clip.getString("name"));
      //it.in = tmp.getFloat("in");
      //it.out = tmp.getFloat("out");
      itms.add(it);
    }
  }

  void draw(){
    stroke(0);
    for(int i = 0 ; i < itms.size();i++){
      Item item = (Item)itms.get(i);
      line(i*100,height-100,item.pos.x,item.pos.y);
    }  
  }
}

class Author{
  String id;
  String name;
};
