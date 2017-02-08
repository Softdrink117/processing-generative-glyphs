Class Glyph;

int maxDirSamples = 200;
int maxAttempts = 100;

boolean checkInversions = true;  // Should the Register check also account for 180deg rotations?

boolean preventBowties = true;    // Should we attempt to reduce the number of "bowties" or not
                                  // This can dramatically affect both appearance and performance
                                  
float diagonalChance = 0.05;      // How likely 0...1 is a diagonal move vs a linear move?

int minimumComplexity = 40;       // How many steps "backwards" can it move? This effectively measures
                                  // the overall effective complexity of the glyph
                                  
int vertexSkip = 0;               // Should any vertices be skipped in creating the final glyph?

ArrayList<IntList> register = new ArrayList<IntList>();

class Glyph{
  int[] contourPoints;
  int[] orderedContourPoints;
  
  PShape glyph;
  
  int leng;
  
  boolean forceClosed = false;
  
  Glyph(){
    resetGlyph();
    
  }
  
  void updateGlyph(){
    if(forceClosed) resetGlyph();
  }
  
  void drawGlyph(){
    pushMatrix();
    noStroke();
    fill(0);
    shapeMode(CORNER);
    shape(glyph,0,0);
    popMatrix();
  }
  
  void drawGlyph(float size){
    pushMatrix();
    if(useCurveVertices) scale(size/(gridPointsX-0.5));
    else scale(size/(gridPointsX-0.5));
    noStroke();
    //stroke(0);
    //strokeWeight(2/glyphsX);
    fill(0);
    shapeMode(CORNER);
    //shape(glyph,0,0, size, size);
    shape(glyph,0,0);
    popMatrix();
  }
  
  void drawPoints(float size){
    pushMatrix();
    // scale(size);
    noFill();
    stroke(120);
    strokeWeight(80.0/size);
    for(int i = 0; i < grid.length; i++){
      point(grid[i].x, grid[i].y);
    }
    popMatrix();
  }
  
