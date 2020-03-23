// A class to describe a group of Particles
class ParticleSystem { 
ArrayList<Particle> particles; 
PVector origin;
float particleRadius = 10;


ParticleSystem(PVector origin) {
this.origin = origin.copy();
particles = new ArrayList<Particle>(); particles.add(new Particle(origin, particleRadius));
}

void addParticle() {
PVector center;
center = origin.copy();
float angle = random(TWO_PI);
float radius = random(min(width, height)/2); center.x += sin(angle) * 2*radius;
        center.y += cos(angle) * 2*radius;
particles.add(new Particle(center, particleRadius)); }
// Iteratively update and display every particle,
// and remove them from the list if their lifetime is over. 

void run() {
  for (int i = particles.size()-1; i>-1; i--){
    Particle p = particles.get(i);
    p.run();
    if (p.isDead()) {
      particles.remove(i);
  }
}
}
}
