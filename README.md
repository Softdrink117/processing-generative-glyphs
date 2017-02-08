# Processing Generative Glyph System

![alt text](/Glyph_Creation_Sys/Screenshots/Glyph_Creation_Sys_10169.png "Example Output")

A simple tool to procedurally generate a system of glyphs through a brute-force pathfinding algorithm that marches a grid of points. The end result is one or many glyph characters in vector format. Eventually, I plan to use this tool to create a language system for an in-progress game project.

There are several options that influence how the glyphs are generated:
* Chance of diagonal movement can be controlled
* Contours can be drawn as linear or curved
* Contour curviness can be adjusted
* Contour vertices can be skipped to make more intricate or simpler glyphs
* The number of grid points can be adjusted separately in X and Y dimensions

There will eventually be controls for how glyphs are rendered, but they are not currently implemented

---

**A brief explanation of the algorithm:**

1. Begin at a random point in a grid of n x m points 
2. Randomly roll a direction for movement to an adjacent or diagonally adjacent point
  *  The chance of rolling a diagonal is user-adjustable  
3. Check if it is possible to move in that direction 
  *  Check to make sure it is a valid move in terms of X/Y position on the grid  
  *  Check to make sure it does not prematurely close the contour  
  *  Check to make sure it avoids obvious self-intersection  
  *  Check to make sure it avoids "bowties" and other undesirable visual artifacts  
4. If it is a valid move, advance to the new position 
5. Repeat steps 2-5 until either the contour closes itself (returns to the starting position) or the maximum number of samples has been reached 
6. Check the glyph against an existing Register of glyphs that have already been created, to ensure uniqueness 
  *  Rotations and permutations can also be checked, in theory - see below for limitations  
7. Repeat steps 1-6 until either the glyph is fully valid and unique, or the maximum number of samples has been reached 
8. _Optional_ - If the maximum number of samples has been reached on this frame, flag the glyph for additional processing on the next frame. Repeat until the glyph is fully valid and unique

For performance reasons, there are several sampling limiters that are applied to make sure things run smoothly:
* The maximum number of attempts to roll a valid direction is limited
* The maximum number of iterations (complete attempts to step through and close a glyph) is limited
* The maximum number of glyphs that can process at once is limited

All of these limits are user-adjustable, allowing for performance to be tweaked at runtime to suit various machines.

---

**TODO:**
* Further optimization of glyph algorithm
* Account for all rotations (90 and 270 degree are still not accounted for in current implementation)
* Try to account for subtle variations that result in identical visual results (IE do checks by area, or somesuch)
* Add rendering options
* Figure out how to license this!
