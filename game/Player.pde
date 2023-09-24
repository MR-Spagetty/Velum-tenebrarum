public class Player {

    public final float maxRotationSpeed = radians(5);
    public final float maxSpeed = 5f;
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

    public void step() {
        if (this.keysPressed.contains('w') ^ this.keysPressed.contains('s')) {
            this.velocity.x = maxSpeed * cos(this.lookingDir);
            this.velocity.y = maxSpeed * sin(this.lookingDir);
            if (this.keysPressed.contains('s')) {
                this.velocity.mult(-1);
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
        this.pos.add(this.velocity);
    }

    public void draw(PGraphics gfx) {
        gfx.ellipseMode(CENTER);
        gfx.ellipse(absoluteWorldPos().x, absoluteWorldPos().y, 50f, 50f);
    }

}
