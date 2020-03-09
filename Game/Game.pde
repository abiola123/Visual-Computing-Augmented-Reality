float theta = 0;
float phi = 0;

void settings() {
size(500, 500, P3D);
}
void setup() {
noStroke();
}
void draw() {
background(255, 255, 255);
camera(width/2, height/2, 450, 250, 250, 0, 0, 1, 0);
translate(height/2, width/2, 0);
rotateZ(theta);
rotateX(phi);
stroke(0,255,0);
  line(0,-width/4,0,0,width/4,0);
   stroke(255,0,0);
   line(-height/3,0,0,height/3,0,0);
  
   stroke(0,0,255);
   line(0,0,-width/2,0,0,width/2);
fill(150, 150, 150);
box(200, 10,200);
}
void mouseDragged() 
{
  if(pmouseX - mouseX < 0) {
      if(theta < PI/3) {
      theta += 0.02;
      }
  }
  else if(pmouseX - mouseX > 0) {
    if(theta > -PI/3) {
      theta -= 0.02;
      }
  }
  
  if(pmouseY - mouseY < 0) {
    if(phi > -PI/3) {
    phi -= 0.02;
    }
  }
  else if(pmouseY - mouseY > 0) {
    if(phi < PI/3) {
    phi += 0.02;
    }
  }
  }
