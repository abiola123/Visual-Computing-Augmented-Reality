
public class Cylinder {

  private PShape openCylinder = new PShape();
  private PShape cover = new PShape();
  private PShape bottom = new PShape();


  private float cylinderHeight = 15;
  private int cylinderResolution = 40;


  PShape[] arguments = new PShape[3];
  public Cylinder(){
  float angle;
  float[] x = new float[cylinderResolution + 1];
  float[] y = new float[cylinderResolution + 1];
  //get the x and y position on a circle for all the sides
  for(int i = 0; i < x.length; i++) {
    angle = (TWO_PI / cylinderResolution) * i;
    x[i] = sin(angle) * cylinderBaseSize;
    y[i] = cos(angle) * cylinderBaseSize;
  }
  openCylinder = createShape();
  openCylinder.beginShape(QUAD_STRIP);
  //draw the border of the cylinder
  for(int i = 0; i < x.length; i++) {
    openCylinder.vertex(x[i], y[i] , 0);
    openCylinder.vertex(x[i], y[i], cylinderHeight);
  }
  openCylinder.endShape();
  

  cover = createShape();
  cover.beginShape(TRIANGLE_FAN);
  cover.vertex(0,0,cylinderHeight);
  for(int i = 0;i<x.length;i++) {
    cover.vertex(x[i],y[i],cylinderHeight);
  }
  cover.endShape();

  bottom = createShape();
  bottom.beginShape(TRIANGLE_FAN);
  bottom.vertex(0,0,0);
  for(int i = 0;i<x.length;i++) {
    bottom.vertex(x[i],y[i],0);
  }
  bottom.endShape();


  arguments[0] = openCylinder;
  arguments[1] = bottom;
  arguments[2] = cover;
  
  
  }
 

}
