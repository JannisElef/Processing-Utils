
// color theme ─⬎
//                              bgCol    textCol  lineCol hightlight primary secondary ...
//                             ⬐─┴─⬎  ⬐─┴─⬎  ⬐─┴─⬎  ⬐─┴─⬎  ⬐─┴─⬎  ⬐─┴─⬎
color[] color_theme_gruvbox = {#212121, #ebdbb2, #ebdbb2, #fabd2f, #fb4934, #b8bb26, #83a598};

color COLOR_THEME_BACKGROUND;
color COLOR_THEME_TEXT;
color COLOR_THEME_LINE;
color COLOR_THEME_HIGHLIGHT;
color COLOR_THEME_PRIMARY;
color COLOR_THEME_SECONDARY;
color COLOR_THEME_THIRD;
// color theme ─⬏

// color gradients ─⬎
color[] current_color_gradient;
static color[] color_gradient_rainbow  = {#0000ff, #00ffff, #00ff00, #ffff00, #ff0000, #ff00ff};                            // 🟦🟩🟨🟥 
static color[] color_gradient_plasma   = {#000170, #0001c2, #8700d1, #d10187, #ff0050, #ff7901, #ffbf00, #ffee00, #ffffb0};  // lila, rot, gelb

// ↓ref: https://spectrum.adobe.com/static/images1x/data-vis-color_options_sequential_desktop@2x_1649353411210.png ↓
static color[] color_gradient_virdis   = {#440154, #472f7d, #39568c, #2a788e, #1f988b, #35b779, #7ad151, #d2e21b, #fde725};  // lila, türkis, grün, gelb
static color[] color_gradient_magma    = {#000004, #20114b, #57157e, #8c2981, #c43c75, #f1605d, #fe9f6d, #fddea0, #fcfdbf};  // schwarz, lila, orange, helles orange
static color[] color_gradient_rose     = {#001066, #551672, #892282, #b93495, #e64bac, #f380bc, #fcafcb, #ffddd8, #fff4de};  // lila, magenta, pink, helles pink
static color[] color_gradient_cerulean = {#180055, #1b296d, #1d4c81, #246e96, #3091aa, #58b4b9, #85d5ca, #c9f1e4, #eafff1};  // dunkelblau, petrol, cyan, helles türkis
static color[] color_gradient_forest   = {#00313a, #0e4d41, #1e6a48, #31884f, #4ca658, #79c365, #a6df73, #e2f5bd, #ffffe0};  // dunkelgrün, grün, hellgrün, fast weis
// color gradients ─⬏

// DEBUG ─⬎
static String LOG_ERROR     = "ERROR";
static String LOG_WARNING   = "WARNING";
static String LOG_INFO      = "INFO";

static color LOG_COLOR_ERROR    = #FF0000;
static color LOG_COLOR_WARNING  = #FFFF00;
static color LOG_COLOR_INFO     = #00FF00;
static color LOG_COLOR_SYSTEM   = #00FFFF;

static boolean PRINT_DEBUG_INFO = true;

long sysMillis;
// DEBUG ─⬏

// Font for text ─⬎
PFont font;
// String font_normal = "Cambria";
// String font_bold   = "Cambria Bold";
// String font_italic = "Cambria Italic";
String font_normal = "JetBrainsMono NF Regular";
String font_bold   = "JetBrainsMono NF Bold";
String font_italic = "JetBrainsMono NF Medium Italic";

// Font for text ─⬏

// Interactive ─⬎
PVector mouse_pos;
boolean useMouse = true;
// Interactive ─⬏

float scale = 1;


void util_init() {
    setColortheme(color_theme_gruvbox);
    font = createFont(font_normal, 32);
    textFont(font);
}

// setter ─⬎

void setColortheme(color[] cols_) {
    COLOR_THEME_BACKGROUND = cols_[0];
    COLOR_THEME_TEXT       = cols_[1];
    COLOR_THEME_LINE       = cols_[2];
    COLOR_THEME_HIGHLIGHT  = cols_[3];
    COLOR_THEME_PRIMARY    = cols_[4];
    COLOR_THEME_SECONDARY  = cols_[5];
    COLOR_THEME_THIRD      = cols_[6];
}

void setColorGradient(color[] cols) {
    current_color_gradient = new color[cols.length];
    for (int i = 0; i < cols.length; i++) {
        current_color_gradient[i] = cols[i];
    }
}

// setter ─⬏

// getter ─⬎

color getGradientColor(color[] cols, float x) {
    int n = cols.length - 1;
    float scaledX = x * n;
    int index1 = int(scaledX);
    int index2 = min(index1 + 1, n);
    float blend = scaledX - index1;
    
    color c1 = cols[index1];
    color c2 = cols[index2];
    
    int r = int(red(c1) + blend * (red(c2) - red(c1)));
    int g = int(green(c1) + blend * (green(c2) - green(c1)));
    int b = int(blue(c1) + blend * (blue(c2) - blue(c1)));
    
    return color(r, g, b);
}

float getColorDistance(color c1, color c2) {
    return(abs(red(c1) - red(c2)) + abs(green(c1) - green(c2)) + abs(blue(c1) - blue(c2)));
}

// getter ─⬏

// helper ─⬎

boolean isPointInArea(PVector v, float x_, float y_, float h_, float w_) {
    boolean ret = false;
    if (v == null) ret = false;
    else if (v.x > x_ && v.x < x_ + w_ && v.y > y_ && v.y < y_ + h_) {
        ret = true;
    } else ret = false;
    return ret;
}

// helper ─⬏

// drawing ─⬎

void lineGradient(PGraphics pg, float x1, float y1, float x2, float y2, int numSteps, color c1, color c2) {
    pg.beginDraw();
    pg.pushStyle();
    float stepX = (x2 - x1) / numSteps;
    float stepY = (y2 - y1) / numSteps;
    
    for (int i = 0; i < numSteps; i++) {
        float startX = x1 + i * stepX;
        float startY = y1 + i * stepY;
        float endX = x1 + (i + 1) * stepX;
        float endY = y1 + (i + 1) * stepY;
        
        float t = i / float(numSteps);
        color c = lerpColor(c1, c2, t);
        
        pg.stroke(c);
        pg.line(startX, startY, endX, endY);
    }
    pg.popStyle();
    pg.endDraw();
}

void lineGradient(float x1, float y1, float x2, float y2, int numSteps, color c1, color c2) {
    pushStyle();
    float stepX = (x2 - x1) / numSteps;
    float stepY = (y2 - y1) / numSteps;
    
    for (int i = 0; i < numSteps; i++) {
        float startX = x1 + i * stepX;
        float startY = y1 + i * stepY;
        float endX = x1 + (i + 1) * stepX;
        float endY = y1 + (i + 1) * stepY;
        
        float t = i / float(numSteps);
        color c = lerpColor(c1, c2, t);
        
        stroke(c);
        line(startX, startY, endX, endY);
    }
    popStyle();
}

void drawVector(PVector p1, PVector p2, color col) {
    pushMatrix();
    stroke(col);
    strokeWeight(2);
    line(p1.x, p1.y, p2.x, p2.y);

    // Berechne die Richtung des Vektors
    PVector dir = PVector.sub(p2, p1);
    float arrowSize = 7 *scale; // Größe der Pfeilspitzen

    // Berechne die Winkel für die Pfeilspitzen
    float angle = atan2(dir.y, dir.x);
    float arrowAngle = PI / 6; // Winkel der Pfeilspitzen

    // Berechne die Positionen der umgekehrten Pfeilspitzen
    PVector arrowPoint1 = PVector.fromAngle(angle + PI + arrowAngle);
    arrowPoint1.setMag(arrowSize);
    arrowPoint1.add(p2);

    PVector arrowPoint2 = PVector.fromAngle(angle + PI - arrowAngle);
    arrowPoint2.setMag(arrowSize);
    arrowPoint2.add(p2);

    // Zeichne die umgekehrten Pfeilspitzen
    line(p2.x, p2.y, arrowPoint1.x, arrowPoint1.y);
    line(p2.x, p2.y, arrowPoint2.x, arrowPoint2.y);

    popMatrix();
}

// drawing ─⬏


void system_message(String msgTag, String tag, String msg) {
    color textCol = 0;
    switch(msgTag) {
        case "ERROR":
            textCol = LOG_COLOR_ERROR;
            break;
        case "WARNING":
            textCol = LOG_COLOR_WARNING;
            break;
        case "INFO":
            textCol = LOG_COLOR_INFO;
            break;
    }
    if (PRINT_DEBUG_INFO) {
        println(msgTag + "_" + tag + ":\t" + msg, textCol);
    }
}


void startTime() {
    sysMillis = millis();
}

float stopTime() {
    return(millis() - sysMillis) / 1000.0;
}

long stopTimeMs() {
    return(millis() - sysMillis);
}

String stopTimeString() {
    return nf((millis() - sysMillis) / 1000.0, 0, 3) + "s";
}

String getCurrentFPS() {
    return nf(1000.00 /(float)stopTimeMs(), 0, 2) + " fps";
}


void keyPressed() {
    String pressedKey = "";
    String keyFunction = "";
    if (keyCode == ENTER) {
        pressedKey = "ENTER";
        keyFunction = "save frame";
        save("out/export-" + year() + "." + month() + "." + day() + "_" + hour() + "_" + minute() + "_" + second() + "-" + hex((int)random(Integer.MAX_VALUE)) + ".png");
    }
    println("Pressed [" + pressedKey + "]: " + keyFunction, LOG_COLOR_SYSTEM);
}