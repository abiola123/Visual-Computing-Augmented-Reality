float theta = 0;
float phi = 0;
float constant = 0.02;
PVector gravityForce = new PVector();
PVector velocity = new PVector();
PVector friction = new PVector();
PVector acceleration = new PVector();
PVector sphereLocation = new PVector();
static final float gravityConstant = 0.1;
static final float sphereRadius = 10;


void settings() {
size(500, 500, P3D);
}
void setup() {
//  frameRate(10);
noStroke();
}
void draw() {
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
translate(height/2, width/2, 0);
rotateX(phi);
rotateZ(theta);
stroke(0,255,0);
   line(0,-width/4,0,0,width/4,0);
   stroke(255,0,0);
   line(-height/3,0,0,height/3,0,0);
   stroke(0,0,255);
   line(0,0,-width/3,0,0,width/3);
fill(150, 150, 150);
box(200, 10,200);
updateSphere();
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
friction.mult(frictionMagnitude);
acceleration = gravityForce.copy();
acceleration.add(friction);
velocity.add(acceleration);
sphereLocation.add(velocity);
fill(255, 0, 0);
translate(sphereLocation.x, -15 - sphereLocation.y, -sphereLocation.z);
sphere(10);
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
