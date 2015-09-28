public class Connection{ 
  /*---------------probabilmente tutto questo modulo è obsoleto--------------------- */
  Node father;
  Node son;
  int weigth;
  color c;
  
  public Connection(Node f,Node s){
    father=f;
    son=s;
    weigth=1;
    c=color(100);
    f.addSon(s);
    s.addFather(f);
  }
  
//  public deleteConnection(Node f,Node s){
//    
// }
  
  
  public String getString(){String s = father.name+" "+son.name;
  return s;}
  
  public void draw(){
    stroke(c);
    //line(father.getX()+SIZE*2,father.getY()+SIZE/2,son.getX(),son.getY()+SIZE/2);
    stroke(0,0,0);
  }
  
}
