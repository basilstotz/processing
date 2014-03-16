class Relation {

  ArrayList<Member> members;
  
  long id;

  String name;
  
  int group;
  int type;

  Relation(long id_) {
    id=id_;
    members = new ArrayList<Member>();
  }

  void addMember( long ref_, int type_, int role_ ) {
  }
  
  
    
    
 
  
  
  
}

class Member{
 
  long ref;  
  int type;
  int role;
  
  Member(){
    
    
  }
  
}
