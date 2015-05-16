//////////////////////////////////////////////////////
String token;
String NARRA_URL="192.168.1.103";
String filename = "projects_faif_items.json";
//String NARRA_URL = "api.narra.eu";
///////////////////////////////////////////////////////

//Test test;
Project project;

boolean ONLINE = false;
boolean DEBUG = true;
boolean LOAD_THUMBS = false;

int textSize = 12;

void setup(){

  size(1024,576);

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
      root = loadJSONObject("http://"+NARRA_URL+"/v1/projects/"+name+"/items?token="+token);

    }
    else{
      filename = _filename;
      root = loadJSONObject(_filename);
    }

    parse();
    getSequences();

    if(DEBUG)
      println(root);
  }

  void getSequences(){

    JSONObject ttmp = loadJSONObject("http://"+NARRA_URL+"/v1/projects/"+name+"/sequences?token="+token);
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
      items.add(new Item(tmp,20,50+50*i));
    }
  }

  void draw(){
    fill(0);
    //text(name,10,10);

    for(int i = 0 ; i < items.size();i++){
      Item tmp = (Item)items.get(i);
      tmp.draw();
    }
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

  ArrayList thumbs;

  float W;
  PVector pos;

  Item(JSONObject _data, float _x, float _y){
    pos = new PVector(_x,_y);
    data = _data;
    id = data.getString("id");
    data = getItem(id);
    parse();

    W = textWidth(name);
  }

  JSONObject getItem(String _id){
    JSONObject tmp = new JSONObject();

    if(!ONLINE)
      tmp = loadJSONObject("items_"+_id+".json");

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
      }
    }
  }

  boolean over(){
    if(
        mouseX >= pos.x && 
        mouseX <= pos.x+W+25 &&
        mouseY >= pos.y &&
        mouseY <= pos.y + textSize
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
      for(int i = 0 ; i < metadata.size();i++){
        JSONObject tmp = metadata.getJSONObject(i);
        text(tmp.getString("name")+": "+tmp.getString("value"),mouseX+W+25,mouseY+i*textSize);
      }

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

  Sequence(JSONObject _root, Project _parent){
    root = _root;
    parent = _parent;
    id = root.getString("id");
    name = name = root.getString("name");
    root = loadJSONObject("http://"+NARRA_URL+"/v1/projects/"+parent.name+"/sequences/"+id+"?token="+token).getJSONObject("sequence");
    marks = root.getJSONArray("marks");
  }
}

class Author{
  String id;
  String name;
};
