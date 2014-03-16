body[] bodies;
PVector pos;

int num;
float max_x;
float max_y;
float radius;

void setup(){
 size(400,400);
 num=2;
 max_x=400.0;
 max_y=400.0;
radius=50;

 
 bodies = new body[num];
 for(int i=0;i<num;i++){
   bodies[i]= new Body(random(max_x-200)+100,random(max_y-200)+100,50);
 }
}

void draw(){
  background(0);
  fill(128);
  for(int i=0;i<num;i++){
    
  }
  
  pos=rand_start(bodies[0]);  
  while(abstand(pos,bodies[1])>radius){
    PVector f1=force(bodies[0],pos);
    PVector f2=force(bodies[1],pos); 
    
    float xx=pos.x+(f1.x+
    
  
  
}

PVector rand_start(PVector body){
  
  PVector res= new PVector();
  float phi=2*PI*random(1000)/1000.0;
  res.x=body.x+cos(phi)*radius;
  res.y=body.y+sin(phi)*radius;
  return(res);
}

PVector force(PVector body, PVector sample){
  
  PVector res= new PVector();
  float dx,dy;
  float f=1.0;
  float phi=0.0;
  
  dx=body.x-sample.x;
  dy=body.y-sample.y;
  
  f=1.0/(dx*dx+dy*dy);
  phi=atan2(dx,dy);
  
  res.x=f*cos(phi);
  res.y=f*sin(phi);
  
  return res;
}

float abstand(PVector a, PVector b){
  return dist(a.x,a.y,b.x,b.y);
}
