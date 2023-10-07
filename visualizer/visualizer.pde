import java.util.HashSet;
import java.util.ArrayDeque;

void settings() {
  size(1000, 1000, P2D);
  noSmooth();
}
Grid grid;
PVector origin;
Menu currMenu = new Menu(true);
boolean inMenu = true;

float zoom = 1;

void setup() {
  frameRate(60);
  origin = new PVector(width / 2, height / 2);
  origin.x = 0;
  origin.y = 0;
  stroke(255);
  strokeWeight(5);
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
  PVector startPos = grid.getStart().getWorldCoords(origin);
  origin = startPos.mult(-1);
  inMenu = false;
  currMenu = new Menu();
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
  } else {
    float mov = 100 * 1/zoom;
    switch(key){
      case 'w':
        origin.y += mov;
        break;
      case 's':
        origin.y -= mov;
        break;
      case 'a':
        origin.x += mov;
        break;
      case 'd':
        origin.x -= mov;
        break;
      case 'q':
        zoom *=2;
        break;
      case 'e':
        zoom /= 2;
        break;
    }
  }
 key = 0;
}
void bfs(Tile start, Tile end) {
      ArrayDeque<Tile> queue = new ArrayDeque<>();
      HashMap<Tile, Tile> visitedFrom = new HashMap<>();
      visitedFrom.put(start, null);
      queue.add(start);
      while (!queue.isEmpty()){
        Tile currTile = queue.poll();
        for (int i = 0; i < 6; i++){
          if (!currTile.isOpen(i)){
            continue;
          }
          Tile neighbour = currTile.getNeighbour(i);
          if (visitedFrom.containsKey(neighbour)){
            continue;
          }
          queue.add(neighbour);
          visitedFrom.put(neighbour, currTile);
        }
        if (visitedFrom.containsKey(end)) {
          queue.clear();
        }
      }

      if(!visitedFrom.containsKey(end)){
        return;
      }

      Tile currTile = end;

      while (currTile != start) {
        currTile = visitedFrom.get(currTile);
        fill(222, 212, 16);
        currTile.draw(origin);
      }
    }


void drawLinks() {
  stroke(255, 0, 0);
  drawLinks(grid.getStart(), new HashSet<>());
}

void drawLinks(Tile tile, HashSet<Tile> visited) {
  visited.add(tile);
  for (int i = 0; i < 6; i++){
    if (!tile.isOpen(i)){
      continue;
    }
    Tile neighbour = tile.getNeighbour(i);
    line(tile.getWorldCoords(origin).x, tile.getWorldCoords(origin).y, neighbour.getWorldCoords(origin).x, neighbour.getWorldCoords(origin).y);
    if (!visited.contains(neighbour)){
      drawLinks(neighbour, visited);
    }
  }
}

void play() {
  background(255);
  resetMatrix();
  translate(-width/2, -height/2);
  scale(zoom);
  translate(1/zoom * width, 1/zoom * height);
  ArrayList<Tile> ends = new ArrayList<>();
  for (Tile tile: grid.getTiles()){
    if (tile.isStart()){
      continue;
    } else if (tile.isFinish()){
      ends.add(tile);
      stroke(0, 255, 0);
      fill(0,255,0);
    } else {
      stroke(0);
      fill(255);
    }
    tile.draw(origin);
  }
  for (Tile end: ends){
    bfs(grid.getStart(), end);
  }
  stroke(0, 0, 255);
  fill(0,0,255);
  grid.getStart().draw(origin);
  drawLinks();
}

void menu() {
  resetMatrix();
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
