import java.util.Collections;
ImageProcessing imgproc;
TwoDThreeD twoDThreeD;
 
 
PGraphics gameSurface;
PGraphics background;
PGraphics topView;
PGraphics scorePanel;
PGraphics barChart; 


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
PImage img;

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
barChart = createGraphics(275,85);
System.loadLibrary(Core.NATIVE_LIBRARY_NAME);
imgproc = new ImageProcessing();
String []args = {"Image processing window"};
PApplet.runSketch(args, imgproc);
img = loadImage("board1.jpg");
twoDThreeD = new TwoDThreeD(img.width, img.height, 0);
}

void drawBarChart() {
  barChart.beginDraw();
  barChart.background(255,255,255);
  
  // scorePanel.fill(0,0,0);  
  barChart.endDraw();
  
  
// where getRotation could be a getter for the rotation angles you computed previously

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
  /*drawGame();  
  image(gameSurface,0,0);
  drawBackGround();
  image(background,0,height -100);
  drawTopView();
  image(topView, 0, height - 100);
  drawScorePanel();
  image(scorePanel,120,height-90);
  image(barChart, 220, height- 90 );
  drawBarChart();*/
  PVector rot = twoDThreeD.get3DRotations(getHomogenous(imgproc.quadDetection(img)));
  println(rot);
}

