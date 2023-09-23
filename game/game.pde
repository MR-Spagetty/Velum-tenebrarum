void settings() {
    size(500, 500, P2D);
    noSmooth();
}
ArrayList<Tile> tiles = new ArrayList<Tile>();
PVector origin;
PGraphics gfx;
void setup() {
    noLoop();
    frameRate(10);
    gfx = createGraphics(width, height, P2D);
    origin = new PVector(width/2, height/2);
    tiles.add(new Tile(0, 0));
    tiles.add(new Tile(1, 0));
    tiles.add(new Tile(0, 1));
    tiles.add(new Tile(-1, 1));
    tiles.add(new Tile(-1, 0));
    tiles.add(new Tile(0, -1));
    tiles.add(new Tile(1, -1));
    stroke(0);
    strokeWeight(3);
}
void draw() {
    background(255);
    gfx.beginDraw();
    gfx.fill(150);
    for (Tile tile: tiles) {
        tile.draw(gfx, origin);
    }
    gfx.endDraw();
    image(gfx, 0, 0);

}
