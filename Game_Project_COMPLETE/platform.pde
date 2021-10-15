// -- Establishes Platform class
class Platform{
  
  // -- Platform variables
  float platWidth,platHeight,x,y;
  float horizontalSide, verticalSide;
  color platColour;
  String platType;
  float platSpeed, displacement, maxDisplacement;
  PImage platformImage;
  Boolean fakePlatform;
  
  
  // -- INITIALISE METHOD
  Platform(float posX, float posY, float platformWidth, float platformHeight, String platformType, Boolean fake){
    
     // -- Platform position
    x = posX;
    y = posY;
    
    // -- Check if platform is fake
    fakePlatform = fake;
    
    // -- Platform hitbox
    platWidth = platformWidth;
    platHeight = platformHeight;
    
    // -- Platform type
    platType = platformType;
    
    
    // -- PLATFORM COLOURS
    
    // -- checks if platform is solid
    if (platType == "solid"){
      platColour = #0CEA0D;
    }    
    // -- checks if platform is semi-permeable
    else if (platType == "semi-permeable"){
      platColour = #40CAEA;
    }    
    // -- checks if platform is a moving one
    else if (platType == "moving-vertical" || platType == "moving-horizontal"){
      platColour = #FFAA0A;
    }
    // -- checks if platform is a spike trap
    else if (platType == "smallSpikeTrap" || platType == "largeSpikeTrap"){
      platColour = #150A0A;
    }
    // -- checks if the platform is fake
    if (fakePlatform == true){
      platColour = #C80ECB;
    }
    
    // -- Collision variables
    horizontalSide = platWidth/2;
    verticalSide = platHeight/2;
    
    // -- Moving platform variables
    platSpeed = 4;
    displacement = 0;
    maxDisplacement = 200;
    
    // -- Platform appearance
    platformImage = loadImage("platform image.png");
  }
  
  
  // -- PLATFORM DISPLAY METHOD
  void display(){
    
    // -- Checks if platform is moving
      if (platType == "moving-horizontal"){
        // -- applies speed to platform
        x += platSpeed;
        
        // -- stops platform from moving to much
        displacement += platSpeed;
        if (displacement <= -maxDisplacement || displacement >= maxDisplacement){
          // -- reverses platform direction
          platSpeed *= -1;
        }
      }
      
      if (platType == "moving-vertical"){
        // -- applies speed to platform
        y += platSpeed;
        
        // -- stops platform from moving to much
        displacement += platSpeed;
        if (displacement <= -maxDisplacement || displacement >= maxDisplacement){
          // -- reverses platform direction
          platSpeed *= -1;
        }
      }
      
      // -- Checks if the platform is within range
      if ((x+platWidth) > 0 && x < width){
        // -- PLATFORM IMAGE
        if (platWidth != 40){
          image(platformImage,x,y);
        }
        else{
          image(loadImage("small platform image.png"),x-10,y);
        }
        
        if (platType == "goal"){
          image(loadImage("shrine.png"),x,y-135);
        }
        // --hitbox
        //fill(platColour);
        // -- Platform dimensions
        //rect(x,y,platWidth,platHeight);            
      }
    }
}
