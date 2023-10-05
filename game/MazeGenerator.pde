import java.util.Random;
import java.util.List;
import java.util.HashSet;
import java.util.ArrayDeque;

public static class MazeGenerator {

    public static void generateMaze(Grid template) {
        Random rand = new Random();
        List<Tile> tiles = template.getTiles();
        template.setStart(tiles.get(rand.nextInt(tiles.size())));
        generateRoute(rand, template.getStart(), new HashSet<>());
        int longestPathlength = 0;
        Tile longestPathEnd = null;
        for (Tile tile: tiles){
          ArrayDeque<Tile> currPath = bfs(tile, template.getStart());
          if (currPath == null){
            continue;
          }
          int pathLength = currPath.size();
          if (pathLength > longestPathlength){
            longestPathlength = pathLength;
            longestPathEnd = tile;
          }
        }
        longestPathEnd.setIsFinish(true);
    }

    private static void generateRoute(Random rand, Tile from, HashSet<Tile> visited) {
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

    public static ArrayDeque<Tile> bfs(Tile start, Tile end) {
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
        return null;
      }

      ArrayDeque<Tile> path = new ArrayDeque<>();
      path.push(end);
      Tile currTile = end;

      while (currTile != start) {
        currTile = visitedFrom.get(currTile);
        path.push(currTile);
      }
      return path;
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
