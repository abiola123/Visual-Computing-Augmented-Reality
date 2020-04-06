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
