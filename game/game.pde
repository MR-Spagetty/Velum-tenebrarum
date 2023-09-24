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
    origin = new PVector(width/2, height/2);
    int rad = 1;
    grid = new Grid(rad);
    player = new Player(grid.getTile(0, 0), origin);
    stroke(0);
    strokeWeight(3);
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
    gfx.translate(-player.worldPos().x, - player.worldPos().y);
    gfx.clear();
    gfx.fill(255,0,0);
    grid.getTile(0,0).draw(gfx, origin);
    gfx.fill(0,255,0);
    grid.getTile(0, 0).getNeighbour(side).draw(gfx, origin);
    gfx.fill(0,0,255);
    player.draw(gfx);
    gfx.endDraw();
    image(gfx, 0, 0);

}
