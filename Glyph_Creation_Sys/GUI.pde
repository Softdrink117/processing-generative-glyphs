ControlFrame cf;

void setupControlFrame(){
  surface.setLocation(420,10);
  cf = new ControlFrame(this, 400, 800, "Controls");
}

// External window for controls
class ControlFrame extends PApplet {

  int w, h;
  PApplet parent;
  ControlP5 cp5;

  color UIBGcolor = color(20);

  public ControlFrame(PApplet _parent, int _w, int _h, String _name) {
    super();   
    parent = _parent;
    w=_w;
    h=_h;
    PApplet.runSketch(new String[]{this.getClass().getName()}, this);
  }

  public void settings() {
    size(w, h);
  }

  public void setup() {
    surface.setLocation(10, 10);
    
    cp5 = new ControlP5(this);
    
    cp5.setColorForeground(color(120));
    cp5.setColorBackground(color(60));
    cp5.setColorActive(color(160));
    
    // Major glyph style toggles --
    cp5.addToggle("Draw as Curves")
       .plugTo(parent, "useCurveVertices")
       .setPosition(10, 10)
       .setSize(240, 30)
       .setValue(true)
       ;
       
    cp5.addToggle("Auto-close Contours")
       .plugTo(parent, "closeGlyph")
       .setPosition(10,60)
       .setSize(240,30)
       .setValue(false)
       ;
       
    cp5.addToggle("Reduce Bowties")
       .plugTo(parent, "preventBowties")
       .setPosition(10,110)
       .setSize(240,30)
       .setValue(true)
       ;
       
    // The BIG REGENERATE BUTTON, woo~
    cp5.addBang("Regenerate")
       .plugTo(parent, "regenerate")
       .setPosition(260,10)
       .setSize(130,130)
       ;
       
  // Slider for X,Y grid points -----
    cp5.addSlider("Grid Points X")
       .plugTo(parent, "gridPointsX")
       .setRange(1, 20)
       .setValue(8)
       .setPosition(10, 180)
       .setSize(120, 30)
       .setNumberOfTickMarks(20)
       .snapToTickMarks(true)
       .showTickMarks(false)
       ;
       
    cp5.addSlider("Grid Points Y")
       .plugTo(parent, "gridPointsY")
       .setRange(1, 20)
       .setValue(8)
       .setPosition(10, 220)
       .setSize(120, 30)
       .setNumberOfTickMarks(20)
       .snapToTickMarks(true)
       .showTickMarks(false)
       ;
       
    // Slider for X,Y glyph count -----
    cp5.addSlider("Glyphs X")
       .plugTo(parent, "glyphsX")
       .setRange(1, 30)
       .setValue(10)
       .setPosition(220, 180)
       .setSize(120, 30)
       .setNumberOfTickMarks(30)
       .snapToTickMarks(true)
       .showTickMarks(false)
       ;
       
    cp5.addSlider("Glyphs Y")
       .plugTo(parent, "glyphsY")
       .setRange(1, 30)
       .setValue(10)
       .setPosition(220, 220)
       .setSize(120, 30)
       .setNumberOfTickMarks(30)
       .snapToTickMarks(true)
       .showTickMarks(false)
       ;
    
    // Glyph generation controls -------------------------
    cp5.addSlider("Minimum Complexity")
       .plugTo(parent, "minimumComplexity")
       .setRange(1, 300)
       .setValue(40)
       .setPosition(10, 280)
       .setSize(290, 30)
       ;
       
    cp5.addSlider("Diagonal Chance")
       .plugTo(parent, "diagonalChance")
       .setRange(0, 1)
       .setValue(0.05)
       .setPosition(10, 320)
       .setSize(290, 30)
       ;
       
    cp5.addSlider("Vertex Skip")
       .plugTo(parent, "vertexSkip")
       .setRange(0, 4)
       .setValue(0)
       .setPosition(10, 360)
       .setSize(290, 30)
       .setNumberOfTickMarks(5)
       .snapToTickMarks(true)
       .showTickMarks(false)
       ;
       
    // Performance toggles -----------
    cp5.addSlider("Active Glyph Limit")
       .plugTo(parent, "activeGlyphLimit")
       .setRange(1, 30)
       .setValue(15)
       .setPosition(10, 420)
       .setSize(290, 30)
       .setNumberOfTickMarks(31)
       .snapToTickMarks(true)
       .showTickMarks(false)
       ;
       
    cp5.addSlider("Directional Samples")
       .plugTo(parent, "maxDirSamples")
       .setRange(100, 3000)
       .setValue(200)
       .setPosition(10, 460)
       .setSize(290, 30)
       ;
       
    cp5.addSlider("Maximum Iterations")
       .plugTo(parent, "maxAttempts")
       .setRange(50, 1500)
       .setValue(100)
       .setPosition(10, 500)
       .setSize(290, 30)
       ;
       
       
    // Technical toggles
    cp5.addToggle("Poll for Array Changes")
       .plugTo(parent, "pollForArrayChanges")
       .setPosition(10,750)
       .setSize(50,20)
       .setValue(true)
       .setMode(ControlP5.SWITCH)
       ;
       
    cp5.addToggle("Limit Active Glyphs")
       .plugTo(parent, "limitActivelyGeneratingGlyphs")
       .setPosition(130,750)
       .setSize(50,20)
       .setValue(true)
       .setMode(ControlP5.SWITCH)
       ;
       
    cp5.addToggle("Check for 180 Rotations")
       .plugTo(parent, "checkInversions")
       .setPosition(240,750)
       .setSize(50,20)
       .setValue(true)
       .setMode(ControlP5.SWITCH)
       ;
       
    
       
  }

  void draw() {
    background(UIBGcolor);
    
    noStroke();
    fill(255);
    // Headers describing control subsections
    text("Grid Options ", 10, 170);
    text("Glyph Generation Options ", 10, 270);
    text("Performance Options ", 10, 410);
    
    // Boxes below headers
    fill(255,10);
    //stroke(120);
    //strokeWeight(0.25);
    noStroke();
    rectMode(CORNER);
    rect(10,173,380,82);
    rect(10,273,380,122);
    rect(10,413,380,122);
    
    // Lines below headers
    noFill();
    stroke(255);
    strokeWeight(0.5);
    line(10,173, 390,173);
    line(10,273, 390,273);
    line(10,413, 390,413);
  }
   
}