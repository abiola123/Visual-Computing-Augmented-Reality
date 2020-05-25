import java.util.Collections;
PImage img;
PImage img1;
private float lowerBound = 105;
private float upperBound = 135;
private int treshold = 1;
final int regionLength = 1000;
final int N = 3;

void settings() {
size(1600, 400);
}
void setup() {  
img = loadImage("board1.jpg");
img.resize(img.width*2/3, img.height*2/3);
img1 = loadImage("hough_test.bmp");

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
BlobDetection blob = new BlobDetection();
PImage res;

res = transformToHueMap(img,lowerBound,upperBound);

res = threshold(res, treshold);

//res = gaussianBlur(res);
PImage edgeDetec;
PImage blobDetec;
edgeDetec = res;//gaussianBlur(res);

res = blob.findConnectedComponents(res,true); 
//image(edge, img.width, 0);

edgeDetec = blob.findConnectedComponents(edgeDetec,true);
blobDetec = edgeDetec;
res = scharr(res);
edgeDetec = scharr(res);
//res = threshold(res, treshold);

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
image(edgeDetec, img.width, 0);
image(blobDetec, img.width * 2, 0);
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
    int n_half = 10; // correspond à int(N/2) avec N =3
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
  
int n_half = 1;
for(int x = n_half; x<img.width-n_half;x++) {
  for(int y = n_half; y<img.height-n_half; y++) {    
     // correspond à int(N/2) avec N =3
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
//***
//* TRY TO TUNE ME! **
//* TRY TO TUNE ME! **
//* TRY TO TUNE ME! **
//***
//...............,´¯`,
float discretizationStepsPhi = 0.02f; //.........,´¯`,..../
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
