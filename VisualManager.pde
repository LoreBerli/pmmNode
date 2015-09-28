public class VisualManager{
  
  //-------------------
  //A CAUSA DELLA GUI(libreria ControlP5)probabilmente gran parte di questo modulo è inutile
  //-------------------
  
  private ArrayList<Node> nodes;
  private ArrayList<Connection> cons;
  private ArrayList<Node> vidBuff;
  private Node movingNode;
  
  public VisualManager(ArrayList<Node> nodes,ArrayList<Connection> cons){
    this.nodes=nodes;
    this.cons=cons;
    vidBuff = new ArrayList<Node>(0);
    majorDraw();
  }
  
  public void addToBuff(Node n)
   /*aggiunge il nodo al buffer video. Chi deve controllare i doppioni?????*/
  {
    
    if(!vidBuff.contains(n) ){
      
    vidBuff.add(n);}
    
  }
  public int getBuffSize() {

    return vidBuff.size();
    
  }
  
  public void setMovingNode(Node n){
    
    if(n==movingNode){movingNode=null;}
    else{
     movingNode = n;}
  }
  public Node checkColl() {
    Node tmp;
    for (int i=0; i<nodes.size(); i++) {
      if ((mouseX>nodes.get(i).getX()-2)&& mouseX<nodes.get(i).getX()+SIZE*2+2 && mouseY>nodes.get(i).getY()-2 && mouseY<nodes.get(i).getY()+SIZE+2 ) {
        tmp =nodes.get(i);
       
        addToBuff(tmp);
        return tmp;
      }
    }
    tmp = null;
    return tmp;
  }
  
  public void drawNodes() {
    if(movingNode!=null){
      movingNode.relocate(mouseX-SIZE,mouseY-SIZE/2);
      majorDraw();
    }
     else{
    for (int i = 0; i < vidBuff.size (); i++) {
      vidBuff.get(i).drawNode(0);
      vidBuff.remove(i);
    }
     }
  }
  public void majorDraw(){
    stroke(0,0,100);
    background(15);
    fill(0,0,50);
    rect(0,0,1024,100);
    
    strokeWeight(4);
    line(0,100,1024,100);
    Node tmp;
    for (int i=0; i<nodes.size(); i++) {
       nodes.get(i).drawNode(0);
    }    
  }
  
  public void drawCon() {
    for (int i = 0; i < cons.size (); i++) {
      cons.get(i).draw();
    }
  }
  
  
}
