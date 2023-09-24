import java.util.ArrayDeque;
public class Grid {
    
    private HashMap<PVector, Tile> tiles = new HashMap<>();
    private final int rad;
    public final int numTiles;
    
    public Grid(int rad) {
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
        while(byte_ < data.length) {
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
            if (xCoord == 0) {
                negative = false;
            }
            println("xCoord: " + xCoord);
            int x = (negative ? - xCoord : xCoord);
            for (int y = max( -rad, -rad - x); y <= min(rad, rad - x); y++) {
                char dataChar = data[byte_];
                byte_++;
                Tile tile = new Tile(x, y, dataChar);
                this.tiles.put(new PVector(x, y), tile);
            }
        }
        println("Extranius data: \"" + extraniusData + "\"");
        computeNeighbors(this.tiles.get(new PVector(0, 0)));
    }
    
    private void computeNeighbors(Tile tile) {
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
    }
    
    public Tile getTile(int x, int y) {
        return this.tiles.get(new PVector(x,y));
    }
    
    public void toFile(String fname) {
        PrintWriter w = createWriter(fname);
        for (int x = -rad; x <= rad; x++) {
            w.print((char)abs(x));
            for (int y = max( -rad, -rad - x); y <= min(rad, rad - x); y++) {
                w.print(getTile(x,y).toChar());
            }
        }
        w.flush();
        w.close();
    }
    
}
