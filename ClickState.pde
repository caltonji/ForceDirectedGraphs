class ClickState {
  private boolean hasChainedNode;
  private Node chainedNode;
  
  public ClickState() {
    hasChainedNode = false;
  }
  
  void setChainedNode(Node chainedNode) {
    this.chainedNode = chainedNode;
    chainedNode.setDrawColor(lightOrange);
    hasChainedNode = true;
  }
  
  Node getChainedNode() {
     return chainedNode;
  }
  
  void unChain() {
     chainedNode.setDrawColor(lightBlue);
     hasChainedNode = false; 
  }
  
  boolean hasChainedNode() {
    return hasChainedNode;
  }
  
  boolean isFree() {
    return !hasChainedNode;
  }
}