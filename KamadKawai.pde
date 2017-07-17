double epsilon = 3500.0;
// need to play with this number
final double SPRING_CONSTANT = 25;

public void calculateMinimumDistances() {
  for (Node node : nodeList) {
    for (int j = 0; j < nodeList.size(); j++) {
      node.distanceMap.put(nodeList.get(j), Double.POSITIVE_INFINITY);
    }
    node.distanceMap.put(node, 0.0d);
  }
  for (Edge edge : edgeList) {
    edge.start.distanceMap.put(edge.end, 1.0d);
    edge.end.distanceMap.put(edge.start, 1.0d);
  }
  for (int k = 0; k < nodeList.size(); k++) {
    Node nodeK = nodeList.get(k);
    for (int i = 0; i < nodeList.size(); i++) {
      Node nodeI = nodeList.get(i);
      for (int j = 0; j < nodeList.size(); j++) {
        Node nodeJ = nodeList.get(j);
        double distanceUsingK = nodeI.distanceMap.get(nodeK) 
                                + nodeK.distanceMap.get(nodeJ);
        if (nodeI.distanceMap.get(nodeJ) > distanceUsingK) {
          nodeI.distanceMap.put(nodeJ, distanceUsingK);
        }
      }
    }
  }
}

public double maxDistanceIJ() {
  double maxDistance = 0;
  for (int i = 0; i < nodeList.size(); i++) {
    Node nodeI = nodeList.get(i);
    for (int j = 0; j < nodeList.size(); j++) {
      Node nodeJ = nodeList.get(j);
      double distIJ = nodeI.distanceMap.get(nodeJ);
      if (distIJ > maxDistance) {
        maxDistance = distIJ;
      }
    }
  }
  return maxDistance;
}

public void calculateDesiredLengths() {
  double lengthOfOneEdge = SCREEN_SIZE / maxDistanceIJ();
  for (int i = 0; i < nodeList.size(); i++) {
    Node nodeI = nodeList.get(i);
    for (int j = 0; j < nodeList.size(); j++) {
      Node nodeJ = nodeList.get(j);
      if (nodeJ != nodeI) {
        nodeI.desiredLengthMap.put(nodeJ, nodeI.distanceMap.get(nodeI) * lengthOfOneEdge);
      }
    }
    //System.out.println(nodeI.desiredLengthMap);
  }
}

public void calculateSpringStrengths() {
  for (int i = 0; i < nodeList.size(); i++) {
    Node nodeI = nodeList.get(i);
    for (int j = 0; j < nodeList.size(); j++) {
      Node nodeJ = nodeList.get(j);
      if (nodeJ != nodeI) {
        double distIJ = nodeI.distanceMap.get(nodeJ);
        nodeI.springStrengthMap.put(nodeJ, SPRING_CONSTANT / Math.pow(distIJ, 2));
      }
    }
  }
}

public void rebalanceAll() {
  calculateMinimumDistances();
  calculateDesiredLengths();
  calculateSpringStrengths();
  Node maxDeltaNode = nodeList.getMaxDeltaNode();
  double maxDeltaM = delta(maxDeltaNode);
  System.out.println(maxDeltaM);
  while (maxDeltaM > epsilon) {
    Node nodeM = maxDeltaNode;
    double deltaM = maxDeltaM;
    while (deltaM > epsilon) {
       nodeM.calculateAndSetDerivatives();
       double Ex = nodeM.derivativeX;
       double Ey = nodeM.derivativeY;
       double Exy = secondDerivativeOfEnergyXY(nodeM);
       double Ex2 = secondDerivativeOfEnergyXSquared(nodeM);
       double Ey2 = secondDerivativeOfEnergyYSquared(nodeM);
       System.out.println("Ex: " + Ex + " Ey: " + Ey + " Exy: " + Exy + " Ex2: " + Ex2 + " Ey2: " + Ey2);
       double changeInY = ((Ex) * (Exy) - Ey)
                          / ((Ey2) * (Ex2) - Math.pow(Exy, 2));
       double changeInX = ((-1 * Ex) - (Exy) * (changeInY))
                          / (Ex2);
       System.out.println("changeX: " + changeInX);
       System.out.println("ChangeY: " + changeInY);
       nodeM.x = nodeM.x + changeInX;
       nodeM.y = nodeM.y + changeInY;
       deltaM = delta(nodeM);
    }
    maxDeltaNode = nodeList.getMaxDeltaNode();
    maxDeltaM = delta(maxDeltaNode);
    System.out.println(maxDeltaM);
  }
}

// todo: easy speed up putting these together with the other ones maybe too
public double secondDerivativeOfEnergyXSquared(Node nodeM) {
  double sum = 0.0;
  for (int i = 0; i < nodeList.size(); i++) {
    Node nodeI = nodeList.get(i);
    if (nodeI != nodeM) {
      double xDiffSquared = Math.pow((nodeM.x - nodeI.x), 2);
      double yDiffSquared = Math.pow((nodeM.y - nodeI.y), 2);
      double numerator = nodeM.desiredLengthMap.get(nodeI) * yDiffSquared;
      double denominator = Math.pow(xDiffSquared + yDiffSquared, 1.5);
      sum += nodeM.springStrengthMap.get(nodeI) * (1 - numerator / denominator);
    }
  }
  return sum;
}

public double secondDerivativeOfEnergyYSquared(Node nodeM) {
  double sum = 0.0;
  for (int i = 0; i < nodeList.size(); i++) {
    Node nodeI = nodeList.get(i);
    if (nodeI != nodeM) {
      double xDiffSquared = Math.pow((nodeM.x - nodeI.x), 2);
      double yDiffSquared = Math.pow((nodeM.y - nodeI.y), 2);
      double numerator = nodeM.desiredLengthMap.get(nodeI) * xDiffSquared;
      double denominator = Math.pow(xDiffSquared + yDiffSquared, 1.5);
      sum += nodeM.springStrengthMap.get(nodeI) * (1 - numerator / denominator);
    }
  }
  return sum;
}

public double secondDerivativeOfEnergyXY(Node nodeM) {
  double sum = 0.0;
  for (int i = 0; i < nodeList.size(); i++) {
    Node nodeI = nodeList.get(i);
    if (nodeI != nodeM) {
      double xDiff = nodeM.x - nodeI.x;
      double yDiff = nodeM.y - nodeI.y;
      double xDiffSquared = Math.pow(xDiff, 2);
      double yDiffSquared = Math.pow(yDiff, 2);
      double numerator = nodeM.desiredLengthMap.get(nodeI)* xDiff * yDiff;
      double denominator = Math.pow(xDiffSquared + yDiffSquared, 1.5);
      sum += nodeM.springStrengthMap.get(nodeI) * (numerator / denominator);
    }
  }
  return sum;
}

public double delta(Node nodeM) {
  nodeM.calculateAndSetDerivatives();;
  return Math.pow(Math.pow(nodeM.derivativeX, 2) + Math.pow(nodeM.derivativeY, 2), 0.5);
}