// -- SOUND
import processing.sound.*;
SoundFile backgroundMusic, runSound, jumpSound, spikeSound, crashSound, winSound;

boolean spikeSoundPlayed, crashSoundPlayed, winSoundPlayed;

// -- ESTABLISH CLASSES
Player player1;
Platform platform1;

// -- GLOBAL BOOLEAN VARIABLES
boolean left, right, jump, down, space, mouseClicked;
String facing = "right";

// -- PLATFORM ARRAY
Platform platforms [];
int platformNumber = 0;

// -- PLATFORM SPIKE
PImage spike;

// -- FRAMES
int framesPerChange = 5;
int frames;

// -- WORLD SHIFT
int worldSlice;
float worldShift;

// -- BACKGROUND
PImage worldBackground, skullImage, winBackground, signImage;
String message;

// -- GAME RESULT
String gameResult;
int deaths = 0;
int mins = 0;
int seconds = 0;
int milliSeconds = 0;
int gameFrames = 0;

// -- SETUP
void setup(){
  
  // -- SOUND FILES  
  
  // -- background music
  backgroundMusic = new SoundFile(this,"Background Music.mp3");
  backgroundMusic.amp(0.2);
  
  // -- Run sound
  runSound = new SoundFile(this,"Running sound.mp3");
  runSound.amp(0.2);
  
  // -- Jump sound
  jumpSound = new SoundFile(this,"Jump sound.mp3");
  jumpSound.amp(0.1);
  
  // -- Spike sound
  spikeSound = new SoundFile(this,"Spike sound.mp3");
  spikeSound.amp(0.2);
  spikeSoundPlayed = false;
  
  // -- Spike sound
  crashSound = new SoundFile(this,"Crash sound.mp3");
  crashSound.amp(0.2);
  crashSoundPlayed = false;
  
  // -- Win sound
  winSound = new SoundFile(this,"Win sound.mp3");
  winSound.amp(0.2);
  winSoundPlayed = false;
  
  // -- Game Result
  gameResult = "";
  
  // -- World Shift
  worldSlice = 1;
  worldShift = 0;
  
  // -- Background
  worldBackground = loadImage("platform background.png");
  skullImage = loadImage("skull.png");
  winBackground = loadImage("Win background.png");
  signImage = loadImage("arrow sign.png");
  message = "You're on the wrong side";
  
  // -- no Stroke
  noStroke();
  
  // -- Creates game window
  size(1500, 750);
  
  // -- PLATFORM ARRAY
  platforms = new Platform[36];
  
  
  // -- SMALL PLATFORMS : 40x20 | LARGE PLATFORMS : 200x20
  
  // -- PLATFORM RECIPE: Platform(posX, posY, platformWidth, platformHeight, platformType, fake)
  
  // -- list of platforms:
  platforms[0] = new Platform(100,700,200,20,"solid",false);
  platforms[1] = new Platform(300,600,200,20,"solid",false);
  platforms[2] = new Platform(750,500,200,20,"moving-horizontal",false);
  platforms[3] = new Platform(1200,600,200,20,"largeSpikeTrap",false);
  platforms[4] = new Platform(1720,500,200,20,"solid",false);
  platforms[5] = new Platform(1920,500,200,20,"largeSpikeTrap",false);
  platforms[6] = new Platform(2120,500,200,20,"solid",true);
  platforms[7] = new Platform(2320,500,200,20,"solid",false);
  platforms[8] = new Platform(2570,300,200,20,"moving-vertical",false);
  platforms[9] = new Platform(2770,300,200,20,"moving-vertical",false);
  platforms[9].platSpeed = -platforms[9].platSpeed;
  platforms[10] = new Platform(2970,300,200,20,"moving-vertical",true);
  platforms[11] = new Platform(3170,300,200,20,"moving-vertical",false);
  platforms[11].platSpeed = -platforms[11].platSpeed;
  platforms[12] = new Platform(3470,300,200,20,"solid",false);
  platforms[13] = new Platform(3710,300,200,20,"solid",true);
  platforms[14] = new Platform(3670,300,40,20,"smallSpikeTrap",false);
  platforms[15] = new Platform(4100,500,200,20,"moving-horizontal",false);
  platforms[16] = new Platform(4500,500,200,20,"largeSpikeTrap",false);
  platforms[17] = new Platform(4740,500,200,20,"solid",false);
  platforms[18] = new Platform(4700,500,40,20,"smallSpikeTrap",false);
  platforms[19] = new Platform(4940,300,200,20,"moving-vertical",false);
  platforms[20] = new Platform(5340,100,200,20,"moving-horizontal",false);
  platforms[21] = new Platform(5940,100,200,20,"moving-horizontal",false);
  platforms[21].platSpeed = -platforms[21].platSpeed;
  platforms[22] = new Platform(5440,400,200,20,"largeSpikeTrap",false);
  platforms[23] = new Platform(5840,400,200,20,"solid",false);
  platforms[24] = new Platform(6240,400,200,20,"solid",true);
  platforms[25] = new Platform(6640,400,200,20,"solid",false);
  platforms[26] = new Platform(6880,400,200,20,"solid",false);
  platforms[27] = new Platform(7080,400,200,20,"solid",true);
  platforms[28] = new Platform(6840,400,40,20,"smallSpikeTrap",false);
  platforms[29] = new Platform(7040,400,40,20,"smallSpikeTrap",false);
  platforms[30] = new Platform(7480,400,200,20,"moving-horizontal",false);
  platforms[31] = new Platform(8080,400,200,20,"moving-horizontal",false);
  platforms[31].platSpeed = -platforms[31].platSpeed;
  platforms[32] = new Platform(8680,400,200,20,"moving-horizontal",false);
  platforms[33] = new Platform(9280,400,200,20,"moving-horizontal",false);
  platforms[33].platSpeed = -platforms[33].platSpeed;
  platforms[34] = new Platform(-900,749,200,20,"moving-horizontal",false);
  platforms[34].platSpeed = -platforms[34].platSpeed;
  platforms[35] = new Platform(-1800,749,200,20,"goal",false);

  
  // -- Defaults all movement to false
  left = false;
  right = false;
  jump = false;
  down = false;
  space = false;


  // -- PLAYER CONSTRUCTOR
  player1 = new Player(200,580);
}

