Boid boid;
HashMap keyState;

void setup() {
  size(500, 500);
  keyState = new HashMap();
  boid = new Boid(width * 0.5, height * 0.5);
}

void draw() {
  background(255);
  boid.update();
}

void keyPressed() {
  if (keyState.containsKey(keyCode) && (Boolean)keyState.get(keyCode)) {
    return;
  }
  keyState.put(keyCode, true);
  boid.keyPressed(keyCode);
}

void keyReleased() {
  keyState.put(keyCode, false);
  boid.keyReleased(keyCode);
}
