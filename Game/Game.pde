float theta = 0;
float phi = 0;
float constant = 0.02;
static final int boxSize = 200;
PVector gravityForce = new PVector();
PVector velocity = new PVector();
PVector friction = new PVector();
PVector acceleration = new PVector();
PVector sphereLocation = new PVector();
static final float gravityConstant = 0.1;
static final float sphereRadius = 10;
boolean mode_shift = false;
HashMap<Cylinder,float[]> cylinders = new HashMap<Cylinder,float[]>();

 private final float cylinderBaseSize = 15;



void settings() {
size(500, 500, P3D);
}







void setup() {
noStroke();
}









void draw() {
  Cylinder c = new Cylinder();
  background(255, 255, 255);
  camera(width/2, height/2, 450, 250, 250, 0, 0, 1, 0);
  double y_degrees = degrees(theta);
  double x_degrees = degrees(phi);
  textSize(20);
  fill(255, 0, 0);
  text("X-rotation: " + x_degrees, 10, 30);
  fill(0,255, 0);
  text("Y-rotation: " + y_degrees, 10, 50);
  fill(0,0,255);
  text("Speed: " + constant, 10, 70);
  
  pushMatrix();
  translate(height/2, width/2, 0);
   
  if(!mode_shift) {
    rotateX(phi);
    rotateZ(theta);
  } else {
    rotateX(-PI/2);
  }
  
   stroke(0,255,0);
   line(0,-width/4,0,0,width/4,0);
   stroke(255,0,0);
   line(-height/3,0,0,height/3,0,0);
   stroke(0,0,255);
   line(0,0,-width/3,0,0,width/3);
    fill(150, 150, 150);
   box(boxSize, 10, boxSize);
   
   
   
    //rotateX(-PI/2+phi);
   //rotateZ(theta);
  //translate(-height/2, -width/2, 0);
   for(Cylinder d : cylinders.keySet()) {
     float[] f = cylinders.get(d);
     pushMatrix();
     rotateX(PI/2);
     translate(f[0],f[1],0);
     for(int i = 0 ; i<c.arguments.length;i++) {
        shape(d.arguments[i]);
     }
     popMatrix();
   } 
   
   updateSphere();
   
   popMatrix();
   
   pushMatrix();
   translate(mouseX, mouseY, 0);
   if(mode_shift) {
      for(int i = 0 ; i<c.arguments.length;i++) {
      shape(c.arguments[i]);
      }
   }
   
   popMatrix();

   
   
  
  
  
  
 
 
}


void mouseClicked(){
  if(mode_shift) {
   addCylinder();
  }


}



void addCylinder() {
  boolean placable = true;
  
  float x = mouseX-width/2.0;
  float y= mouseY-height/2.0; 
  
  float allowed_limit = boxSize/2.0 - sphereRadius;
  if((x>allowed_limit)||(y>allowed_limit)) placable = false;
  if((x<-allowed_limit)||(y<-allowed_limit)) placable = false;
    
  //compute distance with every cylinder and check if there is going to be an overlapping  
  for(float[] f : cylinders.values()) {
    float distance = (float)Math.sqrt((x-f[0])*(x-f[0]) + (y-f[1])*(y-f[1]));
    if(distance<2*cylinderBaseSize) placable = false;  
  }  
  
  //compute the distance with the ball and check if there is going to be an overlapping
  PVector center = new PVector(x, 0,  -y);
  float distance = PVector.dist(center, sphereLocation);
  if(distance<(cylinderBaseSize+sphereRadius)) placable =false;
  
  if(placable) {
   Cylinder c = new Cylinder(); 
   float[] f = {x,y};
   cylinders.put(c,f);
  } else { System.out.println("not placable"); }
}


void mouseDragged() 
{
  if(pmouseX - mouseX < 0) {
     float newValue = theta;
     newValue += constant;
     if(newValue > PI/3) {
      newValue = PI/3;
     }
     theta = newValue;
  }
  else if(pmouseX - mouseX > 0) {
     float newValue = theta;
     newValue -= constant;
     if(newValue < -PI/3) {
      newValue = -PI/3;
     }
     theta = newValue;
  }
  
  if(pmouseY - mouseY < 0) {
    float newValue = phi;
    newValue -= constant;
    if(newValue < -PI/3) {
      newValue = -PI/3;
    }
    phi = newValue;
  }
  else if(pmouseY - mouseY > 0) {
    float newValue = phi;
    newValue += constant;
    if(newValue > PI/3) {
     newValue = PI/3;
    }
    phi = newValue;
  }
 }
 
 
 
 
 
 
void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  if(e>0 && constant>0.01) {
     constant-=0.005;
  }
  
  if(e<0 && constant<0.1) {
    constant+=0.005;
  } 
}

void updateSphere() {

gravityForce.x = sin(theta) * gravityConstant;
gravityForce.z = sin(phi) * gravityConstant;

float normalForce = 1;
float mu = 0.01;
float frictionMagnitude = normalForce * mu;
friction = velocity.copy();
friction.mult(-1);
friction.normalize();

if(!mode_shift) {
friction.mult(frictionMagnitude);
acceleration = gravityForce.copy();
acceleration.add(friction);
velocity.add(acceleration);
sphereLocation.add(velocity);
}
translate(sphereLocation.x, -15 - sphereLocation.y, -sphereLocation.z);
sphere(10);
fill(255, 0, 0);
checkCylinderCollision();
checkEdges();


}

void checkEdges() {
if (sphereLocation.x >  100-sphereRadius) {
         sphereLocation.x =  100-sphereRadius;
          velocity.x = velocity.x * -1;
        }
else if (sphereLocation.x <  -100+sphereRadius) {
          sphereLocation.x = -100+sphereRadius;
          velocity.x = velocity.x * -1;
        }
if (sphereLocation.z >  100-sphereRadius) {
          sphereLocation.z=  100-sphereRadius;
          velocity.z = velocity.z * -1;
        }
else if (sphereLocation.z < -100+sphereRadius) {
         sphereLocation.z =  -100+ sphereRadius;
          velocity.z = velocity.z * -1;
        }

}

void keyPressed() {
  if (keyCode == SHIFT) {
  mode_shift = true;
  }
  
}

void keyReleased() {
   if (keyCode == SHIFT) {
  mode_shift = false;
  }
}

void checkCylinderCollision() {
  for(float[] c: cylinders.values()) {
    PVector center = new PVector(c[0], 0,  -c[1]); //cela n'a aucun sens mais ça fonctionne
    if(PVector.dist(center, sphereLocation) <= cylinderBaseSize + sphereRadius) {
      sphereLocation.sub(velocity);
      PVector n = (PVector.sub(sphereLocation, center)).normalize();
      velocity = PVector.sub(velocity, n.mult(2 * PVector.dot(velocity,n)));
    }
  }
}



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
