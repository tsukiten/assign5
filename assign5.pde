PImage start1, start2, bg1,bg2,end1, end2;
PImage treasure,fighter, enemy,bullet;
int q;//bg
PImage hp;
PFont score;
int scoreNum = 0;


final int GAME_START = 0;
final int GAME_RUN = 1;
final int GAME_OVER = 2;
int gameState;

final int C = 0;
final int B = 1;
final int A = 2;
int enemyState;

int hpX;

//enemy
PImage [] enemyPic = new PImage [5];
float enemyC [][] = new float [5][2];       
float enemyB [][] = new float [5][2];
float enemyA [][] = new float [8][2];  
float spacingX;
float spacingY;

//flame
int timer;
int curFlame;
PImage [] flame = new PImage [5];
float flameP [][] = new float [5][2]; //flamePositon

float treasureX;
float treasureY;
float fighterX;
float fighterY;
float enemyY;
float [] bulletX = new float [5];
float [] bulletY = new float [5];

float fighterSpeed;
float enemySpeed;
int bulletSpeed;

boolean upPressed = false;
boolean downPressed = false;
boolean leftPressed = false;
boolean rightPressed = false;

//bullet number
int bulletNum = 0;
boolean [] bulletLimit = new boolean[5];

void setup () {    
  size (640,480) ;
  frameRate(60);
    
  for ( int i = 0; i < 5; i++ ){
    flame[i] = loadImage ("img/flame" + (i+1) + ".png" );
  }
  
  start2 = loadImage ("img/start2.png");
  start1 = loadImage ("img/start1.png");  
  bg1 = loadImage ("img/bg1.png");
  bg2 = loadImage ("img/bg2.png");
  hp = loadImage ("img/hp.png");
  treasure = loadImage ("img/treasure.png");
  fighter = loadImage ("img/fighter.png");
  enemy = loadImage ("img/enemy.png");  
  end2 = loadImage ("img/end2.png");
  end1 = loadImage ("img/end1.png");
  bullet = loadImage ("img/shoot.png");
  
  gameState = GAME_START;
  enemyState = C;
  hpX = 40; 
  treasureX = floor( random(50, width - 40) );
  treasureY = floor( random(50, height - 60) );
  fighterX = width - 65 ;
  fighterY = height / 2 ; 

  //speed
  fighterSpeed = 5;
  enemySpeed = 4;
  bulletSpeed = 4;
  
  //flame
  timer = 0;
  curFlame = 0;
  for ( int i = 0; i < flameP.length; i ++){
    flameP[i][0] = 1000;
    flameP[i][1] = 1000;
  }

  //no bullet
  for (int i =0; i < bulletLimit.length ; i ++){
    bulletLimit[i] = false;
  }

  //enemy line
  spacingX = 0;  
  spacingY = -60; 
  enemyY = floor(random(80, 400));    
  for (int i = 0; i < 5; i++){
   enemy = loadImage ("img/enemy.png");  
   enemyC [i][0] = spacingX;
   enemyC [i][1] = enemyY; 
   spacingX -= 75;
  }
  
  score = createFont("Cambria", 24);
  textFont(score, 24);
  textAlign(LEFT);
}


