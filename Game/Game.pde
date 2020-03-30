  /*topView.background(0,120,150);
  topView.fill(255,0,0);
  topView.ellipse(50, 50, 50, 50);
  topView = createGraphics(110,110);
  topView.ellipse(50, 50, 50, 50);
  image(topView, 0, 400);*/
PGraphics gameSurface;
PGraphics background;
PGraphics topView;
PGraphics scorePanel;

float total_score = 0;
float last_score = 0;
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
boolean initialized = false;
PShape vilain;
ParticleSystem system;

 private final float cylinderBaseSize = 15;



void settings() {
size(500, 500, P3D);
}







void setup() {
//gameSurface.noStroke();
vilain = loadShape("robotnik.obj");
gameSurface = createGraphics(width,height-100,P3D);
background = createGraphics(width,100);
topView = createGraphics(100,100);
scorePanel = createGraphics(90,90);
}

void drawBackGround() { 
  background.beginDraw();
  background.background(200,200,200);
  background.endDraw();

}

void drawScorePanel() {
  scorePanel.beginDraw();
  scorePanel.background(170,170,170);
  
  scorePanel.fill(0,0,0);
  scorePanel.textSize(10);
  scorePanel.text("Total score:",5,10);
  scorePanel.text(total_score,5,22);
  
  
  scorePanel.text("Velocity:",5,40);
  scorePanel.text((float)Math.sqrt(velocity.dot(velocity)),5,52);
  
  scorePanel.text("Last Score:",5,70);
  scorePanel.text(last_score,5,82);
  
  scorePanel.endDraw();

}

void drawTopView() {
  topView.beginDraw();
  topView.background(0,130,170);
  
  if(initialized) {
    for(Cylinder c : system.particles.keySet()) {
     float[] f = system.particles.get(c);
     if(f[0] == system.origin.x && f[1] == system.origin.y) {
       topView.fill(255,0,0);
       topView.ellipse(50 + f[0]/2, 50 + f[1]/2, cylinderBaseSize, cylinderBaseSize);
     }
     else {
     topView.fill(255,255,255);
     topView.ellipse(50 + f[0]/2, 50 + f[1]/2, cylinderBaseSize, cylinderBaseSize);
     }
    }
    
  }
   //topView.fill(255,0,0);
   //topView.ellipse(50 + sphereLocation.x/2, 50 -sphereLocation.z/2, sphereRadius+3, sphereRadius+3);
   topView.fill(0,0,255);
   topView.ellipse(50 + sphereLocation.x/2,50 -sphereLocation.z/2, sphereRadius, sphereRadius);
  //topView.ellipse(50,50,20,20);
  topView.endDraw();
}

void drawGame() {
  gameSurface.beginDraw();
    gameSurface.noStroke();
  Cylinder c = new Cylinder();
  
  gameSurface.background(255, 255, 255);
  //gameSurface.camera(width/2, height/2, 450, 250, 250, 0, 0, 1, 0);
  double y_degrees = degrees(theta);
  double x_degrees = degrees(phi);
  gameSurface.pushStyle();
  gameSurface.textSize(20);
  gameSurface.fill(255, 0, 0);
  gameSurface.text("X-rotation: " + x_degrees, 10, 30);
  gameSurface.fill(0,255, 0);
  gameSurface.text("Y-rotation: " + y_degrees, 10, 50);
  
  gameSurface.fill(0,0,255);
  gameSurface.text("Speed: " + constant, 10, 70);
  gameSurface.pushMatrix();
  gameSurface.translate(height/2, width/2, 0);
  gameSurface.popStyle();
  
  if(!mode_shift) {
    gameSurface.rotateX(phi);
    gameSurface.rotateZ(theta);
  } else {
    gameSurface.rotateX(-PI/2);
  }

   gameSurface.stroke(0,255,0);
   gameSurface.line(0,-width/4,0,0,width/4,0);
   gameSurface.stroke(255,0,0);
   gameSurface.line(-height/3,0,0,height/3,0,0);
   gameSurface.stroke(0,0,255);
   gameSurface.line(0,0,-width/3,0,0,width/3);
   gameSurface.fill(150, 150, 150);
   gameSurface.box(boxSize, 10, boxSize);


   if(initialized) {
     if(frameCount%50==0 && !mode_shift){
     system.addParticle();
     }
     gameSurface.pushMatrix();
     gameSurface.rotateX(PI/2);
     gameSurface.translate(system.origin.x, system.origin.y);
     gameSurface.rotateX(PI/2);
     gameSurface.rotateY(PI);
     gameSurface.shape(vilain, 0, 0, 100, 100);
     gameSurface.popMatrix();
     for(Cylinder d : system.particles.keySet()) {
     float[] f = system.particles.get(d);
     gameSurface.pushMatrix();
     gameSurface.rotateX(PI/2);
     gameSurface.translate(f[0],f[1],0);
     
     for(int i = 0 ; i<c.arguments.length;i++) {
        gameSurface.pushStyle();
   
        gameSurface.shape(d.arguments[i]);
        gameSurface.popStyle();
     }
     gameSurface.popMatrix();
   }
   system.run();
   //pushMatrix();
   //rotateZ(PI);
   //translate();
   //shape(vilain, system.origin.y, 0, 100, 100);
   //popMatrix();
   }

   updateSphere();

   gameSurface.popMatrix();

   gameSurface.pushMatrix();
   gameSurface.translate(mouseX, mouseY, 0);
   if(mode_shift) {
      for(int i = 0 ; i<c.arguments.length;i++) {
      //fill(150,150,150);
      gameSurface.shape(c.arguments[i]);
      }
   }

   gameSurface.popMatrix();
   gameSurface.endDraw();

}







