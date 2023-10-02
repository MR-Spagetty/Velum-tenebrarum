void settings() {
    size(1000, 1000, P2D);
    noSmooth();
}
Grid grid;
PVector origin;
PGraphics gfx;
PGraphics generalView;
Menu currMenu = new Menu(true);
Player player;
int side = 0;
boolean inMenu = true;
void setup() {
    // noLoop();
    frameRate(60);
    origin = new PVector(width / 2, height / 2);
    int rad = 1;
    stroke(255);
    fill(0);
    strokeWeight(3);
    gfx = createGraphics(width, height, P2D);
    generalView = createGraphics(width, height, P2D);
    gfx.beginDraw();
    gfx.noStroke();
    gfx.endDraw();
    generalView.beginDraw();
    generalView.stroke(0);
    generalView.endDraw();
}

void loadFile(File file) {
    if (file == null) {
        return;
    }
    char[] data = readMazeFile(file.getAbsolutePath());
    if (data.length == 0) {
        return;
    }
    grid = new Grid(data);
    player = grid.createPlayer(origin);
    inMenu = false;
    currMenu = new Menu();
}

void saveFile(File file) {
    if (file == null) {
        return;
    }
    grid.toFile(file.getAbsolutePath());
    inMenu = false;
}

void generateMaze() {
    grid = new Grid(15);
    MazeGenerator.generateMaze(grid);
    inMenu = false;
    currMenu = new Menu();
    player = grid.createPlayer(origin);
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
    if (inMenu) {
        switch(key) {
            case ENTER:
            case RETURN:
            case ' ':
                currMenu.execute();
                break;
            case 'w':
                currMenu.up();
                break;
            case 's':
                currMenu.down();
                break;
            case ESC:
                currMenu = new Menu();
                inMenu = false;
        }
    } else if (key == ESC) {
        inMenu = true;
    }
    if (player != null) {
        player.handleKey();
    }
    key = 0;
}

void keyReleased() {
    if (player != null) {
        player.handleKey(true);
    }
}

void play() {
    if (frameCount % 30 == 0) {
        side ++;
        side %= 6;
    }
    player.step();
    background(0);
    gfx.beginDraw();
    gfx.resetMatrix();
    gfx.translate( -player.worldPos().x, -player.worldPos().y);
    gfx.background(255);
    generalView.beginDraw();
    generalView.resetMatrix();
    generalView.translate( -player.worldPos().x, -player.worldPos().y);
    generalView.background(0);
    player.drawVision(generalView);
    generalView.fill(0);
    for (Tile tile : player.getInaccessableTiles()) {
        tile.draw(generalView, origin);
    }
    generalView.endDraw();
    gfx.mask(generalView);
    gfx.fill(255, 20);
    player.currTile.draw(gfx, origin);
    for (Tile tile : player.getAccessableTiles()) {
        tile.draw(gfx, origin);
    }
    player.draw(gfx);
    gfx.endDraw();
    image(gfx, 0, 0);
}

void menu() {
    background(0);
    currMenu.draw();
}

void draw() {
    if (inMenu) {
        menu();
    } else {
        play();
    }
}
