public color text = 0;
public color background = 0;

private boolean bold = false;
private boolean dim = false;
private boolean italic = false;
private boolean underline = false;
private boolean blinking = false;
private boolean inverse = false;
private boolean hidden = false;
private boolean strikethrough = false;
private boolean bright = false;

/*
ANSI Escape Codes reference: https://gist.github.com/fnky/458719343aabd01cfb17a3a4f7296797
*/

// Internal Colors
private final color COLOR_BLACK  = #FF000000;
private final color COLOR_RED    = #FFFF0000;
private final color COLOR_GREEN  = #FF00FF00;
private final color COLOR_YELLOW = #FFFFFF00;
private final color COLOR_BLUE   = #FF0000FF;
private final color COLOR_PURPLE = #FFFF00FF;
private final color COLOR_CYAN   = #FF00FFFF;
private final color COLOR_WHITE  = #FFFFFFFF;

private static final String prefix = "\033[";
private String              infix = "";
private static final String suffix = "m";

// Reset
private static final String RESET = "\033[0m";  // Text Reset

// Regular Colors
private static final int BLACK = 30;   // BLACK
private static final int RED = 31;     // RED
private static final int GREEN = 32;   // GREEN
private static final int YELLOW = 33;  // YELLOW
private static final int BLUE = 34;    // BLUE
private static final int PURPLE = 35;  // PURPLE
private static final int CYAN = 36;    // CYAN
private static final int WHITE = 37;   // WHITE


public void setTextColor(color col) {
    text = col;
} 

public void setBackgroundColor(color col) {
    background = col;
} 

public void setStyle(boolean bold_, boolean dim_, boolean italic_, boolean underline_, boolean blinking_, boolean inverse_, boolean hidden_, boolean strikethrough_, boolean bright_) {
    bold = bold_;
    dim = dim_;
    italic = italic_;
    underline = underline_;
    blinking = blinking_;
    inverse = inverse_;
    hidden = hidden_;
    strikethrough = strikethrough_;
    bright = bright_;
}

public void setBold(boolean bold_) {
    bold = bold_;
}

public void setDim(boolean dim_) {
    dim = dim_;
}

public void setItalic(boolean italic_) {
    italic = italic_;
}

public void setUnderline(boolean underline_) {
    underline = underline_;
}

public void setBlinking(boolean blinking_) {
    blinking = blinking_;
}

public void setInverse(boolean inverse_) {
    inverse = inverse_;
}

public void setHidden(boolean hidden_) {
    hidden = hidden_;
}

public void setStrikethrough(boolean strikethrough_) {
    strikethrough = strikethrough_;
}

public void setBright(boolean bright_) {
    bright = bright_;
}

public void reset() {
    bold = false;
    dim = false;
    italic = false;
    underline = false;
    blinking = false;
    inverse = false;
    hidden = false;
    strikethrough = false;
    bright = false;
    
    System.out.println(RESET);
}

public void println(String str, color text_, color background_) {
    System.out.println(getColorString(text_, false) + getColorString(background_, true) + str + RESET);
}
public void print(String str, color text_, color background_) {
    System.out.print(getColorString(text_, false) + getColorString(background_, true) + str + RESET);
}


public void println(String str, color text_) {
    System.out.println(RESET + getColorString(text_, false) + str + RESET);
}
public void print(String str, color text_) {
    System.out.print(RESET + getColorString(text_, false) + str + RESET);
}


// public void println(String str) {
//     System.out.println(getColorString(text, false) + getColorString(background, true) + str +RESET);
// }
// public void print(String str) {
//     System.out.print(getColorString(text, false) + getColorString(background, true) + str +RESET);
// }

