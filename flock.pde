class Flock {
  ArrayList<Boid> boids;
  
  Flock() {
    this.boids = new ArrayList<Boid>();
  }
  
  void addBoid(float x, float y) {
    Boid boid = new Boid(this, x, y);
    if (this.boids.size() == 0) {
      boid.selected = true;
    }
    this.boids.add(boid);
  }
  
  void update() {
    for (Boid boid : this.boids) {
      boid.updateThrust();
    }
    for (Boid boid : this.boids) {
      boid.update();
    }
  }
  
  void keyPressed(int code) {
    for (Boid boid : this.boids) {
      boid.keyPressed(code);
    }
  }
  
  void keyReleased(int code) {
    for (Boid boid : this.boids) {
      boid.keyReleased(code);
    }
  }
}
