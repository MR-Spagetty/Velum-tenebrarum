public class Menu {

    public static final int BUTTON_WIDTH = 200;
    public static final int BUTTON_HEIGHT = 50;
    public static final int BUTTON_SEP = 25;
    public static final int BUTTON_START_HEIGHT = 50;

    private int currOpt = 0;
    private ArrayList<String> options = new ArrayList<>();

    public Menu(){
        this(false);
    }

    public Menu(boolean main) {
        if (!main) {
            this.options.add("Resume");
        }
        this.options.add("Load Maze");
        this.options.add("Quit");
    }

    public void up() {
        this.currOpt --;
        this.currOpt += options.size();
        this.currOpt %= options.size();
    }

    public void down() {
        this.currOpt ++;
        this.currOpt %= options.size();
    }

    public void execute() {
        switch(options.get(currOpt)) {
            case "Resume" : inMenu = false;break;
            case"Load Maze" : selectInput("Load Maze", "loadFile");break;
            case"Quit" : exit();break;
        }
    }

    public void draw() {
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
