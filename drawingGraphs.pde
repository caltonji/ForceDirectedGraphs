import java.util.Arrays;

color white = color(255,255,255);
color black = color(0,0,0);
color red = color(192,41,66);

color beach = color(224,228,204);
color lightBlue = color(105,210,231);
color lightOrange = color(243,134,48);

ClickState clickState;
NodeList nodeList;
EdgeList edgeList;

void setup() {
  size(480,480);
  background(beach);
  smooth(4);
  noStroke();
  clickState = new ClickState();
  nodeList = new NodeList();
  edgeList = new EdgeList();
}

void draw() {
  edgeList.drawAllEdges();
  nodeList.drawAllNodes();
}

void mouseClicked() {
  float clickX = mouseX;
  float clickY = mouseY;
  
  
  if (clickState.isFree()) {
    handleFreeClick(clickX, clickY);
  } else {
    handleChainedClick(clickX, clickY);
  }
}

void handleFreeClick(float x, float y) {
  if (!nodeList.hasCollisionWithNodeAtCenterPoint(x, y)) {
    nodeList.add(buildNodeFromCenterPoint(x, y));
  } else if (nodeList.hasCollisionNode(x, y)) {
    clickState.setChainedNode(nodeList.getCollisionNode(x, y));
  }
}

void handleChainedClick(float x, float y) {
   if (pointIsOnADifferentNodeThanTheChainedNode(x, y)) {
       connectNodes(clickState.getChainedNode(), nodeList.getCollisionNode(x, y));
       clickState.unChain();
   } else if (!nodeList.hasCollisionWithNodeAtCenterPoint(x, y)) {
       Node newNode = buildNodeFromCenterPoint(x, y);
       connectNodes(clickState.getChainedNode(), newNode);
       nodeList.add(newNode);
       clickState.unChain();
   }
}

void connectNodes(Node start, Node end) {
  edgeList.add(new Edge(start, end));
}

boolean pointIsOnADifferentNodeThanTheChainedNode(float x, float y) {
  return (nodeList.hasCollisionNode(x, y) 
       && nodeList.getCollisionNode(x, y) != clickState.getChainedNode());
}

public void onEdgeAdded(Edge edge) {
  rebalanceAll();
}

public void rebalanceAll() {
  
}