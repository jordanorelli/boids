Flock flock;
HashMap keyState;
boolean mouseDown = false;

void setup() {
  size(1440, 900, P2D);
  keyState = new HashMap();
  flock = new Flock();  
  float n = 360.0;
  float t = TWO_PI / n;
  float flockWidth = 100.0;
//  for (int i = 0; i < n; i++) {
//    float x = width * 0.5 + flockWidth * cos(float(i) * t);
//    float y = height * 0.5 + flockWidth * sin(float(i) * t);
//    x = random(20, width - 20);
//    y = random(20, height - 20);
//    Boid boid = new Boid(flock, x, y);
//    boid.velocity.x = random(-3, 3);
//    boid.velocity.y = random(-3, 3);
//    flock.addBoid(boid);
//  }
}

void draw() {
  background(255);
  if (flock.boids.size() < 0) {
      Boid boid = new Boid(flock, width * 0.5, height * 0.5);
      boid.velocity.x = random(-3, 3);
      boid.velocity.y = random(-3, 3);
      flock.addBoid(boid);
  }
  if (mousePressed) {
      Boid boid = new Boid(flock, mouseX, mouseY);
      boid.velocity.x = random(-3, 3);
      boid.velocity.y = random(-3, 3);
      flock.addBoid(boid);
  }
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

