// Procedural Glyph creation system
// Created for "Project Iron" (Working title) by Tobias Heinemann c. Jan 2017
// All rights reserved

//// INTRODUCTION
// The basic concept is to create a language of glyphs that are composed of simple grid based structures
// Imagine an NxN grid of points, evenly spaced. Then draw a continuous contour composed of linear segments
// between these points, and close and fill the contour. This is the basic premise behind this program.
// Specifics: -No repetitions  -No rotations

//// IMPORT ================================================================================================

import controlP5.*;

//// =======================================================================================================

// GRID SETUP -----
int gridPointsX = 8;
int gridPointsY = 8;
PVector[] grid = new PVector[gridPointsX * gridPointsY];

// GLYPH SETUP -----
Glyph glyph;
int glyphInit = 0;                // DO NOT MODIFY
boolean glyphsCreated = false;    // DO NOT MODIFY

int glyphsX = 10;
int glyphsY = 10;
Glyph[] glyphs = new Glyph[glyphsX * glyphsY];
int padding = 2;

float curveTightness = -1;
boolean useCurveVertices = true;
boolean closeGlyph = false;

// PERFORMANCE OPTIONS -----
boolean limitActivelyGeneratingGlyphs = true;
int activeGlyphLimit = 15;
int activeGlyphCount = 0;        // DO NOT MODIFY

// RENDERING OPTIONS -----
color BGcolor = color(250);
float viewScale = 200;

boolean fillGlyphs = true;
boolean strokeGlyphs = true;
color fillColor = color(0);
color strokeColor = color(0);
float strokeWeight = 2.0;

//// =======================================================================================================

// SETUP ----- 
void settings(){
  size(1000,1000,P2D);
}
void setup(){
  //size(1000,1000, P2D);
  // Setup control frame
  setupControlFrame();
  
  // Create timestamp
  timestamp = makeTimestamp();
  
  // Create point grid
  setupPoints();
  
  // Create glyph
  glyph = new Glyph();
  
  // Initialize glyphs
  glyphInit = 0;
  
}

// DRAW -----
void draw(){
  // Update points array if size has changed from UI interaction
  if(pollForArrayChanges) checkPreviousValues();
  
  // Initialize glyphs based on current progress
  if(!glyphsCreated){
    // As a performance optimization, we can impose a limit on the 
    // number of glyphs that can be generating at once
    if(limitActivelyGeneratingGlyphs){
      if(activeGlyphCount < activeGlyphLimit){
        glyphs[glyphInit] = new Glyph();
        glyphInit++;
      }
    }else{
      // Otherwise, create a new glyph every frame
      glyphs[glyphInit] = new Glyph();
      glyphInit++;
    }
    
    if(glyphInit >= glyphs.length){
      glyphInit = glyphs.length;
      glyphsCreated = true;
    }
  }
  
  //background(BGcolor);
  rectMode(CORNER);
  fill(255,100);
  noStroke();
  rect(0,0,width, height);
  
  pushMatrix();
  translate(padding/2, padding/2);
  //scale(viewScale);
  
  // Draw points
  //drawPoints();
  
  //// Create new glyph
  ////glyph = new Glyph();
  glyph.drawGlyph();
  
  int cellWidth = width/glyphsX;
  cellWidth -= padding;
  int cellSize = cellWidth - padding;
  int xCount = 0;
  int yCount = 0;
  // Draw glyphs
  for(int i = 0; i < glyphInit; i++){
    glyphs[i].updateGlyph();
    pushMatrix();
    translate(cellWidth * xCount + padding + padding*(xCount-1), cellWidth * yCount + padding + padding*(yCount-1));
    fill(255);
    noStroke();
    rectMode(CORNER);
    //rect(0,0,cellWidth, cellWidth);
    
    translate(padding/2, padding/2);
    //scale(cellSize);
    glyphs[i].drawGlyph(cellSize);
    //glyphs[i].drawGlyph(100);
    popMatrix();
    
    xCount++;
    if(xCount >= glyphsX){
      xCount = 0; 
      yCount++;
    }
  }
  
  popMatrix();

  if(pollForArrayChanges) setPreviousValues();
  
  if(frameCount % 480 == 1) println(frameRate);
  
}