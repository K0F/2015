
import org.json.*;

String json;
String token;


void setup(){

  token = loadStrings("token.txt")[0];

  JSON obj = JSON.parse(loadStrings("http://api.narra.eu/v1/projects?token="+token)[0]);

  println( obj );
  println("//////////////////////////////");
  println(obj.getArray("projects"));
}


void draw(){




}
