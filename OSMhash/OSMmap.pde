class Map {

  HashMap<Long, Integer> nIndex;
  HashMap<Long, Integer> wIndex;

  ArrayList<Node> nodes;
  ArrayList<Way> ways;
  ArrayList<Relation> relations;
  ArrayList<Tag> tags;


  Map() {

    nIndex = new HashMap<Long, Integer>();
    wIndex = new HashMap<Long, Integer>();

    nodes = new ArrayList<Node>();
    ways = new ArrayList<Way>();
    relations = new ArrayList<Relation>();
    tags= new ArrayList<Tag>();
  }

  Relation addRelation(Relation R) {
    relations.add(R);
    return R;
  }

  Way addWay(Way W) {
    ways.add(W);
    wIndex.put(W.id, ways.size());
    return W;
  }



  Node addNode(Node N) {
    nodes.add(N);
    nIndex.put(N.id, nodes.size());
    return N;
  }

  ///////////////////////////////////////////////////////////777

  Way getWayByID( long id) {
    return ways.get(wIndex.get(id));
  }


  Node getNodeByID( long id) {
    return nodes.get(nIndex.get(id));
  }



  ////////////////////////////////////////7

  void render() {

    //relation
    for (int=0;i<relations.size();i++) {
      Relation R=<Relation>relations.get(i);
      for (int j=0;j<R.members.size();j++) {
        Member M=<Member>R.members.get(j);
        switch(M.type) {
        case 0: //Node
          Node N=nodes.get(nIndex(R.ref);
          drawNode(N);
          break;
        case 1: //Way
          Way W=ways.get(wIndex(R.ref);
          drawWay(W);
          break;
        default: 
          break;
        }
      }
    }//end relation

    //way
    for (int i=0;i<ways.size();i++) {
      Way W=<Way>ways.get(i);
      drawWay(W);
    }

    //node
    for (int i=0;i<nodes.size();i++) {
      Node N=<Node>nodes.get(i);
      drawNode(N);
    }
    
  }//render


  void drawNode(Node N) {
  }


  void drawWay(Way W) {
  }
}

