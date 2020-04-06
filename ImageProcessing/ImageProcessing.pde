PImage img;
HScrollbar thresholdBar;
HScrollbar upperBoundBar;
HScrollbar lowerBoundBar;
private float lowerBound;
private float upperBound;
private double treshold;


void settings() {
size(1600, 600);
}
void setup() {  
img = loadImage("board1.jpg");
thresholdBar = new HScrollbar(0, 580, 800, 20);

//noLoop(); // no interactive behaviour: draw() will be called only once.
}

void draw() {
  
//black and white thresholding  
// treshold = 255*thresholdBar.getPos();
//image(threshold(img,(int)treshold), 0, 0);
//thresholdBar.display();
//thresholdBar.update();
//println(thresholdBar.getPos()); // getPos() returns a value between 0 and 1

//hue map thersholding
lowerBound = 255*lowerBoundBar.getPos();
upperBound = 255*upperBoundBar.getPos();
image(transformToHueMap(img,lowerBound,upperBound), 0, 0);
thresholdBar.display();
thresholdBar.update();
println(thresholdBar.getPos()); // getPos() returns a value between 0 and 1

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
    result.pixels[i] = img.pixels[k];
    }else {
    result.pixels[i] = color(0,0,0);
    }
}
return result;
}
