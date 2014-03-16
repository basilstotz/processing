class body{

  boolean fixed;
  
  float radius;
  
  float px,py;
  float vx,vy;
  float ax,ay;
  
  Body(float x,float y,float r){
    px=x;
    py=y;
    
    radius=r;
    
    vx=0.0;
    vy=0.0;
    ax=0.0;
    ay=0.0; 
  }
  
  void display(){
    fill(128);
    noStroke();
    ellipse(px,py,radius,radius);
  }
  
  void setAcc(PVector a){
    ax=a.x;
    ay=a.y;
  }
  
  void resetAcc(){
    ax=0.0;
    ay=0.0;
  }
  
  void addAcc(PVector a){
    ax+=a.x;
    ay+=a.y;
  }
  
  void setVel(PVector v){
    vx=v.x;
    vy=v.y;
  }
  
  void update(){
    vx+=ax;
    vy+=ay;
    px+=vx;
    py+=vy;
  }
  
  PVector surface(float phi){
    
  
}