List<PVector> getHomogenous(List<PVector> list) {
  List<PVector> newList = new ArrayList<PVector>();
  for(PVector p : list) {
    newList.add(new PVector(p.x, p.y, 1));
  }
  return newList;
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









class ImageProcessing extends PApplet {
PImage img;
PImage img1;
private float lowerBound = 110;
private float upperBound = 135;
private int treshold = 1;
final int regionLength = 10;
final int N = 3;

void settings() {
size(1600, 600);
}
void setup() {  
//img = loadImage("board1.jpg");
//img1 = loadImage("hough_test.bmp");

//noLoop(); // no interactive behaviour: draw() will be called only once.
}

void draw() {
  
//black and white thresholding  
//treshold = 255*thresholdBar.getPos();
//image(threshold(img,(int)treshold), 0, 0);
//thresholdBar.display();
//thresholdBar.update();
//println(thresholdBar.getPos()); // getPos() returns a value between 0 and 1

//hue map thersholding


//println(thresholdBar.getPos()); // getPos() returns a value between 0 and 1


//image(convolute(img),0,0);

//image(convolute(img),0,0);

//image(gaussianBlur(img),0,0);
/*BlobDetection blob = new BlobDetection();
PImage res;
res = transformToHueMap(img,lowerBound,upperBound);
res = threshold(res, treshold);
//PImage
res = blob.findConnectedComponents(res,true);
res = gaussianBlur(res);
res = scharr(res);
PImage edgeDetec = res;
image(res, img.width, 0);
image(img,0,0);

//image(img1,0,0);
List<PVector> lines = hough(res, 10);
plot_lines(lines, res);
List<PVector> quads = new QuadGraph().findBestQuad(lines, img.width, img.height, img.width * img.height, img.width * img.height / 10, false);
for(PVector p : quads) {
  //fill(0);
  println("(x,y) = " + p.x + "," + p.y);
  fill(0);
  circle(p.x,p.y,20);
}
//ellipse(50,50,100,100);
//hough(img1);
//println(new QuadGraph().findBestQuad(lines, img.width, img.height, 5000, 0, false).size());
*/
}

List<PVector> quadDetection(PImage img) {
  BlobDetection blob = new BlobDetection();
PImage res;
res = transformToHueMap(img,lowerBound,upperBound);
res = threshold(res, treshold);
//PImage blobDetec = blob.findConnectedComponents(res,true);
res = blob.findConnectedComponents(res,true);
res = gaussianBlur(res);
res = scharr(res);
List<PVector> lines = hough(res, 10);
return new QuadGraph().findBestQuad(lines, img.width, img.height, img.width * img.height, img.width * img.height / 10, false);
}

PImage threshold(PImage img, int threshold){
// create a new, initially transparent, 'result' image
PImage result = createImage(img.width, img.height, RGB);
for(int i = 0; i < img.width * img.height; i++) {
    double k = brightness(img.pixels[i]);
    if(k<threshold){
      result.pixels[i] = color(0,0,0);
    } else {
      result.pixels[i] = color(255,255,255);
    }
}
return result;
}

PImage transformToHueMap(PImage img,float lowerBound,float upperBound) {
PImage result = createImage(img.width, img.height, RGB);

for(int i = 0 ; i<img.width*img.height;i++) {
    float hue = hue(img.pixels[i]);
    if(hue>=lowerBound && hue<=upperBound) {
    result.pixels[i] = img.pixels[i];
    }else {
    result.pixels[i] = color(0,0,0);
    }
}
return result;
}

PImage convolute(PImage img) {
float[][] kernel = { { 0, 0, 0 },
{ 0, 2, 0 },
{ 0, 0, 0 }};
float normFactor = 1.f;
// create a greyscale image (type: ALPHA) for output
PImage result = createImage(img.width, img.height, ALPHA);

// kernel size N = 3
//
// for each (x,y) pixel in the image:
// - multiply intensities for pixels in the range
// (x - N/2, y - N/2) to (x + N/2, y + N/2) by the
// corresponding weights in the kernel matrix
// - sum all these intensities and divide it by normFactor
// - set result.pixels[y * img.width + x] to this value

for(int x = 1; x<img.width-1;x++) {
  for(int y = 1; y<img.height-1; y++) {    
    int n_half = 1; // correspond à int(N/2) avec N =3
    float count= 0;
    for(int i=x-n_half; i<x+n_half; i++) {
      for(int j=y-n_half; j<y+n_half; j++) {
          // 
          count = brightness(img.pixels[j * img.width + i])* kernel[i-x+1][j-y+1];
      }
    }  
    float res =  count / normFactor;
    result.pixels[y*img.width + x] = color(res);
  }
} 
return result;
}

PImage gaussianBlur (PImage img){
  
 float[][] gaussianKernel = { { 9, 12, 9},
{ 12, 15, 12 },
{ 9, 12, 9 }};

float val = 0;


for (int t = 0; t< 3; t++){
  for (int q = 0; q<3; q++){
    val += (float) gaussianKernel[t][q];
  }
}
float normFactor = val;
// create a greyscale image (type: ALPHA) for output
PImage result = createImage(img.width, img.height, ALPHA);

for (int i = 0; i< img.width * img.height; i++){
  result.pixels[i]= color(0);
}
  

for(int x = 1; x<img.width-1;x++) {
  for(int y = 1; y<img.height-1; y++) {    
    int n_half = 1; // correspond à int(N/2) avec N =3
    float count= 0;
    for(int i=x-n_half; i<=x+n_half; i++) {
      for(int j=y-n_half; j<=y+n_half; j++) {
          // 
          count += brightness(img.pixels[j * img.width + i])* gaussianKernel[i-x+1][j-y+1];
      }
    }  
    float res =  count / normFactor;
    result.pixels[y*img.width + x] = color(res);
  }
} 
return result;
}

PImage scharr(PImage img) {

  float[][] vKernel = {
  { 3, 0, -3 },
  { 10, 0, -10 },
  { 3, 0, -3 } 
  };

  float[][] hKernel = {
  { 3, 10, 3 },
  { 0, 0, 0 },
  { -3, -10, -3 }
  };


PImage result = createImage(img.width, img.height, ALPHA);
// clear the image


for (int i = 0; i < img.width * img.height; i++) {
result.pixels[i] = color(0);
}

float max=0;
float[] buffer = new float[img.width * img.height];

for(int x = 1; x<img.width-1;x++) {
  for(int y = 1; y<img.height-1; y++) {    
    int n_half = 1; // correspond à int(N/2) avec N =3
    float sumH= 0;
    float sumV = 0;
    
        for(int i=-n_half; i<=n_half; i++) {
      for(int j=-n_half; j<=n_half; j++) {
          sumV += brightness(img.pixels[(y+j)* img.width + (x+i)])* vKernel[i+1][j+1];
          sumH += brightness(img.pixels[(y+j)* img.width + (x+i)])* hKernel[i+1][j+1];
      }
    }  

float euclidianDist = sqrt(pow(sumV, 2) + pow(sumH, 2));
buffer[y *img.width + x]= euclidianDist;
max = euclidianDist > max ? euclidianDist : max;
    }
 }
 
 
for (int y = 1; y < img.height - 1; y++) { // Skip top and bottom edges
for (int x = 1; x < img.width - 1; x++) { // Skip left and right
int val=(int) ((buffer[y * img.width + x] / max)*255);
result.pixels[y * img.width + x]=color(val);

}
}
result.updatePixels();
return result;
}

   //PImage houghImg = createImage(rDim, phiDim, ALPHA);
   
   
/*for (int i = 0; i < accumulator.length; i++) {
        houghImg.pixels[i] = color(min(255, accumulator[i]));
    }
    // You may want to resize the accumulator to make it easier to see:
    // houghImg.resize(400, 400);
    houghImg.updatePixels();*/


List<PVector> hough(PImage edgeImg, int nLines) {
//*********
//** TRY TO TUNE ME! *****
//** TRY TO TUNE ME! *****
//** TRY TO TUNE ME! *****
//*********
//...............,´¯`,
float discretizationStepsPhi = 0.01f; //.........,´¯`,..../
float discretizationStepsR = 1.5f; //....../¯/.../..../
int minVotes=50; //..../../.../..../..,-----,
//../../.../....//´...........`.
//./../.../..../......../´¯\....\
//('.('..('....('.......|.....'._.'
//.\....................`\.../´...)
//...\.....................V...../
//.....\........................./
//.......`•...................•´
//..........|.................|
// dimensions of the accumulator
int phiDim = (int) (Math.PI / discretizationStepsPhi +1);
//The max radius is the image diagonal, but it can be also negative
int rDim = (int) ((sqrt(edgeImg.width*edgeImg.width +
edgeImg.height*edgeImg.height) * 2) / discretizationStepsR +1);
// our accumulator
int[] accumulator = new int[phiDim * rDim];
// Fill the accumulator: on edge points (ie, white pixels of the edge
// image), store all possible (r, phi) pairs describing lines going
// through the point.
for (int y = 0; y < edgeImg.height; y++) {
for (int x = 0; x < edgeImg.width; x++) {
// Are we on an edge?
if (brightness(edgeImg.pixels[y * edgeImg.width + x]) != 0) {
  float angle = 0;
  for(int phi = 0; phi < phiDim; phi ++, angle +=discretizationStepsPhi ) {
    float r = x * cos(angle) + y * sin(angle);
    int index = (int) (r/discretizationStepsR + rDim/2);
    accumulator[ phi * rDim + index] += 1;//x · cos(ϕ) + y · sin(ϕ)

  }
// ...determine here all the lines (r, phi) passing through
// pixel (x,y), convert (r,phi) to coordinates in the
// accumulator, and increment accordingly the accumulator.
// Be careful: r may be negative, so you may want to center onto
// the accumulator: r += rDim / 2
}
}
}
ArrayList<PVector> lines=new ArrayList<PVector>();
ArrayList<Integer> bestCandidates = new ArrayList<Integer>();
for (int idx = 0; idx < accumulator.length; idx++) {
if (accumulator[idx] > minVotes) {
// first, compute back the (r, phi) polar coordinates:
boolean biggest = true;

int lower_bound = ((idx - regionLength/2) % rDim > idx % rDim) ? idx : max(idx - regionLength/2,0);
int upper_bound = (((idx + regionLength/2) % rDim < idx % rDim) ? idx : min(idx + regionLength/2,accumulator.length)); //conditions sur les bordures pour séléctionner les voisins de la ligne
boolean top = idx - lower_bound - rDim >= 0; //conditions sur les lignes d'au dessus et d'en dessous
boolean bottom = idx + rDim + upper_bound < accumulator.length; 

for(int i = lower_bound; i < upper_bound && biggest; ++i) { 
 biggest = biggest && accumulator[idx] >= accumulator[i];
 if(top) {
  biggest = biggest &&  accumulator[idx] >= accumulator[i - rDim];
 }
 if(bottom) {
   biggest = biggest &&  accumulator[idx] >= accumulator[i + rDim];
 }
}
if(biggest) {
bestCandidates.add(idx);
}

/*// first, compute back the (r, phi) polar coordinates:
int accPhi = (int) (idx / (rDim));
int accR = idx - (accPhi) * (rDim);
float r = (accR - (rDim) * 0.5f) * discretizationStepsR;
float phi = accPhi * discretizationStepsPhi;
lines.add(new PVector(r,phi));*/
}
}
Collections.sort(bestCandidates, new HoughComparator(accumulator));
for(int i = 0; i < min(nLines,bestCandidates.size()); ++i) {
int idx = bestCandidates.get(i);
int accPhi = (int) (idx / (rDim));
int accR = idx - (accPhi) * (rDim);
float r = (accR - (rDim) * 0.5f) * discretizationStepsR;
float phi = accPhi * discretizationStepsPhi;
lines.add(new PVector(r,phi));
}

PImage houghImg = createImage(rDim, phiDim, ALPHA);
for (int i = 0; i < accumulator.length; i++) {
houghImg.pixels[i] = color(min(255, accumulator[i]));
}
// You may want to resize the accumulator to make it easier to see:
houghImg.resize(400, 400);
houghImg.updatePixels();
//image(houghImg,0,0);
//plot_lines(lines, houghImg);
return lines;
}

void plot_lines(List<PVector> lines, PImage edgeImg) {
  for (int idx = 0; idx < lines.size(); idx++) {
PVector line=lines.get(idx);
float r = line.x;
float phi = line.y;
// Cartesian equation of a line: y = ax + b
// in polar, y = (-cos(phi)/sin(phi))x + (r/sin(phi))
// => y = 0 : x = r / cos(phi)
// => x = 0 : y = r / sin(phi)
// compute the intersection of this line with the 4 borders of
// the image
int x0 = 0;
int y0 = (int) (r / sin(phi));
int x1 = (int) (r / cos(phi));
int y1 = 0;
int x2 = edgeImg.width;
int y2 = (int) (-cos(phi) / sin(phi) * x2 + r / sin(phi));
int y3 = edgeImg.width;
int x3 = (int) (-(y3 - r / sin(phi)) * (sin(phi) / cos(phi)));
// Finally, plot the lines
stroke(204,102,0);
if (y0 > 0) {
if (x1 > 0)
line(x0, y0, x1, y1);
else if (y2 > 0)
line(x0, y0, x2, y2);
else
line(x0, y0, x3, y3);
}
else {
if (x1 > 0) {
if (y2 > 0)
line(x1, y1, x2, y2);
else
line(x1, y1, x3, y3);
}
else
line(x2, y2, x3, y3);
}
}

}
}
