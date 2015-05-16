//////////////////////////////////////////////////////
String token;
String NARRA_URL="172.20.10.2";
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

  token = loadStrings("token.txt")[0];

  if(ONLINE)
    project = new Project("faif");
  else
    project = new Project(filename);

  textFont(createFont("Inconsolata",textSize,true));
}

void draw(){
  background(255);
  project.draw();
}

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

class Project{

  JSONObject root;
  String name;
  ArrayList items;

  Project(String _name){
    name = _name;
    if(ONLINE)
      root = loadJSONObject("http://"+NARRA_URL+"/v1/projects/"+name+"/items?token="+token);
    else
      root = loadJSONObject(name);

    parse();

    if(DEBUG)
      println(root);
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
        mouseX <= pos.x+W+10 &&
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

    fill(#fafafa);
    stroke(0,10);
    rect(pos.x-5,pos.y-1,W+25,textSize+5);
    fill(0,120);
    text(name,pos.x,pos.y+textSize);
  }
}

class Library{
  String id;
  String name;

};

class Author{
  String id;
  String name;
};
