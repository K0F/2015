//////////////////////////////////////////////////////
String token;
String NARRA_URL = "api.narra.eu";
///////////////////////////////////////////////////////

Test test;
Project project;

boolean DEBUG = true;
boolean LOAD_THUMBS = false;

void setup(){

  size(1024,576,P2D);

  token = loadStrings("token.txt")[0];

  test = new Test();
  project = new Project("faif");

  textFont(createFont("Monaco",9,false));

}


void draw(){
  background(255);


  project.draw();


}

class Test{
  String ip;
  String hash;

  Test(){
    ip = getIp();
    hash = getHash(ip);

    println("My ip is "+ip+" with MD5 hash "+hash);

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
    root = loadJSONObject("http://"+NARRA_URL+"/v1/projects/"+name+"/items?token="+token);

    if(DEBUG)
      println(root);

    parse();
  }

  void parse(){
    JSONArray _items = root.getJSONArray("items");
    items = new ArrayList();


    for(int i = 0 ; i < _items.size();i++){
      JSONObject tmp = _items.getJSONObject(i);
      items.add(new Item(tmp));
    }
  }

  void draw(){
    fill(0);
    text(name,10,10);
    for(int i = 0 ; i < items.size();i++){
      Item tmp= (Item)items.get(i);
      text(tmp.name+" --> "+tmp.id+", "+tmp.type+", "+tmp.url,20,20+i*10);
    }


  }

};

class Item{
  JSONObject data;
  String name;
  String audio_proxy;
  String video_proxy;
  String id;
  String type;
  String [] thumbnails;
  String url;
  ArrayList thumbs;

  Item(JSONObject _data){
    data=_data;
    parse();
  }

  void parse(){
    name = data.getString("name");
    type = data.getString("type");
    id = data.getString("id");

    if(type.equals("video")){
      url = data.getString("url");
      video_proxy = data.getString("video_proxy_hq");

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

}

class Author{};

class Graph{};
