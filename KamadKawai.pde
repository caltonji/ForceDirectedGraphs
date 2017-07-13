double maxDistance = 1;

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
           if (distanceUsingK > maxDistance) {
             maxDistance = distanceUsingK; 
           }
         }
         
      }
    }
  }
}

public void calculateDesiredLengths() {
  double lengthOfOneEdge = SCREEN_SIZE / (maxDistance + 2.0);
  for (int i = 0; i < nodeList.size(); i++) {
    Node nodeI = nodeList.get(i);
    for (int j = 0; j < nodeList.size(); j++) {
       Node nodeJ = nodeList.get(j);
       nodeI.desiredLengthMap.put(nodeJ, nodeI.distanceMap.get(nodeI) * lengthOfOneEdge);
    }
  }
}

public void calculateSpringStrengths() {
  for (int i = 0; i < nodeList.size(); i++) {
    Node nodeI = nodeList.get(i);
    for (int j = 0; j < nodeList.size(); j++) {
       Node nodeJ = nodeList.get(j);
       double distIJ = nodeI.distanceMap.get(nodeI);
       nodeI.springStrengthMap.put(nodeJ, SPRING_CONSTANT / (distIJ * distIJ));
    }
  }
}

public void rebalanceAll() {
  calculateMinimumDistances();
  calculateDesiredLengths();
  calculateSpringStrengths();
}