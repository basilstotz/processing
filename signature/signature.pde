


void setup() {
  
  float max;
  
  print("\t");
  for (int j=4;j<=32;j+=4) {
    print(j+"\t");
  }
  println("max\n");

  for (int i=140;i<180;i++) {
    print(i+"\t");
    
    max=0.0;
    for (int j=4;j<=32;j+=4) {
      //print(i/j+"-"+i%j+"\t");
        float f=float(i%j)/float(j);
        int p=ceil(f*j);
        if(f==0.0)f=1.0;
        if(f>max)max=f;
        print(nf(p,1,2)+"\t");
    }
    println(nf(max,1,2));
    max=0.0;
  } 


  noLoop();
}


void draw() {
}

