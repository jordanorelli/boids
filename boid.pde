float KEY_THRUST = 1.0;
color KEY_THRUST_COLOR = color(101, 45, 93);  // purple heart

float WALL_THRUST_DIST = 100.0;
float WALL_THRUST_MAX = 10.0;
color WALL_THRUST_COLOR = color(128, 70, 27); // russet

float SEPARATION_DIST = 50.0;
float SEPARATION_THRUST_MAX = 10.0;
color SEPARATION_COLOR = color(299, 97, 3); // cadmium orange

class Boid {
  Flock flock;
  PVector position;
  PVector velocity;
  PVector acceleration;
  PVector keyThrust;
  PVector wallThrust;
  PVector separationThrust;
  PVector thrust;
  float mass;
  float radius;
  boolean selected;
  
  Boid(Flock flock, float x, float y) {
    this.flock = flock;
    this.position = new PVector(x, y);
    this.velocity = new PVector(0, 0);
    this.acceleration = new PVector(0, 0);
    this.keyThrust = new PVector(0, 0);
    this.wallThrust = new PVector(0, 0);
    this.separationThrust = new PVector(0, 0);
    this.thrust = new PVector(0, 0);
    this.mass = 100;
    this.radius = 5.0;
    this.selected = false;
  }
  
  void draw() {
    stroke(0);
    strokeWeight(1);
    ellipse(this.position.x, this.position.y, 2.0 * this.radius, 2.0 * this.radius);
    this.drawKeyThrust();
    
    PVector v = this.velocity.get();
    v.normalize();
    v.mult(5);
    line(this.position.x, this.position.y, this.position.x + v.x, this.position.y + v.y);
  }
  
  void drawThrustVector(PVector v, color c) {
    if (!this.selected) {
      return;
    }
    if (v.mag() <= 0) {
      return;
    }
    strokeWeight(1);
    stroke(c);
    line(this.position.x, this.position.y, this.position.x + v.x * 20.0, this.position.y + v.y * 20.0);
  }
  
  void drawRadius(float r, color c) {
    if (!this.selected) {
      return;
    }
    strokeWeight(1);
    stroke(c);
    noFill();
    ellipse(this.position.x, this.position.y, 2.0 * r, 2.0 * r);
  }
  
  void drawKeyThrust() {
    this.drawThrustVector(this.keyThrust, KEY_THRUST_COLOR);
    this.drawThrustVector(this.wallThrust, WALL_THRUST_COLOR);
    this.drawThrustVector(this.separationThrust, SEPARATION_COLOR);
    this.drawRadius(SEPARATION_DIST, SEPARATION_COLOR);
  }
  
  void update() {
    this.acceleration.x = this.thrust.x / this.mass;
    this.acceleration.y = this.thrust.y / this.mass;
    this.velocity.add(this.acceleration);
    this.position.add(this.velocity);
    this.bounds();
    this.draw();
  }
  
  void bounds() {
    this.position.x = this.position.x < 0      ? 0      : this.position.x;
    this.position.x = this.position.x > width  ? width  : this.position.x;
    this.position.y = this.position.y < 0      ? 0      : this.position.y;
    this.position.y = this.position.y > height ? height : this.position.y;
  }
  
  void updateThrust() {
    this.thrust.mult(0);
    this.separate();
    this.repelWalls();
    thrust.add(this.keyThrust);
    thrust.add(this.wallThrust);
    thrust.add(this.separationThrust);
  }
  
  float wallForce(float dist) {
    if (dist > WALL_THRUST_DIST) {
      return 0;
    }
    if (dist < 0) {
      return WALL_THRUST_MAX;
    }
    float n = norm(dist, WALL_THRUST_DIST, 0);
    return WALL_THRUST_MAX * n * n * n;
  }

  void repelWalls() {
    this.wallThrust.x = wallForce(this.position.x) - wallForce(width - this.position.x);
    this.wallThrust.y = wallForce(this.position.y) - wallForce(height - this.position.y);
  }
  
  void separate() {
    this.separationThrust.x = 0;
    this.separationThrust.y = 0;
    for (Boid other : this.flock.boids) {
      float dist = PVector.dist(this.position, other.position);
      if (dist > SEPARATION_DIST) {
        continue;
      }
      PVector thrust = PVector.sub(this.position, other.position);
      thrust.normalize();
      dist = norm(dist, SEPARATION_DIST, 0);
      thrust.mult(10 * dist * dist);
      this.drawThrustVector(thrust, SEPARATION_COLOR);
      this.separationThrust.add(thrust);
    }
  }
  
  float separationForce(float dist) {
    return 5.0 * norm(dist, 0, SEPARATION_DIST);
  }
  
  void keyPressed(int code) {
    switch (code) {
    case UP:
      this.keyThrust.y -= KEY_THRUST;
      break;
    case DOWN:
      this.keyThrust.y += KEY_THRUST;
      break;
    case LEFT:
      this.keyThrust.x -= KEY_THRUST;
      break;
    case RIGHT:
      this.keyThrust.x += KEY_THRUST;
      break;
    }
  }
  
  void keyReleased(int code) {
    switch (code) {
    case UP:
      this.keyThrust.y += KEY_THRUST;
      break;
    case DOWN:
      this.keyThrust.y -= KEY_THRUST;
      break;
    case LEFT:
      this.keyThrust.x += KEY_THRUST;
      break;
    case RIGHT:
      this.keyThrust.x -= KEY_THRUST;
      break;
    }
  }
}
