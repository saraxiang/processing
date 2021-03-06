import java.awt.AWTException;
import java.awt.Rectangle;
import java.awt.Robot;
import java.util.ArrayList;
import java.util.Collections;
import processing.core.PApplet;

//when in doubt, consult the Processsing reference: https://processing.org/reference/

int margin = 200; //set the margina around the squares
final int padding = 50; // padding between buttons and also their width/height
final int buttonSize = 40; // padding between buttons and also their width/height
ArrayList<Integer> trials = new ArrayList<Integer>(); //contains the order of buttons that activate in the test
int trialNum = 0; //the current trial number (indexes into trials array above)
int startTime = 0; // time starts when the first click is captured
int finishTime = 0; //records the time of the final click
int hits = 0; //number of successful clicks
int misses = 0; //number of missed clicks
int buttonSizeChange = 20;
Robot robot; //initalized in setup 

int clickNum = -1;
int xPosBeg = -1000;
int yPosBeg= -1000;
int xPosTarget;
int yPosTarget;
float timeStart = 0;
float timeClicked = 0;
float s;
float timePassed;

int numRepeats = 20; //sets the number of times each button repeats in the test
boolean firstClick = false;

void logStuff() {
  
  //Check for hit/miss
  int hit = 0;
  Rectangle bounds = getButtonLocation(trials.get(trialNum));
  //check to see if mouse cursor is inside button 
  if ((mouseX > bounds.x && mouseX < bounds.x + bounds.width) && (mouseY > bounds.y && mouseY < bounds.y + bounds.height)) // test to see if hit was within bounds
  {
    //System.out.println("HIT! " + trialNum + " " + (millis() - startTime)); // success
    hit = 1;
  } 
  
  
  clickNum = clickNum + 1;
  timeClicked = millis()/1000.0;
  //timeClicked = round(s * 1000.0f) / 1000.0f;
  if (clickNum != 0) {
      
      xPosTarget = bounds.x + bounds.width/2;
      yPosTarget = bounds.y + bounds.height/2;
      
      timePassed = timeClicked - timeStart;
      
      System.out.println(clickNum + ",SX," + xPosBeg + "," + yPosBeg + "," + xPosTarget + "," + yPosTarget + ",60," + nf(timePassed,0,3) + "," + hit);
  }
  timeStart = timeClicked;
  xPosBeg = mouseX;
  yPosBeg = mouseY;
}
void setup()
{
  size(700, 700); // set the size of the window
  //noCursor(); //hides the system cursor if you want
  noStroke(); //turn off all strokes, we're just using fills here (can change this if you want)
  textFont(createFont("Arial", 16)); //sets the font to Arial size 16
  textAlign(CENTER);
  frameRate(60);
  ellipseMode(CENTER); //ellipses are drawn from the center (BUT RECTANGLES ARE NOT!)
  //rectMode(CENTER); //enabling will break the scaffold code, but you might find it easier to work with centered rects

  try {
    robot = new Robot(); //create a "Java Robot" class that can move the system cursor
  } 
  catch (AWTException e) {
    e.printStackTrace();
  }

  //===DON'T MODIFY MY RANDOM ORDERING CODE==
  for (int i = 0; i < 16; i++) //generate list of targets and randomize the order
      // number of buttons in 4x4 grid
    for (int k = 0; k < numRepeats; k++)
      // number of times each button repeats
      trials.add(i);

  Collections.shuffle(trials); // randomize the order of the buttons
  //System.out.println("trial order: " + trials);
  
  frame.setLocation(0,0); // put window in top left corner of screen (doesn't always work)
}


void draw()
{
  background(0); //set background to black

  if (trialNum >= trials.size()) //check to see if test is over
  {
    float timeTaken = (finishTime-startTime) / 1000f;
    float penalty = constrain(((95f-((float)hits*100f/(float)(hits+misses)))*.2f),0,100);
    fill(255); //set fill color to white
    //write to screen (not console)
    text("Finished!", width / 2, height / 2); 
    text("Hits: " + hits, width / 2, height / 2 + 20);
    text("Misses: " + misses, width / 2, height / 2 + 40);
    text("Accuracy: " + (float)hits*100f/(float)(hits+misses) +"%", width / 2, height / 2 + 60);
    text("Total time taken: " + timeTaken + " sec", width / 2, height / 2 + 80);
    text("Average time for each button: " + nf((timeTaken)/(float)(hits+misses),0,3) + " sec", width / 2, height / 2 + 100);
    text("Average time for each button + penalty: " + nf(((timeTaken)/(float)(hits+misses) + penalty),0,3) + " sec", width / 2, height / 2 + 140);
    return; //return, nothing else to do now test is over
  }

  fill(255); //set fill color to white
  text((trialNum + 1) + " of " + trials.size(), 40, 20); //display what trial the user is on

  for (int i = 0; i < 16; i++)// for all button
    drawButton(i); //draw button

  fill(255, 0, 0, 200); // set fill color to translucent red
  ellipse(mouseX, mouseY, 20, 20); //draw user cursor as a circle with a diameter of 20
  
  //iter2: add a timer
  if(firstClick == true){
    fill(255);
    textSize(30);
    int millis = millis();
    int sec = millis/1000;
    String seconds = str(sec);
    if (sec < 10)
      seconds = "0"+sec;
    int min = sec/60;
    String time = "0"+min+":"+seconds;
    text(time,550,70);
    textSize(17);
    
    
  }
}