  void resetGlyph(){
    // An explanation of the brute-force method used:
    // 1) Choose an initial point at random
    // 2) Choose a direction to walk at random (cardinals + diagonals)
    // 3) Step, making sure not to move backwards
    // 4) Once you have returned to the initial point, the contour is considered closed
    // Some additional rules are also in place:
    // -An object cannot intersect with itself within a certain "history distance" 
    // defined by the minimumComplexity value above
    // -There are tests to avoid "bowties" and odd angle wrapping 
    // -Objects are tested against each other to make sure they are each unique
    // -There are limits on directional samples and total attempts per frame
    
    // Denote that a glyph is trying to actively generate, but only increment
    // the counter if it has not been force closed once already
    if(!forceClosed) activeGlyphCount++;
    
    
    int attempts = 0;    // How many tries did it take to brute-force construct the glyph?
    
    // Setup contourPoints temp list
    IntList cpTemp = new IntList();
    int cpCache = 0;
    int cppCache = 0;

    
    // Choose an origin point
    int currentPosition = int(random(0,grid.length));
    cpTemp.append(currentPosition);
    
    // Try to complete a contour with the entire length set at the start
    boolean isContourClosed = false;
    forceClosed = false;
    // Brute force the contour calculation
    while(isContourClosed == false){
      
    
    
    // Temp variable to store the offset from current position
    int temp = 0;
    
        // A direction is only valid if it falls within the limits
        // of the grid
        boolean isValidDir = false;
        int dirCount = 0;      // Prevents infinite loop/forkbomb behavior
        // Reroll direction until valid
        while(isValidDir == false){
          // Choose whether to go UDLR based on a random
          float dir = random(0,1);
          
          
          // Calc diagonals
          if(dir >= diagonalChance){
            dir = random(0,1);
            
            if(dir >= 0.75) temp = -gridPointsX;      // UP
            else if(dir >= 0.5) temp = gridPointsX;   // DOWN
            else if(dir >= 0.25) temp = -1;           // LEFT
            else temp = 1;                            // RIGHT
          }else{
            dir = random(0,1);
            
            if(dir >= 0.75) temp = -gridPointsX -1;        // U\L
            else if(dir >= 0.5) temp = -gridPointsX +1;    // U\R
            else if(dir >= 0.25) temp = gridPointsX -1;    // D\L
            else temp = gridPointsX +1;                    // D\R
          }
          
          
          // Check if valid within array index
          int test = currentPosition +temp;
          if(test >= 0){
            if(test < grid.length) isValidDir = true;
          }
          
          // Check if it is going L on an L edge, or vice versa
          if(temp == -1 && currentPosition % gridPointsX == 0) isValidDir = false;
          if(isValidDir) if(temp == 1 && currentPosition % gridPointsX == gridPointsX-1) isValidDir = false;
          // Up/Down checks are already handled above by the array endpoint check
          
          // As above, for diagonals
          if(isValidDir) if(temp == -gridPointsX-1 && currentPosition % gridPointsX == 0) isValidDir = false;
          if(isValidDir) if(temp == -gridPointsX+1 && currentPosition % gridPointsX == gridPointsX-1) isValidDir = false;
          if(isValidDir) if(temp == gridPointsX-1 && currentPosition % gridPointsX == 0) isValidDir = false;
          if(isValidDir) if(temp == gridPointsX+1 && currentPosition % gridPointsX == gridPointsX-1) isValidDir = false;
          
          // Check for and prevent bowties, if desired
          if(preventBowties && isValidDir){
            // A bowtie occurs when we are traveling diagonally between two points of a square, and the
            // other two points of the square have already been traversed by the program in the opposite direction
            // UP/LEFT so check DOWN/RIGHT
            if(temp == -gridPointsX - 1){
              if(checkBowtie(test+1, currentPosition - 1, cpTemp)) isValidDir = false;
            }
            // UP/RIGHT so check DOWN/LEFT
            if(temp == -gridPointsX + 1){
              if(checkBowtie(test-1, currentPosition + 1, cpTemp)) isValidDir = false;
            }
            // DOWN/LEFT so check UP/RIGHT
            if(temp == gridPointsX - 1){
              if(checkBowtie(currentPosition + 1, test - 1, cpTemp)) isValidDir = false;
            }
            // DOWN/RIGHT so check UP/LEFT
            if(temp == gridPointsX + 1){
              if(checkBowtie(currentPosition -1, test + 1, cpTemp)) isValidDir = false;
            }
          }
          
          // Check to make sure it's not going backwards, and it is at least as complex as
          // the minimumComplexity value
          if(isValidDir && cpTemp.size() > 0){
            if(test == cpTemp.get(cpTemp.size() - 1)) isValidDir = false;
            for(int i = 1; i < minimumComplexity; i++){
            
              if(cpTemp.size() > i){
                if(test == cpTemp.get(cpTemp.size() -(i + 1))) isValidDir = false;
              }
            }
          }
          if(isValidDir) if(test == cpCache) isValidDir = false;
          if(isValidDir) if(currentPosition + temp  == cppCache) isValidDir = false;
          
          // Reset the value of temp if it isn't valid
          if(!isValidDir) temp = 0;
          
          dirCount++;
          
          if(dirCount > maxDirSamples){
            isValidDir = true;
            forceClosed = true;
          }
        }
        
        // If it is valid, set it and adjust the new current position
        cpTemp.append(currentPosition + temp);
        currentPosition += temp;
      
      cpCache = currentPosition;
      cppCache = cpCache;
      
      // Check if the contour is closed
      if(cpTemp.get(0) == currentPosition) isContourClosed = true;
      
      attempts++;
      if(attempts > maxAttempts){
        isContourClosed = true;
        forceClosed = true;
      }
      
      //println("Creating glyph... iteration " + attempts);
    
    }
    // Finally, check it against the Register of existing glyphs
    if(isContourClosed && !forceClosed) forceClosed = !checkRegister(cpTemp);
    // And do so again for the 180deg rotation
    if(isContourClosed && !forceClosed && checkInversions) forceClosed = !checkRegister(rotate180(cpTemp));
      
    contourPoints = cpTemp.array();
    leng = contourPoints.length;
    
    String pointList = "";
    for(int i = 0; i < contourPoints.length; i++){
      pointList += nf(contourPoints[i],1,0);
      pointList += ",";
    }
    //println("Created glyph with points " + pointList + " after " + attempts + " iterations");
    pushMatrix();
    if(useCurveVertices) scale(100);
    
    if(useCurveVertices) curveTightness(curveTightness);
    glyph = createShape();
    glyph.beginShape();
    glyph.fill(0);
    glyph.noStroke();
    // glyph.stroke(0,0,0);
    // glyph.strokeWeight(1/float(glyphsX));
    
    // Make a shape out of the contour
    for(int i = 0; i < contourPoints.length; i += 1 + vertexSkip){
      //glyph.fill(random(0,255));
      if(!useCurveVertices) glyph.vertex(grid[contourPoints[i]].x, grid[contourPoints[i]].y);
      else glyph.curveVertex(grid[contourPoints[i]].x, grid[contourPoints[i]].y);
    }
    
    // If the vertex skip causes us to miss the final point
    if(contourPoints.length % (1 + vertexSkip) == 1){
      if(!useCurveVertices) glyph.vertex(grid[contourPoints[contourPoints.length-1]].x, grid[contourPoints[contourPoints.length-1]].y);
      else glyph.curveVertex(grid[contourPoints[contourPoints.length-1]].x, grid[contourPoints[contourPoints.length-1]].y);
    }
    
    if(!closeGlyph) glyph.endShape();
    else glyph.endShape(CLOSE);
    
    popMatrix();
    
    // If the glyph was not force closed, remove it from the active glyph count
    if(!forceClosed) activeGlyphCount--;
  }
}