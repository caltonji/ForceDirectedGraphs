class Edge {
  Node start;
  Node end;
  
  public Edge(Node start, Node end) {
    this.start = start;
    this.end = end;
  }
  
  public void draw() {
    stroke(lightOrange);
    line((float) start.getCenterX(), (float) start.getCenterY(), 
         (float) end.getCenterX(), (float) end.getCenterY()); 
  }
}