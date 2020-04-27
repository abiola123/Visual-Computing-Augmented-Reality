PImage img;
private float lowerBound;
private float upperBound;
private double treshold;
final int N = 3;

void settings() {
size(1600, 600);
}
void setup() {  
img = loadImage("board1.jpg");

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
image(gaussianBlur(img),0,0);
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
