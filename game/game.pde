void settings() {
  size(1000, 1000, P2D);
  noSmooth();
}

Grid grid;
PVector origin;
PGraphics gfx, generalView;
Menu currMenu = new Menu(0);
Player player;
int side = 0;
boolean inMenu = true;
PImage bgImage;

void setup() {
  bgImage = loadImage("background.png");
  frameRate(60);
  origin = new PVector(width / 2, height / 2);
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
  currMenu = new Menu(1);
}

void saveFile(File file) {
  if (file == null) {
    return;
  }
  grid.toFile(file.getAbsolutePath());
  inMenu = false;
}

void generateMaze(int rad) {
  grid = new Grid(rad);
  MazeGenerator.generateMaze(grid);
  inMenu = false;
  currMenu = new Menu(1);
  player = grid.createPlayer(origin);
}

char[] readMazeFile(String fname) {
  ArrayList<Character> out = new ArrayList<>();
  try {
    InputStream file = createInput(fname);
    while (file.available() > 0) {
      out.add((char)file.read());
    }
  }
  catch(IOException e) {
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
    // Process keys in the menu
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
      inMenu = currMenu.esc();
    }
  } else if (key == ESC) {
    // process ESC key when outside of menu
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

void reachEnd() {
      player.currTile = new Tile(floor(player.currTile.pos.x), floor(player.currTile.pos.y), true);
      player.currTile.setIsFinish(true);
      for (int i = 0; i < 6; i++){
        PVector[] coords = player.currTile.getNeighbouringCoords();
        player.currTile.setNeighbour(i, new Tile(floor(coords[i].x), floor(coords[i].y), true));
      }
}

void play() {
  background(0);
  // Process the player reaching/being at the end
  if (player.currTile.isFinish()) {
    textAlign(CENTER);
    text("You win", width/2, height/2, width, height);
    if (!player.currTile.isDummy){
      reachEnd();
    }
  }
  player.step();
  // Drawing the background
  gfx.beginDraw();
  gfx.resetMatrix();
  gfx.translate( -player.worldPos().x, -player.worldPos().y);
  // Draw background
  int bgCentX = floor(player.absoluteWorldPos().x / bgImage.width);
  int bgCentY = floor(player.absoluteWorldPos().y / bgImage.height);
  for (int i = -4; i <= 4; i++){
    for (int j = -4; j <= 4; j++){
      gfx.image(bgImage, (bgCentX + i) * bgImage.width, (bgCentY + j) * bgImage.height);
    }
  }
  // Drawing the vision mask
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
  // apply the vision mask
  gfx.mask(generalView);
  player.draw(gfx);
  gfx.endDraw();
  // draw the visable stuff on the canvas
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
