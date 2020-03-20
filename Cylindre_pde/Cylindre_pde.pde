float cylinderBaseSize = 50;
float cylinderHeight = 50;
int cylinderResolution = 40;
PShape openCylinder = new PShape();
PShape cover = new PShape();
PShape bottom = new PShape();
boolean mode_shift;

void settings() {
size(400, 400, P3D);
}


void setup() {
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
  
}

void draw() {
   background(255);
  translate(mouseX, mouseY, 0);
  shape(openCylinder);
  shape(cover);
  shape(bottom);
}

void keyPressed() {
  if (key == CODED) {
  if (keyCode == SHIFT) {
  System.out.println("h");
  mode_shift = !mode_shift;
  }
  }
}
