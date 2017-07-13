class Edge {
  Node start;
  Node end;
  
  public Edge(Node start, Node end) {
    this.start = start;
    this.end = end;
  }
  
  public void draw() {
    stroke(lightOrange);
    line(start.getCenterX(), start.getCenterY(), end.getCenterX(), end.getCenterY()); 
  }
}