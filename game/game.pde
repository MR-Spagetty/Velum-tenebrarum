void settings() {
    size(1000, 1000, P2D);
    noSmooth();
}
Grid grid;
PVector origin;
PGraphics gfx;
Player player;
int side = 0;
void setup() {
    // noLoop();
    frameRate(60);
    gfx = createGraphics(width, height, P2D);
    origin = new PVector(width / 2, height / 2);
    int rad = 1;
    grid = new Grid(readMazeFile("test.maze"));
    // grid.toFile("test.maze");
    player = new Player(grid.getTile(0, 0), origin);
    stroke(0);
    strokeWeight(3);
}

char[] readMazeFile(String fname) {
    ArrayList<Character> out = new ArrayList<>();
    try{
        InputStream file = createInput(fname);
        while(file.available() > 0) {
            out.add((char)file.read());
        }
    } catch(IOException e) {
        println("Error reading file");
        return new char[0];
    }
    char[] outArr = new char[out.size()];
    for (int i = 0; i < out.size(); i++) {
        outArr[i] = out.get(i);
    }
    return outArr;
}

void keyPressed() {
    player.handleKey();
}

void keyReleased() {
    player.handleKey(true);
}

void draw() {
    if (frameCount % 30 == 0) {
        side ++;
        side %= 6;
    }
    player.step();
    background(255);
    gfx.beginDraw();
    gfx.resetMatrix();
    gfx.translate( -player.worldPos().x, -player.worldPos().y);
    gfx.clear();
    gfx.fill(255,0,0);
    grid.getTile(0,0).draw(gfx, origin);
    gfx.fill(0,255,0);
    // grid.getTile(0, 0).getNeighbour(side).draw(gfx, origin);
    for (Tile tile: player.getAccessableTiles()) {
        tile.draw(gfx, origin);
    }
    gfx.fill(0,0,255);
    player.draw(gfx);
    gfx.endDraw();
    image(gfx, 0, 0);
    
}
