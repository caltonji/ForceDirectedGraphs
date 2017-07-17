
Node buildNodeFromCenterPoint(double x, double y) {
  return new Node(x - Node.RECT_WIDTH / 2, y - Node.RECT_HEIGHT / 2);
}

public class Node {

  private final int DESIRED_LENGTH = 40;

  static final double RECT_WIDTH = 25;
  static final double RECT_HEIGHT = 25;
  static final double HALF_RECT_WIDTH = RECT_WIDTH / 2;
  static final double HALF_RECT_HEIGHT = RECT_HEIGHT / 2;
  static final int NO_COLOR_VALUE = -1;
  color drawColor = lightBlue;
  color drawOnceColor = NO_COLOR_VALUE;

  double x;
  double y;
  
  double derivativeX;
  double derivativeY;

  public Map<Node, Double> distanceMap = new HashMap<Node, Double>();
  public Map<Node, Double> desiredLengthMap = new HashMap<Node, Double>();
  public Map<Node, Double> springStrengthMap = new HashMap<Node, Double>();


  public Node(double x, double y) {
    this.x = x;
    this.y = y;
  }

  public void draw() {
    if (drawOnceColor != NO_COLOR_VALUE) {
      stroke(drawOnceColor);
      fill(drawOnceColor);
      drawOnceColor = NO_COLOR_VALUE;
    } else {
      stroke(drawColor);
      fill(drawColor);
    }
    rect((float) x, (float) y, (float) RECT_WIDTH, (float) RECT_HEIGHT);
  }

  public void setDrawOnceColor(color drawOnceColor) {
    this.drawOnceColor = drawOnceColor;
  }
  public Node setDrawColor(color drawColor) {
    this.drawColor = drawColor;
    return this;
  }

  public boolean collidesWithPoint(double x, double y) {
    return (x >= this.x && x <= (this.x + RECT_WIDTH))
      && (y >= this.y && y < (this.y + RECT_HEIGHT));
  }

  public boolean wouldHaveCollisionWithNodeWithCenterPoint(double x, double y) {
    double startingX = x - HALF_RECT_WIDTH;
    double startingY = y - HALF_RECT_HEIGHT;
    double endingX = x + HALF_RECT_WIDTH;
    double endingY = y + HALF_RECT_HEIGHT;
    // lazy collision
    return collidesWithPoint(startingX, startingY)
      || collidesWithPoint(startingX, endingY)
      || collidesWithPoint(endingX, endingY)
      || collidesWithPoint(endingX, startingY);
  }

  double getCenterX() {
    return x + HALF_RECT_WIDTH;
  }

  double getCenterY() {
    return y + HALF_RECT_HEIGHT;
  }
  
  public void calculateAndSetDerivatives() {
    double derivativeXSum = 0.0;
    double derivativeYSum = 0.0;
    for (int i = 0; i < nodeList.size(); i++) {
      Node nodeI = nodeList.get(i);
      if (nodeI != this) {
        double xDiff = this.x - nodeI.x;
        double yDiff = this.y - nodeI.y;
        double xDiffSquared = Math.pow(xDiff, 2);
        double yDiffSquared = Math.pow(yDiff, 2);
        double denominator = Math.pow(xDiffSquared + yDiffSquared, 0.5);
        derivativeXSum += this.springStrengthMap.get(nodeI)
                          * (xDiff
                          - (this.desiredLengthMap.get(nodeI) * xDiff
                          / denominator));
        derivativeYSum += this.springStrengthMap.get(nodeI)
                          * (yDiff
                          - (this.desiredLengthMap.get(nodeI) * yDiff
                          / denominator));
      }
    }
    this.derivativeX = derivativeXSum;
    this.derivativeY = derivativeYSum;
  }
}