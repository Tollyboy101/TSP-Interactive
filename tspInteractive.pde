int nCities = 5;

int[] order = new int[nCities];

long totalPermutations;
int count = 1;

//PVector[] cities = new PVector[0];
ArrayList<PVector> cities = new ArrayList<PVector>();

float recordDistance;
int[] bestEver = new int[nCities];

boolean start = false;

PVector[] v = new PVector[nCities];

long factorial(int n) {
  if (n == 1) {
    return 1;
  } else {
    return n * factorial(n-1);
  }
}  

void swap(PVector[] a, int i, int j) {
  PVector temp = a[i];
  a[i] = a[j];
  a[j] = temp;
}
void swap(int[] a, int i, int j, boolean ye) {
  int temp = a[i];
  a[i] = a[j];
  a[j] = temp;
}

float calcDistance(ArrayList<PVector> points, int[] order) {
  float sum = 0;
  for (int i = 0; i < order.length-1; i++) {
    int cityAIndex = order[i];
    PVector cityA = points.get(cityAIndex);
    int cityBIndex = order[i+1];
    PVector cityB = points.get(cityBIndex);
    float d = dist(cityA.x, cityA.y, cityB.x, cityB.y);
    sum += d;
  }
  return sum;
}

void mouseClicked() {
  if (cities.size() < nCities) {
    cities.add(new PVector(mouseX, mouseY));
  } else if (cities.size() == nCities) {
    start = true;
  }
}

void setup() {
  size(800, 800);

  for (int i = 0; i < nCities; i++) {
    order[i] = i;
  }

  arrayCopy(order, bestEver);
  totalPermutations = factorial(nCities);
}


void draw() {
  background(0);
  if (start == false) {
    for (int i = 0; i < cities.size(); i++) {
      circle(cities.get(i).x, cities.get(i).y, 12);
    }
  }
  if (count == 2) {
    float d = calcDistance(cities, order);
    recordDistance = d; 
  }
  
  if (start) { 
    stroke(255);
    strokeWeight(2);
    noFill(); 
    beginShape();
    for (int i = 0; i < cities.size(); i++) {
      int n = order[i];
      circle(cities.get(n).x, cities.get(n).y, 12);
      vertex(cities.get(n).x, cities.get(n).y);
    }
    endShape();

    stroke(255, 128, 255);
    strokeWeight(6);
    noFill();
    beginShape();
    for (int i = 0; i < order.length; i++) {
      int n = bestEver[i];
      vertex(cities.get(n).x, cities.get(n).y);
    }
    endShape();

    float d = calcDistance(cities, order);
    if (d < recordDistance) {
      recordDistance = d; 
      arrayCopy(order, bestEver);
    }

    textSize(32);
    float percentage = ((float)count/(float)totalPermutations)*100;
    text(nf(percentage, 1, 2) + "% Completed", 20, height-20);
    text("Possible Permutations: "+totalPermutations, 20, 40);

    nextOrder(order);
  }
}

void nextOrder(int[] order) {
  count++;
  int largestI = -1;
  for (int i = 0; i < order.length-1; i++) {
    if (order[i] < order[i+1]) {
      largestI = i;
    }
  }
  if (largestI == -1) {
    noLoop();
    print("\nFinished");
  }

  if (largestI != -1) {
    int largestJ = -1;
    for (int j = 0; j < order.length; j++) {
      if (order[largestI] < order[j]) {
        largestJ = j;
      }
    }

    swap(order, largestI, largestJ, true);


    int size = order.length - largestI - 1;
    int[] endArray = new int[size];

    arrayCopy(order, largestI +1, endArray, 0, size); 

    endArray = reverse(endArray);
    arrayCopy(endArray, 0, order, largestI +1, size);
  }
}
