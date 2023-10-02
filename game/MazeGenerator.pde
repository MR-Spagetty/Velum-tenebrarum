import java.util.Random;
import java.util.List;
import java.util.HashSet;

public static class MazeGenerator {

    public static void generateMaze(Grid template) {
        Random rand = new Random();
        List<Tile> tiles = template.getTiles();
        template.setStart(tiles.get(rand.nextInt(tiles.size())));
        generateRoute(rand, template.getStart(), new HashSet<>());
    }

    public static void generateRoute(Random rand, Tile from, HashSet<Tile> visited) {
        visited.add(from);
        if (!canExpand(from, visited)) {
            return;
        }
        while(canExpand(from, visited)) {
            int numExpandableSides = 0;
            for (int i = 0; i < 6; i ++) {
                if (canOpen(from, i, visited)) {
                    numExpandableSides ++;
                }
            }
            int toOpen = rand.nextInt(numExpandableSides);
            for (int i = 0; i < 6; i ++) {
                if (canOpen(from, i, visited)) {
                    if (toOpen == 0){
                        openSide(from, i);
                        generateRoute(rand, from.getNeighbour(i), visited);
                    }
                    toOpen --;
                }
            }

        }
    }

    private static boolean canExpand(Tile from, HashSet<Tile> visited) {
        for (int i = 0; i < 6; i ++) {
            if (canOpen(from, i, visited)) {
                return true;
            }
        }
        return false;
    }

    private static boolean canOpen(Tile from, int side, HashSet<Tile> visited) {
        return from.getOpenableSides()[side] && !visited.contains(from.getNeighbour(side));
    }

    private static void openSide(Tile tile, int side) {
        tile.setOpen(side, true);
        tile.getNeighbour(side).setOpen(tile.oppositeSide(side), true);
    }

}
