class Mover { 
  
  
PVector location;
PVector velocity;
PVector gravity; 
final static int gravityConst = 3;
final static int radius = 24;

Mover() {
location = new PVector(width/2, height/2);
velocity = new PVector(0.5, 0.5);
gravity = new PVector(0, gravityConst);
}
void update() {
        velocity.add(gravity);
        location.add(velocity);
      }
   
void display() {
  stroke(0);
        strokeWeight(2);
        fill(127);
        ellipse(location.x, location.y, 2*radius, 2*radius);
}
void checkEdges() {
if (location.x > width-radius) {
          location.x = width-radius;
          velocity.x = velocity.x * -1;
        }
else if (location.x < radius) {
          location.x =radius;
          velocity.x = velocity.x * -1;
        }
if (location.y > height-radius) {
          location.y = height-radius;
          velocity.y = velocity.y * -1;
        }
else if (location.y < radius) {
          location.y = radius;
          velocity.y = velocity.y * -1;
        }
}
}