private String getColorString(color col, boolean isBackground) {
    String out = "";
    color c = getClosestColor(col); // get correct color (if color isnt exact) 
    int colVal = 0;
    switch(c) {
        case COLOR_BLACK:
            colVal = BLACK;
            break;
        case COLOR_RED:
            colVal = RED;
            break;
        case COLOR_GREEN:
            colVal = GREEN;
            break;
        case COLOR_YELLOW:
            colVal = YELLOW;
            break;
        case COLOR_BLUE:
            colVal = BLUE;
            break;
        case COLOR_PURPLE:
            colVal = PURPLE;
            break;
        case COLOR_CYAN:
            colVal = CYAN;
            break;
        case COLOR_WHITE:
            colVal = WHITE;
            break;
    }
    // color Value
    if (isBackground) colVal += 10;  // color is background
    if (bright) colVal += 60;        // color is bright
    
    // infix
    infix = "";
    if (bold) infix += "1;";
    if (dim) infix += "2;";
    if (italic) infix += "3;";
    if (underline) infix += "4;";
    if (blinking) infix += "5;";
    if (inverse) infix += "7;";
    if (hidden) infix += "8;";
    if (strikethrough) infix += "9;";
    
    out = prefix + infix + colVal + suffix;
    if (alpha(col) == 0) out = ""; // soft reset
    return out;
}

private color getClosestColor(color col) {
    color currentCol = 0;
    color ret = 0;
    float bestDistance = 1000;
    float d;
    
    for (int i = 0; i < 8; i++) {
        switch(i) {
            case 0:
                currentCol = COLOR_BLACK;
                break;
            case 1:
                currentCol = COLOR_RED;
                break;
            case 2:
                currentCol = COLOR_GREEN;
                break;
            case 3:
                currentCol = COLOR_YELLOW;
                break;
            case 4:
                currentCol = COLOR_BLUE;
                break;
            case 5:
                currentCol = COLOR_PURPLE;
                break;
            case 6:
                currentCol = COLOR_CYAN;
                break;
            case 7:
                currentCol = COLOR_WHITE;
                break;
        }
        d = getColorDistance(currentCol, col);
        if (d < bestDistance) {
            bestDistance = d;
            ret = currentCol;
        }
    }
    return ret;
}


void testColorPrint() {
    color cols[];
    cols = new color[9];
    cols[0] = 0;
    cols[1] = #FF000000;
    cols[2] = #FFFF0000;
    cols[3] = #FF00FF00;
    cols[4] = #FFFFFF00;
    cols[5] = #FF0000FF;
    cols[6] = #FFFF00FF;
    cols[7] = #FF00FFFF;
    cols[8] = #FFFFFFFF;
    
    setBold(true);
    setUnderline(true);
    println("normal      \tbright      \tbold        \tdim         \titalic      \tunderline   \tblinking    \tinverse     \thidden      \tstrikethrough\teverything", #FFFFFF, 0);
    reset();
    for (int j = 0; j < cols.length; j++) {
        for (int i = 0; i < cols.length; i++) {
            print("    TEST    ", cols[i], cols[j]);
            print("|\t|", 0, 0);
            
            setBright(true);
            print("    TEST    ", cols[i], cols[j]);
            print("|\t|", 0, 0);
            setBright(false);
            
            setBold(true);
            print("    TEST    ", cols[i], cols[j]);
            print("|\t|", 0, 0);
            setBold(false);
            
            setDim(true);
            print("    TEST    ", cols[i], cols[j]);
            print("|\t|", 0, 0);
            setDim(false);
            
            setItalic(true);
            print("    TEST    ", cols[i], cols[j]);
            print("|\t|", 0, 0);
            setItalic(false);
            
            setUnderline(true);
            print("    TEST    ", cols[i], cols[j]);
            print("|\t|", 0, 0);
            setUnderline(false);
            
            setBlinking(true);
            print("    TEST    ", cols[i], cols[j]);
            print("|\t|", 0, 0);
            setBlinking(false);
            
            setInverse(true);
            print("    TEST    ", cols[i], cols[j]);
            print("|\t|", 0, 0);
            setInverse(false);
            
            setHidden(true);
            print("    TEST    ", cols[i], cols[j]);
            print("|\t|", 0, 0);
            setHidden(false);
            
            setStrikethrough(true);
            print("    TEST    ", cols[i], cols[j]);
            print("|\t|", 0, 0);
            setStrikethrough(false);
            
            setStyle(true, true, true, true, true, true, false, true, true);
            print("    TEST    ", cols[i], cols[j]);
            reset();
            print("\n", 0, 0);
        }
    }
}