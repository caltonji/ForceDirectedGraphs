class EdgeList extends ArrayList<Edge> {

  public boolean add(Edge edge) {
    boolean edgeAdded = super.add(edge);
    onEdgeAdded(edge);
    return edgeAdded;
  }
  public void drawAllEdges() {
    for (Edge edge : this) {
      edge.draw(); 
    }
  } 
}