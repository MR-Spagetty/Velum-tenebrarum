public class Tile {

    public static final int RADIUS = 100;
    public static final int DIAMETER = 2 * RADIUS;
    public final PVector X_OFFSET = new PVector( -0.5f * sqrt(3) * RADIUS, -3f / 2 * RADIUS);
    public final PVector Y_OFFSET = new PVector(0.5f * sqrt(3) * RADIUS, -3f / 2 * RADIUS);

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

    public Tile(int x, int y, byte data) {
        this(x, y);
        setIsStart(((data >> 7) & 1) == 1);
        setIsFinish(((data >> 6) & 1) == 1);
        for (int i = 0; i < 5; i++) {
            setOpen(i,((data >> 5 - i) & 1) == 1);
        }
    }

    public void draw(PGraphics graphics, PVector origin) {
        PVector posToDraw = PVector.mult(X_OFFSET, this.pos.x);
        posToDraw.add(PVector.mult(Y_OFFSET, this.pos.y));
        posToDraw.add(origin);
        graphics.beginShape();
        float ang = radians(30);
        for (int point = 0; point < 6; point ++, ang += radians(60)) {
            graphics.vertex(posToDraw.x + RADIUS * cos(ang), posToDraw.y - RADIUS * sin(ang));
        }
        graphics.endShape(CLOSE);
    }

    public Tile getNeighbour(int side) {
        if (constrain(side, 0, this.neighbors.length - 1) != side) {
            throw new IllegalArgumentException("Invalid side given");
        }
        return this.neighbors[side];
    }

    public void setNeighBour(int side, Tile neighbour) {
        if (constrain(side, 0, this.neighbors.length - 1) != side) {
            throw new IllegalArgumentException("Invalid side given");
        }
        this.neighbors[side] = neighbour;
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

    public byte toByte() {
        byte out = 0;
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