// -- MAIN DRAW LOOP
void draw() {
  if (gameResult != "Win"){
    
    // -- MUSIC
    if (backgroundMusic.isPlaying() == false){
      backgroundMusic.play();
    }
    
    // -- frames
    frames = frameCount;
    if (player1.playerDead == false){
      gameFrames += 1;
      
      milliSeconds += 167;
      if (milliSeconds > 1000){
        milliSeconds -= 1000;
      }
      
      
      // -- time
      if (gameFrames % 60 == 0){
        seconds++;
      }
      if (seconds >= 60 && gameFrames % 60 == 0){
        seconds = 0;
        mins++;
      }
    }
    
    // -- white background
    //background(#FFFFFF);
    
    // -- Background
    image(worldBackground,0,0);
    image(skullImage,25,25);
    image(signImage,platforms[1].x+40,platforms[1].y-50);
    image(signImage,platforms[3].x+40,platforms[3].y-50);
    textSize(30);
    text(message,platforms[33].x-50,platforms[33].y-100);
    
    // -- PLAYER METHODS
    player1.update();
    
    // -- Reset platform and player collision values
    player1.sideOfCollision = "none";
    platformNumber = 0;
    // -- Checks each platform for a collision
    while (player1.sideOfCollision == "none" && platformNumber <= (platforms.length - 1)){
      player1.sideOfCollision = hitboxCollisions(player1, platforms[platformNumber]);
      // -- prepares to check next platform
      platformNumber++;
    }
    // -- Checks if player is alive
    if (player1.playerDead != true){
      // -- Checks if player is on the left or right border
      if (player1.border == "left" || player1.border == "right"){
        // -- Checks if player's speed is != 0
        if ((abs(player1.speedX) > 0) && ((left == true && player1.border == "left") || (right == true && player1.border == "right"))){
          // -- sets world shift to player's speed
          worldShift = player1.speedX;
        }
        else{
          // -- checks if player is on the left border
          if (player1.border == "left"){
            // -- matches platspeed
            worldShift = -3;
          }
          // -- checks if player is on the right border
          else if (player1.border == "right"){
            // -- matches platspeed
            worldShift = 3;
          }
        }
        // -- applies world shift to player
      player1.posX -= worldShift;
      }
      
      // -- applies world shift to all platforms in array
      for (int i = 0; i < platforms.length; i++){
        platforms[i].x -= worldShift;
      }

      // -- resets worldshift
      worldShift = 0;
    }
    else{
      
      // -- displays respawn instructions when player is dead
      textSize(100);
      text("Click to respawn",(width/2)-350,(height/2)+100);
      
      // -- checks if player clicked the mouse before respawning
      if (mouseClicked == true){
        backgroundMusic.stop();
        // -- re-executes the setup to restart the game
        setup();
      }
    }
    // -- DISPLAY METHODS
    player1.display();
    
    // -- runs display methods for all platforms in array
    for (int i = 0; i < platforms.length; i++){
        platforms[i].display();
      }
    
    // -- Display Window
    displayWindow();
    
    // -- Position data (for debugging)
    // debuggingWindow();
  }
  
  
  // -- GAME WIN
  else{
    
    // -- stops background music
    backgroundMusic.stop();
    
    // -- records final values 
    int finalMilliSeconds = milliSeconds;
    int finalSeconds = seconds;
    int finalMinutes = mins;
    
    // -- plays the win sound
    if (winSoundPlayed == false){
      winSound.play();
      winSoundPlayed = true;
    }
    
    // -- only executes once win sound is no longer playing
    if (winSound.isPlaying() == false){
      
      // -- displays winning screen
      background(#000000);
      image(winBackground,0,0);
      
      // -- Score Text
      textSize(100);
      textAlign(CENTER);
      
      // -- Special message
      String specialMessage = "";
      
      // -- checks number of player deaths and creates a message
      if (deaths <= 10){
        specialMessage = "You definitely cheated";
      }
      else if (deaths > 10 && deaths <= 20){
        specialMessage = "Not bad";
      }
      else if (deaths > 20 && deaths <= 30){
        specialMessage = "xD";
      }
      else if (deaths > 30 && deaths <= 50){
        specialMessage = "you actually held on for this long?";
      }
      else if (deaths > 50){
        specialMessage = "You did this to yourself";
      }
      
      // -- displays time of death and the total deaths
      String finalResults = "Deaths: "+deaths+
      "\nTime taken: " + finalMinutes + " : " + finalSeconds + " : " + finalMilliSeconds;
      text(finalResults, width/2,height/2-200);
      
      // -- displays special message
      textSize(50);
      text(specialMessage, width/2,height/2+150);
    }
  }
}
    

// -- OVERLAP VARIABLE (shows which side collided)

// -- Hitbox collision string
String hitboxCollisions(Player playerRectangle, Platform platformRectangle) {
  
  // -- Checks if platform type is fake
  if (platformRectangle.fakePlatform != true){
    // -- Check to allow player to pass through platforms (can be disabled)
    if (playerRectangle.speedY < 0 && platformRectangle.platType == "semi-permeable") {
    return "none";
  }
  
    // -- Overlap coordinates
    float dx = (playerRectangle.posX+playerRectangle.hitboxWidth/2) - (platformRectangle.x+platformRectangle.platWidth/2);
    float dy = (playerRectangle.posY+playerRectangle.hitboxHeight/2) - (platformRectangle.y+platformRectangle.platHeight/2);
    
    
    // -- COLLISION CHECK
    
    // -- Combines the player and platforms width & heights
    float totalHitboxWidth = playerRectangle.horizontalSide + platformRectangle.horizontalSide;
    float totalHitboxHeight = playerRectangle.verticalSide + platformRectangle.verticalSide;
    
    // -- Checks if collision has happened on the x - axis
    if (abs(dx) < totalHitboxWidth){
      
      // -- Checks if coliision has occured on the y - axis
      if (abs(dy) < totalHitboxHeight){
        
        
        // -- Calculates the overlap of the player and platform
        float overlapX = totalHitboxWidth - abs(dx);
        float overlapY = totalHitboxHeight - abs(dy);
        
        // -- picks the collision with the smallest overlap
        if (overlapX >= overlapY){
          if (dy > 0){
            
            // -- Moves the player upward to get rid of the overlap
            playerRectangle.posY += overlapY;
            return "top";
          } 
          else{
            // -- Moves player downward to get rid of the overlap
            playerRectangle.posY -= overlapY;
            // -- checks if the platform is a horizontal moving one
            if (platformRectangle.platType == "moving-horizontal"){
              // -- applies platform speed to player
              playerRectangle.posX += platformRectangle.platSpeed;
            }
            // -- checks if the platform is a vertical moving one
            else if (platformRectangle.platType == "moving-vertical"){
              // -- applies platform speed to player
              playerRectangle.posY += platformRectangle.platSpeed;
            }
            // -- Checks if the platform is a spike trap
            if (platformRectangle.platType == "largeSpikeTrap" || platformRectangle.platType == "smallSpikeTrap"){
              // -- Spike sound
              if (spikeSoundPlayed == false){
                spikeSound.play();
                spikeSoundPlayed = true;
                deaths++;
              }
              if (platformRectangle.platType == "largeSpikeTrap"){
                // -- loads spike trap image
                spike = loadImage("large platform spike.png");
              }
              // -- Checks if the platform is a spike trap
              if (platformRectangle.platType == "smallSpikeTrap"){
                // -- loads spike trap image
                spike = loadImage("small platform spike.png");
              }
              
              // -- Kills player
              playerRectangle.playerDead = true;
              playerRectangle.posY+=1;
              image(spike,platformRectangle.x,platformRectangle.y-20);
            }
            // -- Checks if player made it to the goal platform
            if (platformRectangle.platType == "goal"){
              gameResult = "Win";
            }
            return "bottom";
          }
        } 
        else{
          if (dx > 0) {
            // -- Moves player left to get rid of the overlap
            playerRectangle.posX += overlapX;
            return "left";
          } 
          else{
            // -- Moves player right to get rid of the overlap
            playerRectangle.posX -= overlapX;
            return "right";
          }
        }
      } 
      else{
        
        // -- No collision on the top or bottom
        return "none";
      }
    } 
    else{
      // -- No collision on the side
      return "none";
    }
  }
  else{
    return "none";
  }
}

// -- DISPLAY WINDOW METHOD
void displayWindow(){
 textSize(80);
 fill(0);
 
 // -- creates string containing number of deaths
 String deathString = " x " + deaths;
 text(deathString, 125, 100);
 textSize(60);
 
 // -- creates a string of the time
 String timeString = "Time: " + (mins)+ " : " + (seconds)+ " : " + (milliSeconds);
 text(timeString, 1050, 100);
}
 
 

// -- PLAYER CONTROLS CHECK
void keyPressed(){
  
  // -- LEFT key
  switch (key) {
  case 'a':
    left = true;
    facing = "left";
    break;
  // -- RIGHT key
  case 'd':
    right = true;
    facing = "right";
    break;
  // -- JUMP key
  case 'w':
    jump = true;
    break;
  case 's':
  // -- DOWN key
    down = true;
    break;
  case ' ': 
  // -- SPACE key
    space = true;
    break;
  }
}

void keyReleased(){
  switch (key) {
  // -- LEFT key
  case 'a':
    left = false;
    break;
  // -- RIGHT key
  case 'd':
    right = false;
    break;
  // -- JUMP key
  case 'w':
    jump = false;
    break;
  // -- DOWN key
  case 's':
    down = false;
    break;
  // -- SPACE key
  case ' ': 
    space = false;
    break;
  }
}

void mousePressed(){
  mouseClicked = true;
}

void mouseReleased(){
  mouseClicked = false;
}
