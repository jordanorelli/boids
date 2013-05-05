float KEY_THRUST = 1.0;
color KEY_THRUST_COLOR = color(101, 45, 93);  // purple heart
color WALL_THRUST_COLOR = color(128, 70, 27); // russet

class Boid {
  PVector position;
  PVector velocity;
  PVector acceleration;
  PVector keyThrust;
  PVector wallThrust;
  float mass;
  
  Boid(float x, float y) {
    this.position = new PVector(x, y);
    this.velocity = new PVector(0, 0);
    this.acceleration = new PVector(0, 0);
    this.keyThrust = new PVector(0, 0);
    this.wallThrust = new PVector(0, 0);
    this.mass = 100;
  }
  
  void draw() {
    stroke(0);
    strokeWeight(1);
    ellipse(this.position.x, this.position.y, 10, 10);
    this.drawKeyThrust();
    
    PVector v = this.velocity.get();
    v.normalize();
    v.mult(5);
    line(this.position.x, this.position.y, this.position.x + v.x, this.position.y + v.y);
  }
  
  void drawThrustVector(PVector v, color c) {
    if (v.mag() <= 0) {
      return;
    }
    strokeWeight(1);
    stroke(c);
    line(this.position.x, this.position.y, this.position.x + v.x * 20.0, this.position.y + v.y * 20.0);
  }
  
  void drawKeyThrust() {
    this.drawThrustVector(this.keyThrust, KEY_THRUST_COLOR);
    this.drawThrustVector(this.wallThrust, WALL_THRUST_COLOR);
  }
  
  void update() {
    PVector thrust = this.getThrust();
    this.acceleration.x = thrust.x / this.mass;
    this.acceleration.y = thrust.y / this.mass;
    this.velocity.add(this.acceleration);
    this.position.add(this.velocity);
    this.draw();
  }
  
  PVector getThrust() {
    this.repelWalls();

    PVector thrust = new PVector(0, 0);
    thrust.add(this.keyThrust);
    thrust.add(this.wallThrust);
    return thrust;
  }
  
  float wallForce(float dist) {
    if (dist > 100) {
      return 0;
    }
    if (dist < 0) {
      return 10;
    }
    float n = norm(dist, 100, 0);
    return 10.0 * n * n * n;
  }

  void repelWalls() {
    this.wallThrust.x = wallForce(this.position.x) - wallForce(width - this.position.x);
    this.wallThrust.y = wallForce(this.position.y) - wallForce(height - this.position.y);
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
