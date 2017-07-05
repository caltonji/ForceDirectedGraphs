private class NodeList extends ArrayList<Node> {
  
  boolean hasCollisionWithNodeAtCenterPoint(float x, float y) {
    for (Node node : this) {
       if (node.wouldHaveCollisionWithNodeWithCenterPoint(x, y)) {
         return true;
       }
    }
    return false;
  }
  
  boolean hasCollisionNode(float x, float y) {
    for (Node node : this) {
       if (node.collidesWithPoint(x, y)) {
         return true;
       }
    }
    return false;
  }
  
  Node getCollisionNode(float x, float y) {
    for (Node node : this) {
       if (node.collidesWithPoint(x, y)) {
         return node;
       }
    }
    return null;
  }
  
  void drawAllNodes() {
    for (Node node : this) {
       node.draw(); 
    }
  }
}