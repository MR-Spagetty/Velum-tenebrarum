import java.util.Collections;
import java.util.List;
import java.io.FileOutputStream;
import java.io.FileNotFoundException;

public class Grid {

  private HashMap<PVector, Tile> tiles = new HashMap<>();
  public final int rad;
  public final int numTiles;
  private Tile startTile;

  public Grid(int rad) {
    if (constrain(rad, 0, 15) != rad){
      throw new IllegalArgumentException("Rad may not be less than 0 or greater than 15\nyou gave: " + rad);
    }
    this.rad = rad;
    this.numTiles = floor(2 * pow(rad + 1, 2) + pow(rad, 2) - (rad + 1));
    for (int x = -rad; x <= rad; x++) {
      for (int y = max( -rad, -rad - x); y <= min(rad, rad - x); y++) {
        this.tiles.put(new PVector(x, y), new Tile(x, y));
      }
    }
    computeNeighbors(this.tiles.get(new PVector(0, 0)));
  }

  public Grid(char[] data) {
    String extraniusData = "";
    char currExtData = 0;
    int extraniusNibble = 0;
    boolean negative = true;
    int rad = (int)(data[0] & 15);
    this.rad = rad;
    this.numTiles = floor(2 * pow(rad + 1, 2) + pow(rad, 2) - (rad + 1));
    int byte_ = 0;
    while (byte_ < data.length) {
      char coordData = data[byte_];
      byte_++;
      int xCoord =  coordData & 15;
      if (extraniusNibble % 2 ==  1) {
        currExtData |= coordData >> 4;
        extraniusData += currExtData;
        currExtData = 0;
      } else {
        currExtData |= coordData & 0xf0;
      }
      extraniusNibble ++;
      if (xCoord == 0) {
        negative = false;
      }
      int x = (negative ? - xCoord : xCoord);
      for (int y = max( -rad, -rad - x); y <= min(rad, rad - x); y++) {
        char dataChar = data[byte_];
        byte_++;
        Tile tile = new Tile(x, y, dataChar);
        if (tile.isStart()) {
          if (this.startTile != null) {
            this.startTile.setIsStart(false);
          }
          this.startTile = tile;
        }
        this.tiles.put(new PVector(x, y), tile);
      }
    }
    println("Extranius data: \"" + extraniusData + "\"");
    computeNeighbors(this.tiles.get(new PVector(0, 0)));
  }

  private void computeNeighbors(Tile tile) {
    if (tile == null) {
      return;
    }
    Tile[] currNeighbors = tile.getNeighbors();
    PVector[] neighbouringCoords = tile.getNeighbouringCoords();
    for (int i = 0; i < currNeighbors.length; i++) {
      if (currNeighbors[i] == null) {
        tile.setNeighbour(i, this.tiles.get(neighbouringCoords[i]));
        if (this.tiles.get(neighbouringCoords[i]) != null) {
          this.tiles.get(neighbouringCoords[i]).setNeighbour((i + 3) % currNeighbors.length, tile);
          computeNeighbors(this.tiles.get(neighbouringCoords[i]));
        }
      }
    }
    currNeighbors = tile.getNeighbors();
    for (int i = 0; i < currNeighbors.length; i++) {
      if (currNeighbors[i] == null) {
        tile.setNeighbour(i, new Tile(floor(neighbouringCoords[i].x), floor(neighbouringCoords[i].y), true));
      }
    }
  }

  public Tile getTile(int x, int y) {
    return this.tiles.get(new PVector(x, y));
  }

  public List<Tile> getTiles() {
    return Collections.unmodifiableList(new ArrayList<Tile>(this.tiles.values()));
  }

  public void toFile(String fname) {
    try {
      FileOutputStream w = new FileOutputStream(fname);
      println("Writing " + this.tiles.values().size() + " tiles to file");
      for (int x = -rad; x <= rad; x++) {
        w.write((char)abs(x));
        for (int y = max( -rad, -rad - x); y <= min(rad, rad - x); y++) {
          w.write(getTile(x, y).toChar());
        }
      }
      w.flush();
      w.close();
    }
    catch(FileNotFoundException e) {
      println("Failed to open file for writing: " + e);
    }
    catch(IOException e) {
      println("Failed to write to file: " + e);
    }
  }

  public void setStart(Tile startTile) {
    if (this.startTile != null) {
      this.startTile.setIsStart(false);
    }
    this.startTile = startTile;
    startTile.setIsStart(true);
  }

  private Tile getStart() {
    if (this.startTile == null) {
      setStart(getTile(0, 0));
    }
    return this.startTile;
  }

  public Player createPlayer(PVector origin) {
    if (this.startTile == null) {
      return new Player(getTile(0, 0), origin);
    }
    return new Player(this.startTile, origin);
  }

  public Player createPlayer(Player old) {
    Player newPlay;
    if (this.startTile == null) {
      newPlay = new Player(getTile(0, 0), old);
    } else {
      newPlay = new Player(this.startTile, old);
    }
    return newPlay;
  }
}
