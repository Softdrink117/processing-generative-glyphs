String timestamp = "";

String makeTimestamp(){
  String out = "";
  
  out += nf(year(), 4, 0);
  out += "-";
  out += nf(month(), 2, 0);
  out += "-";
  out += nf(day(), 2, 0);
  
  return out;
}

// Return true if there is a bowtie
boolean checkBowtie(int point1, int point2, IntList in){
  boolean out = false;    // Assume false until proven otherwise
  
  if(in.size() < 1) return false;
  
  for(int i = 1; i < in.size(); i++){
    if(in.get(i) == point2 && in.get(i-1) == point1){
      out = true;
      break;
    }
    if(in.get(i) == point1 && in.get(i-1) == point2){
      out = true;
      break;
    }
  }
  
  return out;
}

IntList rotate180(IntList in){
  IntList out = new IntList();
  
  for(int i = 0; i < in.size(); i++){
    out.append(rotate180grid(in.get(i)));
  }
  
  return out;
}

int rotate180grid(int in){
  int out = 0;
  
  out = grid.length - in;
  
  return out;
}

// Check the register for an identical intList of points
// Assume valid until proven otherwise
boolean checkRegister(IntList in){
  boolean out = true;
  
  if(register == null) register = new ArrayList<IntList>();
  if(register.size() == 0){
    register.add(in.copy());
    return true;
  }
  
  // Check the lists, one by one, to compare them
  for(int i = 0; i < register.size(); i++){
    // get the intLists from the register
    IntList temp = register.get(i);
    // If the two lists are not the same size, they cannot be the same
    if(in.size() != temp.size()) continue;
    else{
      int matches = 0;
      //temp.copy().sort();
      // If they are the same size, index through and compare members
      for(int j = 0; j < in.size(); j++){
        // If they do not have the same value in the same place, they cannot be the same
        //if(in.get(j) != temp.get(j)) break;
        if(in.hasValue(temp.get(j))) matches++;
        //else matches++;
      }
      
      if(matches == in.size()-1) out = false;
    }
  }
  
  if(out == true) register.add(in.copy());
  
  return out;
}

void setupPoints(){
  grid = new PVector[gridPointsX * gridPointsY];
  int x = 0;
  int y = 0;
  
  for(int i = 0; i < grid.length; i++){
    grid[i] = new PVector(x, y);
    
    x++;
    if(x >= gridPointsX){
      x = 0;
      y++;
    }
  }
}

void drawPoints(){
  noFill();
  strokeWeight(8.0/viewScale);
  stroke(0,100);
  
  for(int i = 0; i < grid.length; i++){
    point(grid[i].x, grid[i].y);
  }
}

// PreviousValues stores and checks the values of gridPointsX, Y and glyphsX, Y
// to automatically compensate for any changes caused by manipulating the UI
// However, disabling it can lead to some interesting results visually
boolean pollForArrayChanges = true;

int[] previousValues = new int[4];
void setPreviousValues(){
  previousValues[0] = gridPointsX;
  previousValues[1] = gridPointsY;
  previousValues[2] = glyphsX;
  previousValues[3] = glyphsY;
}

void checkPreviousValues(){
  boolean changeGP = false;
  boolean changeGL = false;
  
  if(gridPointsX != previousValues[0]) changeGP = true;
  if(gridPointsY != previousValues[1]) changeGP = true;
  if(glyphsX != previousValues[2]) changeGL = true;
  if(glyphsY != previousValues[3]) changeGL = true;
  
  if(changeGP) setupPoints();
  if(changeGP) println("GridPoints settings have changed!");
  
  if(changeGL) glyphs = new Glyph[glyphsX * glyphsY];
  if(changeGL) regenerate();
  if(changeGL) println("Detected a change in glyph count settings; regenerating batch to prevent errors...");
}

void regenerate(){
  activeGlyphCount = 0;
  glyphInit = 0;
  glyphsCreated = false;
}

void keyReleased(){
  if(key == CODED){
    if(keyCode == CONTROL){
      saveFrame("./Screenshots/Glyph_Creation_Sys_" + timestamp + "#####.png");
    }
  }
  
  if(key == 'r' || key == 'R'){
    regenerate();
  }
}