public class Player {

    public final float maxRotationSpeed = radians(5);
    public final float maxSpeed = 1f;
    public final float visoinDist = 50f;


    private PVector pos;
    private PVector origin;
    private Tile currTile;
    private float lookingDir = 0;
    private PVector velocity = new PVector();

    private ArrayList<Character> keysPressed = new ArrayList<>();

    public Player(Tile startTile, PVector origin) {
        this.origin = origin;
        this.pos = startTile.getWorldCoords(new PVector(0, 0));
        this.currTile = startTile;
    }

    public PVector absoluteWorldPos() {
        return PVector.add(this.pos, this.origin);
    }

    public PVector worldPos() {
        return this.pos;
    }

    public void handleKey() {handleKey(false);}

    public void handleKey(boolean released) {
        if (released) {
            while(this.keysPressed.contains(key)) {
                this.keysPressed.remove(this.keysPressed.indexOf(key));
            }
        } else {
            this.keysPressed.add(key);
        }
    }
    public ArrayList<Tile> getAccessableTiles() {
        ArrayList<Tile> out = new ArrayList<>();
        Tile[] neighbourTiles = this.currTile.getNeighbors();
        for (int i = 0; i < neighbourTiles.length; i ++) {
            if (this.currTile.isOpen(i)) {
                out.add(neighbourTiles[i]);
            }
        }
        return out;
    }
    private boolean movementValid(PVector movement) {
        if (this.currTile.pointIn(PVector.add(absoluteWorldPos(), movement), this.origin)) {
            return true;
        }
        for (Tile tile : getAccessableTiles()) {
            if (tile.pointIn(PVector.add(absoluteWorldPos(), movement), this.origin)) {
                return true;
            }
        }
        return false;
    }

    public void step() {
        if (this.keysPressed.contains('w') ^ this.keysPressed.contains('s')) {
            this.velocity.x = maxSpeed * cos(this.lookingDir);
            this.velocity.y = maxSpeed * sin(this.lookingDir);
            if (this.keysPressed.contains('s')) {
                this.velocity.mult( -1);
            }
        } else {
            this.velocity.x = 0;
            this.velocity.y = 0;
        }
        if (this.keysPressed.contains('a') ^ this.keysPressed.contains('d')) {
            if (this.keysPressed.contains('d')) {
                this.lookingDir += maxRotationSpeed;
            } else {
                this.lookingDir -= maxRotationSpeed;
            }
        }
        if (movementValid(this.velocity)) {
            this.pos.add(this.velocity);
        }
    }

    public void draw(PGraphics gfx) {
        gfx.ellipseMode(CENTER);
        gfx.ellipse(absoluteWorldPos().x, absoluteWorldPos().y, 5f, 5f);
        gfx.line(absoluteWorldPos().x, absoluteWorldPos().y, absoluteWorldPos().x + 10 * cos(this.lookingDir), absoluteWorldPos().y + 10 * sin(this.lookingDir));
    }

}
