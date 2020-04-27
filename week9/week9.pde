import java.util.ArrayList;
import java.util.List;
import java.util.TreeSet;
class BlobDetection {
PImage findConnectedComponents(PImage input, boolean onlyBiggest){
// First pass: label the pixels and store labels' equivalences
int [] labels = new int [input.width*input.height];
List<TreeSet<Integer>> labelsEquivalences = new ArrayList<TreeSet<Integer>>();
int currentLabel = 1;
//pixels = 
// TODO!
    //println(input.width);
    //println(input.height);
for(int y = 0; y < input.height; ++y) {
for(int x = 0; x < input.width; ++x) {
  
  //println("(x,y) : (" + x + "," + y + ")");
  int i = y * input.width + x;
  boolean top = y > 0; //these booleans check if the pixel is on a border to avoid array out of bounds 
  boolean left = x >= 1;
  boolean right = x < input.width - 1;
  if(input.pixels[i] == color(255, 255, 255)) {
  //println(labels[50]);
  if(!top) {
    if(left && labels[i - 1] != 0) {
      labels[i] = labels[i - 1];
    }
    else {
    labelsEquivalences.add(new TreeSet<Integer>());
    labelsEquivalences.get(currentLabel - 1).add(currentLabel);
    labels[i] = currentLabel++;
    
}
  } else {
    ArrayList<Integer> neighbours = new ArrayList<Integer>();
    neighbours.add(labels[(y-1) * input.width + x]);//top
    if(left && right) {
      neighbours.add(labels[(y-1) * input.width + x - 1]);//top left 
      neighbours.add(labels[(y - 1) * input.width + x + 1]);//top right 
      neighbours.add(labels[y * input.width + x - 1]);//left
       
      }
      
    
    if(!left) {
      neighbours.add(labels[(y - 1) * input.width + x + 1]);//top right
      
    }
    if(!right) {
      neighbours.add(labels[(y-1) * input.width + x - 1]);//top left 
      neighbours.add(labels[y * input.width + x - 1]);//left
    }
    boolean defined = false; //becomes true if a neighbour is labeled 
    int value = 0; //to check if the neighbours have the same label
    boolean equals = true; //becomes false if the neighbours have different labels  
    int min = Integer.MAX_VALUE;
    
    for(int c: neighbours) {
     if(c != 0) { //check if the neighbour is labeled
       min = min(min,c);
       if(defined) {
       equals = equals && (c == value);
       }
       else {
         defined = true;
         value = c;
       }
     }
  }
    if(!defined) {
      labelsEquivalences.add(new TreeSet<Integer>());
      labelsEquivalences.get(currentLabel - 1).add(currentLabel);
      labels[i] = currentLabel++; //neighbours are not labeled
    }
    else {
      labels[i] = min;
    if(!equals) {
        for(int c: neighbours) {
          if(c != 0 && c!= min) {labelsEquivalences.get(c-1).add(min);} //add to equivalent classes the smallest label of the neighbourhood
        } 
      }
      
    }
  }
  }
}
//println(labels);
}


// Second pass: re-label the pixels by their equivalent class
for(int j = 0; j < labels.length; ++j) {
  if(labels[j] != 0) {labels[j] = labelsEquivalences.get(labels[j] - 1).first();}
}
// if onlyBiggest==true, count the number of pixels for each label
// TODO!

int most_represented_label = 0;
if(onlyBiggest) {
  int[] nbPerLabel = new int[labelsEquivalences.size()]; //count the number of pixels for each label
  
  for(int j = 0; j < labels.length; ++j) {
     if(labels[j] != 0) {++nbPerLabel[labels[j] - 1];}
  }
  int max = -1;
  for(int j = 0; j < nbPerLabel.length; ++j) { //find the most represented label
    if(max < nbPerLabel[j]) {
      max = nbPerLabel[j];
      most_represented_label = j+1;
    }
  }
}
// Finally:
// if onlyBiggest==false, output an image with each blob colored in one uniform color
//int(random(list.size()))
if(!onlyBiggest) {
  color[] colors = new color[labelsEquivalences.size()];
  
  for(int j = 0; j < colors.length; ++j) {colors[j] = color(int(random(256)),int(random(256)),int(random(256)));} //define a color per label
   
   for(int j = 0; j < labels.length; ++j) {
     if(labels[j] != 0) {input.pixels[j] = colors[labels[j] - 1];}
   }
} else {// if onlyBiggest==true, output an image with the biggest blob in white and others in black
  for(int j = 0; j < labels.length; ++j) {
     if(labels[j] != 0) {
     input.pixels[j] = labels[j] == most_represented_label ? color(255,255,255) : color(0,0,0);
   }
}
}



return input;
}
}
PImage img;
void settings() {
size(500, 500, P2D);
}
void setup() {
background(255, 200, 0);
BlobDetection b = new BlobDetection();
img = b.findConnectedComponents(loadImage("BlobDetection_Test.png"), false);
frameRate(30);
}
void draw() {
 
image(img, 0, 0);
}
