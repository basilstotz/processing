/**
 * <p>Ketai Sensor Library for Android: http://KetaiProject.org</p>
 *
 * <p>Ketai Camera Features:
 * <ul>
 * <li>Interface for built-in camera</li>
 * <li></li>
 * </ul>
 * <p>Updated: 2012-03-10 Daniel Sauter/j.duran</p>
 */

import ketai.camera.*;

KetaiCamera cam;
int count;

void setup() {
  orientation(LANDSCAPE);
  imageMode(CENTER);
  cam = new KetaiCamera(this, width, height, 24);
  cam.manualSettings();
  //cam.setSaveDirectory("/mnt/emmc/");
  if (!cam.isStarted())
      { cam.start();
      }
}

void draw() {
  image(cam, width/2, height/2);
  if(count>0){count--;fill(255);rect(0,0,width,height);}
}

void onPause()
{
  super.onPause();
  //Make sure to releae the camera when we go
  //  to sleep otherwise it stays locked
  if (cam != null && cam.isStarted())
    cam.stop();
}

void onCameraPreviewEvent()
{
  cam.read();
}

void exit() {
  cam.stop();
}

// start/stop camera preview by tapping the screen
void mousePressed()
{
  cam.savePhoto();
  count=10;
  /*
    */
}
void keyPressed() {
  if (key == CODED) {
    if (keyCode == MENU) {
      if (cam.isStarted())
      {
        cam.stop();
      }
      else
        cam.start();

      //if (cam.isFlashEnabled())
      //  cam.disableFlash();
      //else
      //  cam.enableFlash();
    }
  }
}

