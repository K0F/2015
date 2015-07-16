/* OpenProcessing Tweak of *@*http://www.openprocessing.org/sketch/92874*@* */
/* !do not delete the line above, required for linking your tweak if you upload again */
/* send text & image directly to the printer
 *
 * HOW TO:
 *********
 * everything related to printing is declared in the the tab printer
 *
 * METHODS:
 **********
 *
 * printText( String ) -> send a text to the printer
 *
 * printFrame() -> send to current frame to the printer
 * printFrame( boolean ) -> same as previous, but if you set the argument to false, the temporary image will not be deleted
 *
 * printImage( String ) -> print an image located in the data folder
 * printImage( String, boolean ) -> same as previous, but if you set the second argument to false, you can use absolute path
 * note: the temporary files prefix is "frame2print"; to change it, got to printer tab and set TEMPORARYFILE_PREFIX
 * note: this will not works with urls
 * 
 * the code below send 3 jobs to the printer: a text, an image and the current frame
 *
 * developped by frankiezafe@gmail.com / www.frankiezafe.net
 */


void setup() {

  size(144,630,P2D);
  //oop();

  //printText( "Automatic text & image printing procedure with processing.\n" +
  //"*****************************************\n\n" +
  //"The default system printer will be used." );

  // printImage( "bercage-desktop.png" );
}

void draw() {

  background( 255 );
  stroke(0);

  for(int i = 1 ; i<height;i++){
    float x = noise(i-1/10.0+frameCount/100.0)*100 + 145/2.0;
    float x2 = noise(i/10.0+frameCount/100.0)*100 + 145/2.0;
    line(x,i-1,x2,i);
  }

  if(frameCount%200==0)
  printFrame(true);

}
