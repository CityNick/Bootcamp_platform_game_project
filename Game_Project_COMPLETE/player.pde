// -- Establishes Player class
class Player {
  
  // -- PLAYER APPEARANCE
  
  // -- MOVEMENT ARRAYS
  PImage playerImage;
  PImage [] playerRunImagesRight;
  PImage [] playerRunImagesLeft;
  int positionNumber = 0;
  
  // -- PLAYER DEAD
  boolean playerDead;
  
  // -- PLAYER FEATURES
  // -- Player colour
  color playerHitboxColour;
  // -- Player Hitbox dimensions
  float hitboxWidth, hitboxHeight;
  // -- Player position variables
  float posX, posY;
  // -- Player speed variables
  float speedX, speedY, maxSpeed;
  // -- Player acceleration variables
  float xAccel, yAccel;
  
  // -- World forces variables
  float forceFriction, forceRebound, forceGravity;
  
  // -- Jump related variables
  boolean grounded;
  float jumpPower;
  
  // -- World collision variables
  float horizontalSide, verticalSide;
  String sideOfCollision, onPlatform;
  String border;
  
  // -- INITIALISE METHOD
  Player(float startPosX,float startPosY) {   
    
    // -- PLAYER DEAD
    playerDead = false;
    
    // -- RIGHT SIDE ARRAY
    playerRunImagesRight = new PImage[4];
    playerRunImagesRight[0] = loadImage("RunningPosition1 (Right).png");
    playerRunImagesRight[1] = loadImage("RunningPosition2 (Right).png");
    playerRunImagesRight[2] = loadImage("RunningPosition3 (Right).png");
    playerRunImagesRight[3] = loadImage("RunningPosition4 (Right).png");
    
    // -- LEFT SIDE ARRAY
    playerRunImagesLeft = new PImage[4];
    playerRunImagesLeft[0] = loadImage("RunningPosition1 (Left).png");
    playerRunImagesLeft[1] = loadImage("RunningPosition2 (Left).png");
    playerRunImagesLeft[2] = loadImage("RunningPosition3 (Left).png");
    playerRunImagesLeft[3] = loadImage("RunningPosition4 (Left).png");
    
    
    // -- Player starting image
    playerImage = loadImage("Standing (Right).png");
    
    // -- Player colour
    playerHitboxColour = color(255,0,0,0);
    
    // -- Hitbox size
    hitboxWidth = 35;
    hitboxHeight = 40;
    
    // -- Starting position
    posX = startPosX;
    posY = startPosY;
    
    // -- Speed
    speedX = 0;
    speedY = 0;
    maxSpeed = 10;
    
    // -- Acceleration starting values
    xAccel = 0;
    yAccel = 0;
    
    // -- Ground check and jump
    grounded = false;
    jumpPower = -10;

    // -- World forces values
    forceFriction = 0.96;         // -- decrease to increase friction (main: 0.96)
    forceRebound = -0.5;          // -- (main: -0.5)
    forceGravity = 0.3;           // -- (main: 0.3)
    
    // -- World collision values
    horizontalSide = hitboxWidth/2;
    verticalSide = hitboxHeight/2;
    sideOfCollision = "none";
    border = "none";
  }

  void update() {
    if (playerDead == false){
      // -- LEFT MOVEMENT
      if (left == true && right == false) {
        // -- adds acceleration to the right
        xAccel = -0.2;
        // -- removes friction
        forceFriction = 1;
        // -- change orientation to right
      }
      
      // -- RIGHT MOVEMENT
      if (right == true && left == false) {
        // -- adds acceleration to the left
        xAccel = 0.2;
        // -- removes friction
        forceFriction = 1;
        // -- change orientation to left
      }
      
      // -- NO HORIZONTAL MOVEMENT
      if (left == false && right == false) {
        // -- no acceleration
        xAccel = 0;
      }
      
      // -- JUMP CHECK
      
      // -- checks for jump
      if (jump == true && down == false && grounded == true) {   
        jumpSound.play();
        // -- Applies jump force
        speedY = jumpPower;
        // -- no longer on ground
        grounded = false;
        // -- removes friction
        forceFriction = 1;
      }
      
      // -- player controlled falling speed
      if (down == true && jump == false) {
        // -- makes player fall faster
        yAccel = 0.3;
        // -- removes friction
        forceFriction = 1;
      }
      else{
        yAccel = 0;
      }
      
      // -- NO MOVEMENT AT ALL
      if (jump == false && down == false && left == false && right == false) {
        // -- returns friction to normal
        forceFriction = 0.96; 
      }
      
      
      // -- APPLYING ACCELERATION
      
      // -- applies acceleration
      speedX += xAccel;
      speedY += yAccel;
   
   
      // -- APPLYING FORCES
      
          // -- applies gravity
      speedY += forceGravity;
      // -- applies friction
      speedX *= forceFriction;
  
  
      // -- SPEED LIMITS
      
      // -- ensures left movement does not exceed max speed
      if (speedX > maxSpeed) {
        speedX = maxSpeed;
      }
      // -- ensures right movement does not exceed max speed
      if (speedX < -maxSpeed) {
        speedX = -maxSpeed;
      }
      // -- allows gravity to increase
      if (speedY > 3 * maxSpeed) {
        speedY = 3 * maxSpeed;
      }
      // -- don't need when jumping
      if (speedY < -maxSpeed) {
        //vy = -speedLimit;
      }
  
      // -- makes minimum speed stable (sets to 0)
      if (abs(speedX) < 0.2) {
        speedX = 0;
      }
  
      // -- Changes to player's position
      posX+=speedX;
      posY+=speedY;
      
      // Runs platform class methods
      checkBoundaries();
      checkPlatforms();
    }
  }
  
