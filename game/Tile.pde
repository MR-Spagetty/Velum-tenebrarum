public class Tile {

    public static final int RADIUS = 100;
    public static final int DIAMETER = 2 * RADIUS;
    public final PVector X_OFFSET = new PVector(0.5f * sqrt(3) * RADIUS, -3f / 2 * RADIUS);
    public final PVector Y_OFFSET = new PVector(-0.5f * sqrt(3) * RADIUS, -3f / 2 * RADIUS);

    /**
    * grid layout
    *   +y  +x
    *     /\
    *    |  |
    *     \/
    *   -x  -y
    */

    private PVector pos;

    private boolean[] openSides = new boolean[6];
    private Tile[] neighbors = new Tile[6];

    private boolean isStart = false;
    private boolean isFinish = false;

    public Tile(int x, int y) {
        this.pos = new PVector(x, y);
    }

    public Tile(int x, int y, char data) {
        this(x, y);
        setIsStart(((data >> 7) & 1) == 1);
        setIsFinish(((data >> 6) & 1) == 1);
        for (int i = 0; i <= 5; i++) {
            setOpen(i,((data >> 5 - i) & 1) == 1);
        }
    }

    public PVector getWorldCoords(PVector origin) {
        PVector pos = PVector.mult(X_OFFSET, this.pos.x);
        pos.add(PVector.mult(Y_OFFSET, this.pos.y));
        pos.add(origin);
        return pos;
    }

    public void draw(PGraphics graphics, PVector origin) {
        PVector posToDraw = getWorldCoords(origin);
        graphics.beginShape();
        float ang = radians(30);
        for (int point = 0; point < 6; point ++, ang += radians(60)) {
            graphics.vertex(posToDraw.x + RADIUS * cos(ang), posToDraw.y - RADIUS * sin(ang));
        }
        graphics.endShape(CLOSE);
    }

    public boolean pointIn(PVector point, PVector origin) {
        PVector centre = getWorldCoords(origin);
        float maxYOffset = RADIUS - (sin(radians(30)) * (abs(point.x - centre.x) / cos(radians(30))));
        float maxXOffset = 0.5f * sqrt(3) * RADIUS;
        return((abs(centre.x - point.x) <= maxXOffset) && (abs(centre.y - point.y) <= maxYOffset));
    }

    public Tile getNeighbour(int side) {
        if (constrain(side, 0, this.neighbors.length - 1) != side) {
            throw new IllegalArgumentException("Invalid side given");
        }
        return this.neighbors[side];
    }

    public void setNeighbour(int side, Tile neighbour) {
        if (constrain(side, 0, this.neighbors.length - 1) != side) {
            throw new IllegalArgumentException("Invalid side given");
        }
        this.neighbors[side] = neighbour;
    }

    public PVector[] getNeighbouringCoords() {
        PVector[] result = new PVector[this.neighbors.length];
        result[0] = PVector.add(this.pos, new PVector(1, 0));
        result[1] = PVector.add(this.pos, new PVector(0, 1));
        result[2] = PVector.add(this.pos, new PVector(-1, 1));
        result[3] = PVector.add(this.pos, new PVector(-1, 0));
        result[4] = PVector.add(this.pos, new PVector(0, -1));
        result[5] = PVector.add(this.pos, new PVector(1, -1));
        return result;
    }

    public Tile[] getNeighbors() {
        Tile[] out = new Tile[this.neighbors.length];
        for (int i = 0; i < this.neighbors.length; i++) {
            out[i] = this.neighbors[i];
        }
        return out;
    }

    public boolean[] getOpenableSides() {
        boolean[] out = new boolean[this.openSides.length];
        for (int i = 0; i < this.openSides.length; i++) {
            out[i] = !this.openSides[i] && (this.neighbors[i] != null);
        }
        return out;
    }


    public void setIsStart(boolean isStart) {
        this.isStart = isStart;
    }

    public boolean isStart() {
        return this.isStart;
    }

    public void setIsFinish(boolean isFinish) {
        this.isFinish = isFinish;
    }

    public boolean isFinish() {
        return this.isFinish;
    }

    public void setOpen(int side, boolean open) {
        if (constrain(side, 0, this.openSides.length - 1) != side) {
            throw new IllegalArgumentException("Invalid side given");
        }
        this.openSides[side] = open;
    }

    public boolean isOpen(int side) {
        if (constrain(side, 0, this.openSides.length - 1) != side) {
            throw new IllegalArgumentException("Invalid side given");
        }
        return this.openSides[side];
    }

    public char toChar() {
        char out = 0;
        if (this.isStart) {
            out |= 0b10000000;
        }
        if (this.isFinish) {
            out |= 0b01000000;
        }
        for (int i = 0; i < this.openSides.length; i++) {
            if (this.openSides[i]) {
                out |= 1 << 5 - i;
            }
        }
        return out;
    }
}
