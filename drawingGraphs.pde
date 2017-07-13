import java.util.Arrays;
import java.util.HashMap;
import java.util.Map;

color white = color(255,255,255);
color black = color(0,0,0);
color red = color(192,41,66);

color beach = color(224,228,204);
color lightBlue = color(105,210,231);
color lightOrange = color(243,134,48);

ClickState clickState;
NodeList nodeList;
EdgeList edgeList;
final int SCREEN_SIZE = 480;
// need to play with this number
final double SPRING_CONSTANT = 20;


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
  drawDragLine();
  edgeList.drawAllEdges();
  nodeList.drawAllNodes();
}

void drawDragLine() {
 if (clickState.hasChainedNode()) {
    background(beach);
    stroke(lightOrange);
   
    if (pointIsOnADifferentNodeThanTheChainedNode(mouseX, mouseY)) {
       Node collisionNode = nodeList.getCollisionNode(mouseX, mouseY);
       collisionNode.setDrawOnceColor(lightOrange);
       line(clickState.getChainedNode().getCenterX(), clickState.getChainedNode().getCenterY(), 
            collisionNode.getCenterX(), collisionNode.getCenterY());
    } else if (nodeList.hasCollisionWithNodeAtCenterPoint(mouseX, mouseY)) {
      // do nothing  
    } else {
      line(clickState.getChainedNode().getCenterX(), clickState.getChainedNode().getCenterY(), mouseX, mouseY);
      if (!nodeList.hasCollisionWithNodeAtCenterPoint(mouseX, mouseY)) {
        buildNodeFromCenterPoint(mouseX, mouseY).setDrawColor(lightOrange).draw();
      }
    }
  }  
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