void draw() {
  drawGame();  
  image(gameSurface,0,0);
  drawBackGround();
  image(background,0,height -100);
  drawTopView();
  image(topView, 0, height - 100);
  drawScorePanel();
  image(scorePanel,120,height-90);
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
  /*for(float[] f : cylinders.values()) {
    float distance = (float)Math.sqrt((x-f[0])(x-f[0]) + (y-f[1])(y-f[1]));
    if(distance<2*cylinderBaseSize) placable = false;  
  }  */

  //compute the distance with the ball and check if there is going to be an overlapping
  PVector center = new PVector(x, 0,  -y);
  float distance = PVector.dist(center, sphereLocation);
  if(distance<(cylinderBaseSize+sphereRadius)) placable =false;

  if(placable) {
   system = new ParticleSystem(new PVector(x,y));
   initialized = true;
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
 gameSurface.pushStyle();
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
gameSurface.translate(sphereLocation.x, -15 - sphereLocation.y, -sphereLocation.z);
gameSurface.sphere(10);
gameSurface.fill(255, 0, 0);
checkEdges();

 gameSurface.popStyle();


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

void decraseScore() {
  total_score -= 10;
  last_score = -10;
}

void increaseScore() {
  last_score = (float)(5 * Math.sqrt(velocity.dot(velocity)));
  total_score += last_score;
  
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

Cylinder checkCylinderCollision() {
  Cylinder cylinder = null;
  for(Cylinder d: system.particles.keySet()) {
    float[] c = system.particles.get(d);
    PVector center = new PVector(c[0], 0,  -c[1]); //cela n'a aucun sens mais ça fonctionne
    if(PVector.dist(center, sphereLocation) <= cylinderBaseSize + sphereRadius) {
      sphereLocation.sub(velocity);
      PVector n = (PVector.sub(sphereLocation, center)).normalize();
      velocity = PVector.sub(velocity, n.mult(2 * PVector.dot(velocity,n)));
      cylinder =  d;
    }
  }
  return cylinder;
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

// A class to describe a group of Particles
class ParticleSystem { 
HashMap<Cylinder,float[]> particles;
PVector origin;


ParticleSystem(PVector origin) {
particles = new HashMap<Cylinder,float[]>();
float[] point = {origin.x, origin.y};
this.origin = origin.copy();
particles.put(new Cylinder(), point);
}

void addParticle() {
PVector center;
int numAttempts = 100;
ArrayList<Cylinder> list = new ArrayList<Cylinder>(particles.keySet());
for(int i=0; i<numAttempts; i++) {
// Pick a cylinder and its center.
int index = int(random(list.size()));
//println(particles);
float[] point = particles.get(list.get(index));
center = new PVector(point[0], point[1]);
// Try to add an adjacent cylinder.
float angle = random(TWO_PI);
center.x += sin(angle) * 2*cylinderBaseSize;
center.y += cos(angle) * 2*cylinderBaseSize;
if(checkPosition(center)) {
  float[] tab = {center.x, center.y};
particles.put(new Cylinder(), tab);
decraseScore();
break;
}
}
}

// Iteratively update and display every particle,
// and remove them from the list if their lifetime is over. 

// Check if a position is available, i.e.
// - would not overlap with particles that are already created
// (for each particle, call checkOverlap())
// - is inside the board boundaries
boolean checkPosition(PVector center) {
  float allowed_limit = boxSize/2.0 - sphereRadius;
  float x = center.x;
  float y = center.y;
  //println("(x,y) = (" + x + "," + y + ")");
  PVector c1 = new PVector(center.x, 0,  -center.y); //cela n'a aucun sens mais ça fonctionne
  if((x>allowed_limit)||(y>allowed_limit) || (x<-allowed_limit)||(y<-allowed_limit) || PVector.dist(c1, sphereLocation) <= cylinderBaseSize + sphereRadius) {
    return false;
  }
for(Cylinder c : particles.keySet()) {
  float[] point = particles.get(c);
  if(!checkOverlap(center, new PVector(point[0], point[1]))) {
    return false;
  }
}
return true;
}

// Check if a particle with center c1
// and another particle with center c2 overlap.
boolean checkOverlap(PVector c1, PVector c2) {
return PVector.dist(c1, c2) >= 2*cylinderBaseSize;
}

void run() {
  Cylinder c = checkCylinderCollision();
  if(c != null) {
    if(particles.get(c)[0] == origin.x && particles.get(c)[1] == origin.y) {
      initialized = false;
    }
    else {
    increaseScore();
    particles.remove(c);  
    }  
}
}
}
