private class NodeList extends ArrayList<Node> {
  Node getMaxDeltaNode() {
    double maxDelta = Double.NEGATIVE_INFINITY;
    Node maxDeltaNode = null;
    for (Node node : nodeList) {
       double thisDelta = delta(node);
       if (thisDelta > maxDelta) {
         maxDelta = thisDelta;
         maxDeltaNode = node;
       }
    }
    return maxDeltaNode;
  }
  
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