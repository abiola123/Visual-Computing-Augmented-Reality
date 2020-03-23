ParticleSystem pSystem;

void setting(){
  size(500,200);
}

void setup(){
  frameRate(100);
  pSystem = new ParticleSystem(new PVector(width/2, height/2));
}

void draw(){
  background(0);
  
  if (frameCount%10==0){
    pSystem.addParticle();
  }
  
  pSystem.run();
}
  
