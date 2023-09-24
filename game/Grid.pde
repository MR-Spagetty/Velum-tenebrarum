import java.util.ArrayDeque;
public class Grid {

    private HashMap<PVector, Tile> tiles = new HashMap<>();
    public final int numTiles;

    public Grid(int rad) {
        this.numTiles = floor(2*pow(rad+1, 2) + pow(rad, 2) - (rad+1));
        for (int x = -rad; x <= rad; x++) {
            for (int y = max( -rad, -rad - x); y <= min(rad, rad - x); y++) {
                this.tiles.put(new PVector(x, y), new Tile(x, y));
            }
        }
        computeNeighbors(this.tiles.get(new PVector(0, 0)));
    }

    public Grid(char[] data){
        ArrayDeque<Character> gridData = new ArrayDeque<Character>();
        for (char byte_: data){
            gridData.push(byte_);
        }
        String extraniusData = "";
        char currExtData = 0;
        int extraniusNibble = 0;
        boolean negative = true;
        int rad = (int)(data[0] & 15);
        this.numTiles = floor(2*pow(rad+1, 2) + pow(rad, 2) - (rad+1));
        while (!gridData.isEmpty()) {
            char coordData = gridData.poll();
            int xCoord =  coordData & 15;
            if (extraniusNibble % 2 ==1){
                currExtData |= coordData >> 4;
                extraniusData += currExtData;
                currExtData = 0;
            } else {
                currExtData |= coordData & 0xf0;
            }
            if (xCoord == 0) {
                negative = false;
            }
            int x = negative? -xCoord : xCoord;
            for (int y = max( -rad, -rad - x); y <= min(rad, rad - x); y++) {
                this.tiles.put(new PVector(x, y), new Tile(x, y, gridData.poll()));
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

    public Tile getTile(int x, int y){
        return this.tiles.get(new PVector(x,y));
    }

}
