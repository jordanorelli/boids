float KEY_THRUST = 1.0;
color KEY_THRUST_COLOR = color(101, 45, 93);  // purple heart

float WALL_THRUST_DIST = 40.0;
float WALL_THRUST_MAX = 10.0;
color WALL_THRUST_COLOR = color(128, 70, 27); // russet

float SEPARATION_DIST = 25.0;
float SEPARATION_THRUST_MAX = 1.0;
color SEPARATION_COLOR = color(299, 97, 3); // cadmium orange

float COHESION_DIST = 50.0;
float COHESION_THRUST_MAX = 1.0;
color COHESION_COLOR = color(19, 136, 8); // india green

float ALIGNMENT_DIST = 50.0;
color ALIGNMENT_COLOR = color(65, 105, 225); // royal blue

class Boid {
  Flock flock;
  PVector position;
  PVector velocity;
  PVector acceleration;
  PVector keyThrust;
  PVector wallThrust;
  PVector separationThrust;
  PVector cohesionThrust;
  PVector alignmentThrust;
  PVector thrust;
  float mass;
  float radius;
  boolean selected;
  int flapFrame;
  
  Boid(Flock flock, float x, float y) {
    this.flock = flock;
    this.position = new PVector(x, y);
    this.velocity = new PVector(0, 0);
    this.acceleration = new PVector(0, 0);
    this.keyThrust = new PVector(0, 0);
    this.wallThrust = new PVector(0, 0);
    this.separationThrust = new PVector(0, 0);
    this.cohesionThrust = new PVector(0, 0);
    this.alignmentThrust = new PVector(0, 0);
    this.thrust = new PVector(0, 0);
    this.mass = 1;
    this.radius = 30.0;
    this.selected = false;
    this.flapFrame = (int)random(0, 16);
  }
  
  void draw() {
    this.drawKeyThrust();
    stroke(0);
    strokeWeight(1);
    pushMatrix();
    PVector v = this.velocity.get();
    v.normalize();
    v.mult(5);
    translate(this.position.x, this.position.y);
    rotate(this.velocity.heading());
    line(0, 3 * sin(norm(frameCount + flapFrame % 16, 0, 16) * PI), 5, 0);
    line(0, -3 * sin(norm(frameCount + flapFrame % 16, 0, 16) * PI), 5, 0);
//    line(0, -2, 5, 0);
//    line(0, 2, 5, 0);
//    line(0, 0, 5, 0);
    popMatrix();
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
    this.drawThrustVector(this.cohesionThrust, COHESION_COLOR);
    this.drawThrustVector(this.alignmentThrust, ALIGNMENT_COLOR);
    this.drawRadius(SEPARATION_DIST, SEPARATION_COLOR);
    this.drawRadius(COHESION_DIST, COHESION_COLOR);
    this.drawRadius(ALIGNMENT_DIST, ALIGNMENT_COLOR);
  }
  
  void update() {
    this.acceleration.x = this.thrust.x / this.mass;
    this.acceleration.y = this.thrust.y / this.mass;
    this.acceleration.limit(1);
    this.velocity.add(this.acceleration);
    this.velocity.limit(2);
    this.position.add(this.velocity);
    this.bounds();
    this.draw();
    if (this.selected) {
      println(this.position);
    }
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
    this.cohesion();
    this.align();
    this.repelWalls();
    this.thrust.add(this.keyThrust);
    this.thrust.add(this.wallThrust);
    this.thrust.add(this.separationThrust);
    this.thrust.add(this.cohesionThrust);
    this.thrust.add(this.alignmentThrust);
  }
  
  float wallForce(float dist) {
    if (dist > WALL_THRUST_DIST) {
      return 0;
    }
    if (dist < 0) {
      return WALL_THRUST_MAX;
    }
    float n = norm(dist, WALL_THRUST_DIST, 0);
    return WALL_THRUST_MAX * n * n * n * n * n;
  }

  void repelWalls() {
    this.wallThrust.x = wallForce(this.position.x) - wallForce(width - this.position.x);
    this.wallThrust.y = wallForce(this.position.y) - wallForce(height - this.position.y);
  }
  
  void separate() {
    int count = 0;
    this.separationThrust.mult(0);
    for (Boid other : this.flock.boids) {
      float dist = PVector.dist(this.position, other.position);
      if (dist > SEPARATION_DIST) {
        continue;
      }
      PVector thrust = PVector.sub(this.position, other.position);
      thrust.normalize();
      dist = norm(dist, SEPARATION_DIST, 0);
      thrust.mult(SEPARATION_THRUST_MAX * dist * dist);
      this.separationThrust.add(thrust);
      count++;
    }
    if (count > 0) {
      // this.separationThrust.div((float)count);
    }
  }
  
  void cohesion() {
    int count = 0;
    this.cohesionThrust.mult(0);
    for (Boid other : this.flock.boids) {
      float dist = PVector.dist(this.position, other.position);
      if (dist > COHESION_DIST) {
        continue;
      }
      PVector thrust = PVector.sub(other.position, this.position);
      thrust.normalize();
      dist = norm(dist, COHESION_DIST, 0);
      thrust.mult(COHESION_THRUST_MAX * dist * dist);
      this.cohesionThrust.add(thrust);
      count++;
    }
    if (count > 0) {
      this.cohesionThrust.div((float)count);
    }
  }
  
  void align() {
    int count = 0;
    this.alignmentThrust.mult(0);
    for (Boid other : this.flock.boids ) {
      float dist = PVector.dist(this.position, other.position);
      if (dist > ALIGNMENT_DIST || other == this) {
        continue;
      }
      PVector v = other.velocity.get();
      v.normalize();
      v.mult(norm(dist, ALIGNMENT_DIST, 0));
      this.alignmentThrust.add(v);
      count++;
    }
    if (count > 0) {
      this.alignmentThrust.div((float)count);
    }
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
