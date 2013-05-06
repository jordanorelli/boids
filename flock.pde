class Flock {
  ArrayList<Boid> boids;
  
  Flock() {
    this.boids = new ArrayList<Boid>();
  }
  
  void addBoid(Boid boid) {
    if (this.boids.size() == 0) {
      // boid.selected = true;
    }
    this.boids.add(boid);
    println(this.boids.size());
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
      if (boid.selected) {
        boid.keyPressed(code);
      }
    }
  }
  
  void keyReleased(int code) {
    for (Boid boid : this.boids) {
      if (boid.selected) {
        boid.keyReleased(code);
      }
    }
  }
}
