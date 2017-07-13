
Node buildNodeFromCenterPoint(float x, float y) {
  return new Node(x - Node.RECT_WIDTH / 2, y - Node.RECT_HEIGHT / 2);
}

public class Node {

  private final int DESIRED_LENGTH = 40;

  static final float RECT_WIDTH = 25;
  static final float RECT_HEIGHT = 25;
  static final float HALF_RECT_WIDTH = RECT_WIDTH / 2;
  static final float HALF_RECT_HEIGHT = RECT_HEIGHT / 2;
  static final int NO_COLOR_VALUE = -1;
  color drawColor = lightBlue;
  color drawOnceColor = NO_COLOR_VALUE;

  float x;
  float y;

  public Map<Node, Double> distanceMap = new HashMap<Node, Double>();
  public Map<Node, Double> desiredLengthMap = new HashMap<Node, Double>();
  public Map<Node, Double> springStrengthMap = new HashMap<Node, Double>();


  public Node(float x, float y) {
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
    rect(x, y, RECT_WIDTH, RECT_HEIGHT);
  }

  public void setDrawOnceColor(color drawOnceColor) {
    this.drawOnceColor = drawOnceColor;
  }
  public Node setDrawColor(color drawColor) {
    this.drawColor = drawColor;
    return this;
  }

  public boolean collidesWithPoint(float x, float y) {
    return (x >= this.x && x <= (this.x + RECT_WIDTH))
      && (y >= this.y && y < (this.y + RECT_HEIGHT));
  }

  public boolean wouldHaveCollisionWithNodeWithCenterPoint(float x, float y) {
    float startingX = x - HALF_RECT_WIDTH;
    float startingY = y - HALF_RECT_HEIGHT;
    float endingX = x + HALF_RECT_WIDTH;
    float endingY = y + HALF_RECT_HEIGHT;
    // lazy collision
    return collidesWithPoint(startingX, startingY)
      || collidesWithPoint(startingX, endingY)
      || collidesWithPoint(endingX, endingY)
      || collidesWithPoint(endingX, startingY);
  }

  float getCenterX() {
    return x + HALF_RECT_WIDTH;
  }

  float getCenterY() {
    return y + HALF_RECT_HEIGHT;
  }
}