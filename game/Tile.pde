public class Tile {

    public static final int RADIUS = 100;
    public static final int DIAMETER = 2 * RADIUS;
    public final PVector X_OFFSET = new PVector(-0.5f * sqrt(3) * RADIUS, -3f/2 * RADIUS);
    public final PVector Y_OFFSET = new PVector(-1.5f * sqrt(3) * RADIUS, -3f/2 * RADIUS);
    public final PVector Z_OFFSET = new PVector(-sqrt(3) * RADIUS, 0);

    /**
    *   _y  +x
    *     /\
    * +z |  | -z
    *     \/
    *   -x  _y
    */

    private PVector pos;

    public Tile(int x, int y) {
        this.pos = new PVector(x, y, -(x + y));
    }

    public void draw(PGraphics graphics, PVector origin) {
        PVector posToDraw = PVector.mult(X_OFFSET, this.pos.x);
        posToDraw.add(PVector.mult(Y_OFFSET, this.pos.y));
        posToDraw.add(PVector.mult(Z_OFFSET, this.pos.z));
        posToDraw.add(origin);
        graphics.beginShape();
        float ang = radians(30);
        for (int point = 0; point < 6; point ++, ang += radians(60)){
            graphics.vertex(posToDraw.x + RADIUS * cos(ang), posToDraw.y - RADIUS * sin(ang));
        }
        graphics.endShape(CLOSE);
    }

}
