Flock flock;
HashMap keyState;

void setup() {
  size(500, 500);
  keyState = new HashMap();
  flock = new Flock();  
  float n = 8.0;
  float t = TWO_PI / n;
  float flockWidth = 30.0;
  for (int i = 0; i < n; i++) {
    float x = width * 0.5 + flockWidth * cos(float(i) * t);
    float y = height * 0.5 + flockWidth * sin(float(i) * t);
    flock.addBoid(x, y);
  }
}

void draw() {
  background(255);
  flock.update();
}

void keyPressed() {
  if (keyState.containsKey(keyCode) && (Boolean)keyState.get(keyCode)) {
    return;
  }
  keyState.put(keyCode, true);
  flock.keyPressed(keyCode);
}

void keyReleased() {
  keyState.put(keyCode, false);
  flock.keyReleased(keyCode);
}