void mousePressed() // test to see if hit was in target!
{
  logStuff();
  
  firstClick = true;
  if (trialNum >= trials.size()) //if task is over, just return
    return;

  if (trialNum == 0) //check if first click, if so, start timer
    startTime = millis();

  if (trialNum == trials.size() - 1) //check if final click
  {
    finishTime = millis();
    //write to terminal some output. Useful for debugging too.
    //println("we're done!");
  }

  Rectangle bounds = getButtonLocation(trials.get(trialNum));

 //check to see if mouse cursor is inside button 
  if ((mouseX > bounds.x && mouseX < bounds.x + bounds.width) && (mouseY > bounds.y && mouseY < bounds.y + bounds.height)) // test to see if hit was within bounds
  {
    //System.out.println("HIT! " + trialNum + " " + (millis() - startTime)); // success
    hits++; 
  } 
  else
  {
    //System.out.println("MISSED! " + trialNum + " " + (millis() - startTime)); // fail
    misses++;
  }

  trialNum++; //Increment trial number

  //in this example code, we move the mouse back to the middle
  //robot.mouseMove(352, 400); //on click, move cursor to roughly center of window!
  //System.out.println("trial order: " + trials);
}  

//probably shouldn't have to edit this method
Rectangle getButtonLocation(int i) //for a given button ID, what is its location and size
{
   int x = (i % 4) * (padding + buttonSize) + margin;
   int y = (i / 4) * (padding + buttonSize) + margin;
   //iteration 1
   if ((mouseX > (x - buttonSizeChange) && mouseX < (x + buttonSize + buttonSizeChange)) && (mouseY > (y - buttonSizeChange) && mouseY < (y + buttonSize + buttonSizeChange))) // test to see if mouse is near bounds
   {
     return new Rectangle(x - (buttonSizeChange/2), y - (buttonSizeChange/2), buttonSize + buttonSizeChange, buttonSize + buttonSizeChange);
   }
   else 
   {
     return new Rectangle(x, y, buttonSize, buttonSize);
   }
}

//you can edit this method to change how buttons appear
void drawButton(int i)
{
  Rectangle bounds = getButtonLocation(i);

  //iteration 1
  if (trials.get(trialNum) == i) // see if current button is the target
  {
    if ((mouseX > bounds.x && mouseX < bounds.x + bounds.width) && (mouseY > bounds.y && mouseY < bounds.y + bounds.height)) // test to see if mouse is within bounds
    {
      fill(255, 0, 0); // if hovering over target square, change square to red
    }
    else 
    {
      fill(0, 255, 255); // if so, fill cyan
    }
  }
  else
  {
    fill(200); // if not, fill gray
  }
  
  if ((trialNum + 1 < 16) && trials.get(trialNum + 1) == i) // see if current button is the NEXT target
  {
    fill(75,75,75); // color the next target orange
  }
  
  if ((mouseX > (bounds.x - buttonSizeChange) && mouseX < (bounds.x + bounds.width + buttonSizeChange)) && (mouseY > (bounds.y - buttonSizeChange) && mouseY < (bounds.y + bounds.height + buttonSizeChange))) // test to see if mouse is near bounds
  {
    rect(bounds.x - (buttonSizeChange/2), bounds.y - (buttonSizeChange/2), bounds.width + buttonSizeChange, bounds.height + buttonSizeChange); //draw button
  }
  else 
  { 
   rect(bounds.x, bounds.y, bounds.width, bounds.height); //draw button
  }
}

void mouseMoved()
{
   //can do stuff everytime the mouse is moved (i.e., not clicked)
   //https://processing.org/reference/mouseMoved_.html
}

void mouseDragged()
{
  //can do stuff everytime the mouse is dragged
  //https://processing.org/reference/mouseDragged_.html
}

void keyPressed() 
{
  //can use the keyboard if you wish
  //https://processing.org/reference/keyTyped_.html
  //https://processing.org/reference/keyCode.html
  //iteration 2
  mousePressed();
}