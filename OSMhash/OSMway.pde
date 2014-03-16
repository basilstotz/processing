class Way {

  
  long id;

  ArrayList<Nd> nds;

  String name;
  int group;
  int type;

  Way(long id_,String name_, int group_, int type_) {
    
    id=id_;
    name=name_;
    group=group_;
    type=type_;
    nds = new ArrayList<Nd>();
    
  }

  void addNd(long ref) {
    nds.add( new Nd(ref) );
  }
}


class Nd{
 
 long ref; 
  
 Nd(long ref_){
  ref=ref_;
 } 
  
  
}
