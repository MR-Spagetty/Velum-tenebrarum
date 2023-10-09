public class Menu {

  public static final int BUTTON_WIDTH = 200;
  public static final int BUTTON_HEIGHT = 50;
  public static final int BUTTON_SEP = 25;
  public static final int BUTTON_START_HEIGHT = 50;

  private final int menuType;
  private int currOpt = 0;
  private ArrayList<String> options = new ArrayList<>();
  private Menu subMenu = null;

  public Menu(int menuType) {
    this.menuType = menuType;
    if (menuType == 2) {
      options.add("Back");
      options.add("3");
      options.add("6");
      options.add("9");
      options.add("12");
      options.add("15");
      return;
    }
    if (menuType == 1) {
      this.options.add("Resume");
    }
    this.options.add("New Maze");
    this.options.add("Load Maze");
    if (menuType == 1) {
      this.options.add("Save Maze");
    }
    this.options.add("Quit");
  }

  public void up() {
    if (this.subMenu != null) {
      this.subMenu.up();
      return;
    }
    this.currOpt --;
    this.currOpt += options.size();
    this.currOpt %= options.size();
  }

  public void down() {
    if (this.subMenu != null) {
      this.subMenu.down();
      return;
    }
    this.currOpt ++;
    this.currOpt %= options.size();
  }

  public void execute() {
    if (this.subMenu != null){
      this.subMenu.execute();
      this.subMenu = null;
      return;
    }
    if (this.menuType == 2) {
      if (this.currOpt == 0){
        return;
      }
      generateMaze((this.currOpt + 1) * 3);
      return;
    }
    switch(options.get(currOpt)) {
    case "Resume" :
      inMenu = false;
      break;
    case"New Maze" :
      this.subMenu = new Menu(2);
      break;
    case"Load Maze" :
      selectInput("Load Maze", "loadFile");
      break;
    case"Save Maze" :
      selectOutput("Save Maze", "saveFile");
      break;
    case"Quit" :
      exit();
      break;
    }
  }

  public boolean esc() {
    if (this.subMenu != null) {
      this.subMenu = null;
    } else if (this.menuType == 1) {
      return false;
    }
    return true;
  }

  public void draw() {
    if (this.subMenu != null){
      this.subMenu.draw();
      return;
    }
    textAlign(CENTER);
    textSize(3f/4 * BUTTON_HEIGHT);
    stroke(255);
    rectMode(CENTER);
    int button = 0;
    for (String option : options) {
      if (button == currOpt) {
        fill(150, 0, 150);
      } else {
        fill(0);
      }
      rect(width/2, BUTTON_START_HEIGHT + button * BUTTON_SEP + button * BUTTON_HEIGHT, BUTTON_WIDTH, BUTTON_HEIGHT);
      fill(255);
      text(option, width/2, BUTTON_START_HEIGHT + button * BUTTON_SEP + button * BUTTON_HEIGHT, BUTTON_WIDTH, BUTTON_HEIGHT);
      button++;
    }
  }
}