void draw() {  
  switch (gameState) {
    case GAME_START:
      image (start2, 0, 0);     
      if ( mouseX > 200 && mouseX < 460 
        && mouseY > 370 && mouseY < 420){
            image(start1, 0, 0);
            if(mousePressed){
              gameState = GAME_RUN;
            }
      }
    break;  
    
    
    case GAME_RUN:
      //bg
      image(bg1,q%1280-640,0); 
      image(bg2,(q+640)%1280-640,0);
      q++;
      
      //treasure
      image (treasure, treasureX, treasureY);    
      
      //fighter
      image(fighter, fighterX, fighterY);
      
      if (upPressed && fighterY > 0) {
        fighterY -= fighterSpeed ;
      }
      if (downPressed && fighterY < height - fighter.height) {
        fighterY += fighterSpeed ;
      }
      if (leftPressed && fighterX > 0) {
        fighterX -= fighterSpeed ;
      }
      if (rightPressed && fighterX < width - fighter.width) {
        fighterX += fighterSpeed ;
      }  
        
      //flame
      image(flame[curFlame], flameP[curFlame][0], flameP[curFlame][1]);      
      timer ++;
      if ( timer % 6 == 0){
        curFlame ++;
      } 
      if ( curFlame > 4){
        curFlame = 0;
      }
      //flame buring
      if(timer > 31){
        for (int i = 0; i < 5; i ++){
          flameP[i][0] = 1000;
          flameP[i][1] = 1000;
        }
      }   
      
     //bullet
      for (int i = 0; i < 5; i ++){
        if (bulletLimit[i] == true){
          image (bullet, bulletX[i], bulletY[i]);
          bulletX[i] -= bulletSpeed;
        }
        if (bulletX[i] < - bullet.width){
          bulletLimit[i] = false;
        }
      }
    
      //enemy
      switch (enemyState) { 
        case C :               
          for ( int i = 0; i < 5; i++ ){
            image(enemy, enemyC [i][0], enemyC [i][1]);
            //bullet flame
            for (int j = 0; j < 5; j++ ){
              if(getHit(bulletX[j], bulletY[j], bullet.width, bullet.height, enemyC[i][0], enemyC[i][1], enemy.width, enemy.height) == true && bulletLimit[j] == true){
                for (int k = 0;  k < 5; k++ ){
                  flameP [k][0] = enemyC [i][0];
                  flameP [k][1] = enemyC [i][1];
                }    
                enemyC [i][1] = -1000;
                bulletLimit[j] = false;
                timer = 0; 
                scoreChange(20);
              }
            }  
            //fighter get flame
            if(getHit(fighterX, fighterY ,fighter.width, fighter.height,  enemyC[i][0], enemyC[i][1], enemy.width, enemy.height) == true){
              for (int j = 0;  j < 5; j++){
                flameP [j][0] = enemyC [i][0];
                flameP [j][1] = enemyC [i][1];
              }
              hpX -= 40;          
              enemyC [i][1] = -1000;
              timer = 0; 
            }else if(hpX <= 0){
              gameState = GAME_OVER;
              hpX = 40;
              fighterX = 550;
              fighterY = width / 2 ;
            } else {
              enemyC [i][0] += enemySpeed;
              enemyC [i][0] %= 1280;
            }      
          }
          //go to B
          if (enemyC [enemyC.length-1][0] > 640+100 ) {        
            enemyY = floor(random(30,240));            
            spacingX = 0;  
            for (int i = 0; i < 5; i++){
              enemyB [i][0] = spacingX;
              enemyB[i][1] = enemyY - spacingX / 2;
              spacingX -= 80;                 
            }
            enemyState = B;
          }
        break ; 
        
        case B :
          for (int i = 0; i < 5; i++ ){
            image(enemy, enemyB [i][0] , enemyB [i][1]);
            //bullet flame
            for(int j = 0; j < 5; j++){
              if (getHit(bulletX[j], bulletY[j], bullet.width, bullet.height, enemyB [i][0], enemyB [i][1], enemy.width, enemy.height) == true && bulletLimit[j] == true){
                for(int k = 0;  k < 5; k++ ){
                  flameP [k][0] = enemyB [i][0];
                  flameP [k][1] = enemyB [i][1];
                }     
                enemyB [i][1] = -1000;
                bulletLimit[j] = false;
                timer = 0;
                scoreChange(20);
              }
            }   
            //fighter get flame
            if ( getHit(fighterX, fighterY ,fighter.width, fighter.height,  enemyB[i][0], enemyB[i][1], enemy.width, enemy.height) == true){
              for (int j = 0;  j < 5; j++ ){
                 flameP [j][0] = enemyB [i][0];
                 flameP [j][1] = enemyB [i][1];
               }
              enemyB [i][1] = -1000;
              timer = 0; 
              hpX -= 40;
            }else if(hpX<= 0){
              gameState = GAME_OVER;
              hpX = 40;
              fighterX = 550;
              fighterY = width / 2 ;
            } else {
              enemyB [i][0] += enemySpeed;
              enemyB [i][0] %= 1280;
            }         
          }
          
          //go to A
          if (enemyB [4][0] > 640 + 100){
            enemyY = floor( random(200,280) );
            enemyState = A;            
            spacingX = 0;  
            spacingY = -60; 
            for ( int i = 0; i < 8; i ++ ) {
              if ( i < 3 ) {
                enemyA [i][0] = spacingX;
                enemyA [i][1] = enemyY - spacingX;
                spacingX -= 60;
              } else if ( i == 3 ){
                enemyA [i][0] = spacingX;
                enemyA [i][1] = enemyY - spacingY;
                spacingX -= 60;
                spacingY += 60;
              } else if ( i > 3 && i <= 5 ){
                  enemyA [i][0] = spacingX;
                  enemyA [i][1] = enemyY + spacingY;
                  spacingX += 60;
                  spacingY -= 60;
              } else {
                  enemyA [i][0] = spacingX;
                  enemyA [i][1] = enemyY + spacingY;
                  spacingX += 60;
                  spacingY += 60;
              }            
            }     
          }
        break ;        
        
        case A :  
          for( int i = 0; i < 8; i++ ){
            image(enemy, enemyA [i][0], enemyA [i][1]);     
            //bullet flame     
            for( int j = 0; j < 5; j++ ){
              if ( getHit(bulletX[j], bulletY[j], bullet.width, bullet.height, enemyA[i][0], enemyA[i][1], enemy.width, enemy.height) == true && bulletLimit[j] == true){
                for (int s = 0;  s < 5; s++){
                  flameP [s][0] = enemyA [i][0];
                  flameP [s][1] = enemyA [i][1];
                }
                enemyA [i][1] = -1000;
                bulletLimit[j] = false;
                timer = 0; 
                scoreChange(20);
              }
            }       
            //fighter get flame
            if ( getHit(fighterX, fighterY ,fighter.width, fighter.height,  enemyA[i][0], enemyA[i][1], enemy.width, enemy.height) == true){ 
              for ( int j = 0;  j < 5; j++ ){
                flameP [j][0] = enemyA [i][0];
                flameP [j][1] = enemyA [i][1];
              }
              hpX -= 40;
              enemyA [i][1] = -1000;
              timer = 0; 
            } else if ( hpX <= 0 ) {
              gameState = GAME_OVER;
              hpX = 40;
              fighterX = 550 ;
              fighterY = width/2 ;
            } else {
              enemyA [i][0] += enemySpeed;
              enemyA [i][0] %= 1920;
            }     
          }
          
          //go to C
          if(enemyA [4][0] > 640 + 300 ){
            enemyY = floor(random(80,400));
            spacingX = 0;       
            for (int i = 0; i < 5; i++ ){
              enemyC [i][1] = enemyY; 
              enemyC [i][0] = spacingX;
              spacingX -= 80;
            } 
            enemyState = C;            
          }  
        break ;
      }

     //hp
      fill (255,0,0);
      rect (35, 15, hpX, 30);
      image(hp, 28, 15);   
      //get treasure
      if(getHit(treasureX, treasureY, treasure.width, treasure.height, fighterX, fighterY, fighter.width, fighter.height) == true){    
              hpX += 20;
              treasureX = floor(random(50,600));         
              treasureY = floor(random(50,420));
      }
      if(hpX >= 200){
        hpX = 200;
      }
      
      fill(255);
      text("Score:" + scoreNum, 10, 470);
    break ;  
    
    
    case GAME_OVER :
      image(end2, 0, 0);     
      if ( mouseX > 200 && mouseX < 470 
        && mouseY > 300 && mouseY < 350){
            image(end1, 0, 0);
            if(mousePressed){
              treasureX = floor( random(50,600) );
              treasureY = floor( random(50,420) );      
              enemyState = 0;      
              spacingX = 0;       
              for (int i = 0; i < 5; i++ ){
                flameP [i][0] = 1000;
                flameP [i][1] = 1000;
                bulletLimit[i] = false;
                enemyC [i][0] = spacingX;
                enemyC [i][1] = enemyY; 
                spacingX -= 80;
                scoreNum = 0;
              }
              gameState = GAME_RUN;
            }
      }
    break ;
  }  
}