  // -- WORLD BOUNDARY CHECK METHOD
  void checkBoundaries() {
    
    // -- Checks the left side of the game window
    if (posX - 450 < 0) {  
      // -- applies bounce if on boundary
      border = "left";
      
    }
    
    // -- Checks right side of the game window
    else if ((posX + hitboxWidth + 450) > width) {     
      // -- applies bounce if on boundary
      border = "right";
    }
    else{
      border = "none";
    }
    
    // -- checks top boundary
    if (posY < 0) {     
      // -- applies bounce if on boundary
      speedY *= forceRebound;
      posY = 0;
    }
    
    // -- checks bottom boundary
    if (posY - hitboxHeight > height){
      playerDead = true;
      if (crashSoundPlayed == false){
        crashSound.play();
        crashSoundPlayed = true;
        deaths++;
      }
    }
  }

  
  // -- PLATFORM COLLISIONS CHECK
  void checkPlatforms() {
    
    // -- Checks if there is collision at the bottom
    if (sideOfCollision == "bottom" && speedY >= 0) {
      onPlatform = "bouncing";
      
      // -- Checks if vertical speed is less than one 
      if (speedY < 1) {
        onPlatform = "Yes";
        grounded = true;
        // -- speed set to 0 to prevent bouncing (required to stop bouncing permanently)
        speedY = 0;
      } 
      else {     
        // -- reduced bounce for floor bounce
        speedY *= forceRebound/2.6;
      }      
      // -- Checks for top collision
    } 
    else if (sideOfCollision == "top" && speedY <= 0) {
      speedY = 0;
      // -- Checks for collision on the right
    } 
    else if (sideOfCollision == "right" && speedX >= 0) {
      speedX = 0;
      // -- Checks for collision on the left
    } 
    else if (sideOfCollision == "left" && speedX <= 0) {
      speedX = 0;
    }    
    // -- If there is no collision on the bottom side, set onGround to false
    if (sideOfCollision != "bottom" && speedY > 0) {
      onPlatform = "No";
      grounded = false;
    }
  }
  
  
  // -- HITBOX & PLAYER APPEARANCE
  
  void display() {
    
    // -- APPLIES WORLD SHIFT
    posX -= worldShift;
    worldShift = 0;
    
    // -- Hitbox colour
    fill(playerHitboxColour);
    // -- Hitbox
    rect(posX, posY, hitboxWidth, hitboxHeight);
    
    // -- LEFT MOVEMENT
    
    // -- Checks if player is on the ground and moving right
    if (right == true && left == false && facing == "right" && grounded == true && jump == false){
      if (runSound.isPlaying() == false){
        runSound.play();
      }
      if (frames%framesPerChange == 0){
        // -- scrolls through right sprite animations
        playerImage = playerRunImagesRight[positionNumber];
        positionNumber++;
        // -- ensures there is no pointer error
        if (positionNumber > (playerRunImagesRight.length - 1)){
          positionNumber = 0;
        }
      }
    }
    
    // -- RIGHT MOVEMENT
    
    // -- Checks if player is on the ground and moving left
    if (left == true && right == false && facing == "left" && grounded == true && jump == false){
      if (runSound.isPlaying() == false){
        runSound.play();
      }
      if (frames%framesPerChange == 0){
        // -- scrolls through left sprite animations
        playerImage = playerRunImagesLeft[positionNumber];
        positionNumber++;
        // -- ensures there is no pointer error
        if (positionNumber > (playerRunImagesLeft.length - 1)){
          positionNumber = 0;
        }
      }
    }
    // -- Checks if the sprite is in the air
    if (grounded == false){
      runSound.stop();
      // -- checks mid-air orientation of player
      if (facing == "left"){
        // -- loads left jump image
        playerImage = loadImage("JumpingPosition (Left).png");
      }
      // -- checks mid-air orientation of player
      if (facing == "right"){
        // -- loads right jump image
        playerImage = loadImage("JumpingPosition (Right).png");
      }
    }
    
    // -- Checks if player is still and on the ground
    if (left == false && right == false && grounded == true){
      runSound.stop();
      // -- Checks standing orientation
      if(facing == "left"){
        // -- loads left standing image
        playerImage = loadImage("Standing (Left).png");
        // -- resets position number
        positionNumber = 0;
      }
      // -- checks standing orientation
      else if(facing == "right"){
        // -- loads right standing image
        playerImage = loadImage("Standing (Right).png");
        // -- resets position number
        positionNumber = 0;
      }
    }
    // -- Checks if player is dead 
    if (playerDead == true){
      // -- checks if player was facing right at the time of death
      if (facing == "right"){
        // -- loads player death image
        playerImage = loadImage("Player dead (Right).png");
      }
      // -- checks if player was facing left at the time of death
      if (facing == "left"){
        // -- loads player death image
        playerImage = loadImage("Player dead (Left).png");
      }
    }
    if (playerDead == true){
      image(playerImage,posX,posY+1);
    }
    else{
      // -- generates player image
      image(playerImage,posX,posY-10);
    }
  }
}