void keyPressed (){
  if (key == CODED) {
    switch ( keyCode ) {
      case UP :
        upPressed = true ;
        break ;
      case DOWN :
        downPressed = true ;
        break ;
      case LEFT :
        leftPressed = true ;
        break ;
      case RIGHT :
        rightPressed = true ;
        break ;
    }
  }
}
  
  
void keyReleased () {
  if (key == CODED) {
    switch ( keyCode ) {
      case UP : 
        upPressed = false ;
        break ;
      case DOWN :
        downPressed = false ;
        break ;
      case LEFT :
        leftPressed = false ;
        break ;
      case RIGHT :
        rightPressed = false ;
        break ;
    }  
  }  
  //shoot bullet
  if ( keyCode == ' '){
    if (gameState == GAME_RUN){
      if (bulletLimit[bulletNum] == false){
        bulletLimit[bulletNum] = true;
        bulletX[bulletNum] = fighterX -15 ;
        bulletY[bulletNum] = fighterY + fighter.height/2;
        bulletNum ++;
      }   
      if ( bulletNum > 4 ) {
        bulletNum = 0;
      }
    }
  }
}
void scoreChange(int value){
  scoreNum += value;
}

boolean getHit(float ax, float ay, float aw, float ah, float bx, float by, float bw, float bh){
  if (ax >= bx - aw && ax <= bx + bw && ay >= by - ah && ay <= by + bh){
  return true;
  }
  return false;
}
