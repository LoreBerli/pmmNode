public class Node{
  /* TODO: aggiungere supporto per diversi tipi di Nodo sensore   */
  protected int id;
  protected ArrayList<Node> fathers;
  protected ArrayList<Node> sons;
  protected int posX;
  protected int posY;
  protected int[] colore;//Eliminabile(?)
  protected String state;//Eliminabile(?)
  protected String name;
  protected String functionDescription;
  protected boolean selected;
  protected boolean rSelected;//Eliminabile(?)
  protected boolean overed;
  protected String COM;
  
  public Node(int id,int posX,int posY,String name){
    fathers = new ArrayList<Node>(0);
    sons=new ArrayList<Node>(0);
    this.id=id;
    this.posX = posX;
    this.posY = posY;
    this.name = name;
    this.COM = "COM3";
    state = "IDLE";
    this.functionDescription = "none";
    this.colore = stateColor();
    selected=rSelected=overed=false;
    
  }
  public String getType(){return "node";}
  public String getDescr(){return functionDescription;}
  public void setDescr(String s){functionDescription = s;}
  public String getCOM(){return COM;}
  public void setCom(String s){COM = s;}
  public void setName(String name){
    this.name = name;}
  /*---------------------------------------------*/
  public Node getFather(int i){return fathers.get(i);}
  public Node getSon(int i){return sons.get(i);}
  public ArrayList<Node> getSons(){return sons;}
  public ArrayList<Node> getFathers(){return fathers;}
  
  public boolean isSon(Node n){  
    for(int i=0;i<sons.size();i++){
      if(sons.get(i)==n){return true;}
    }
    return false;
  }
    public void deleteSon(Node s){
    if(isSon(s)){
      sons.remove(s);
    }
  }
  
  public boolean isFather(Node f){
    for(int i=0;i<fathers.size();i++){
      if(fathers.get(i)==f){return true;}
    }
    return false;
  }
  
  public void deleteFather(Node f){
      if(isFather(f)){
       fathers.remove(f);
    }
  }
  
    
  public void addSon(Node n){sons.add(n);}
  public void addFather(Node n){fathers.add(n);}
 
/*----------------------------------------*/
  public String getSonsInfo(){
    String s;
    s="Children:";
    for(int i=0;i<sons.size();i++){
      s = s+"\n"+" "+sons.get(i).name+" ID:"+sons.get(i).getId();
    }
    return s;
  }
 
  public String getFathersInfo(){
    String s;
    s="Parents:";
    for(int i=0;i<fathers.size();i++){
      s = s+"\n"+" "+fathers.get(i).name+" ID:"+fathers.get(i).getId();
    }
    return s; 
}
/*----------------------------------------*/
  
 
  public int getX(){return posX;}
  public int getY(){return posY;}  
  public int getId(){
  return id;
  }
  
  public String getName(){return name;}
  
  public int[] stateColor(){
    
    if(selected && overed){return new int[]{0,255,0};}
    if(selected){return new int[]{0,225,0};}
    if(overed){return new int[]{0,0,255};}
    if(rSelected){return new int[]{128,0,128};}
    else {
      
    return new int[]{128,128,128};    }
  }
  
  public int[] getCoord(){
    int[] arr = {posX,posY};
    return arr;
  }
  
  public void setState(String s){
    this.state=s;
    }
    
  @Override
  public boolean equals(Object obj){
    
    if (!(obj instanceof Node))
            return false;
        if (obj == this){
            //println("coggiuda");
            return true;}
        else return false;
     
  }

  
  public void rClicked(){rSelected=!rSelected;}
  public void clicked(){selected = !selected;}
  public void over(boolean state){overed=state;}
  
  public String getState(){
  return state;}
  
  public void relocate(int x, int y){
    this.posX = x;
    this.posY = y;
    
  }
  public void setFunctionDesc(String s){functionDescription = s;}
  
  public void drawNode(int k){
    int thk=1;
    if(overed){thk=4;}
    strokeWeight(thk);
    fill(stateColor()[0],stateColor()[1],stateColor()[2]);
    stroke(stateColor()[0],stateColor()[1],stateColor()[2]);
    //if(overed){k=4;}
    rect(posX,posY,k+SIZE*2,SIZE+k);
    fill(stateColor()[0]-20,stateColor()[1]-20,stateColor()[2]-20);
    rect(posX+10,posY+10,k+SIZE*2,SIZE+k);
    
//    if(selected){
//    Node s;
//    if (sons.size() > 0){
//      if(selected){strokeWeight(3);}
//    for(int j=0;j<sons.size();j++){
//      s=sons.get(j);
//      
//      line(this.posX+SIZE,this.posY+SIZE/2,s.getX(),s.getY()+SIZE/2);
//      
//    }
//    }
//    }else
    {
    /*Connections draw.. con logica padri*/
    Node f;
    if (fathers.size() > 0){
      int div = fathers.size()*2;
      //println(div," ",(SIZE/div));
      int m;
      if(selected){strokeWeight(3);}
        for(int j=0;j<fathers.size();j++){
          f=fathers.get(j);
          
          if(j==0){m=1;}else{m=1+2*j;}
          line(this.posX,this.posY+(m)*(SIZE/div),f.getX()+SIZE*2,f.getY()+SIZE/2);
          //curve(this.posX,this.posY+(m)*(SIZE/div),this.posX-10,this.posY+(m)*(SIZE/div)-10,f.getX()+10+SIZE*2,f.getY()+10+SIZE/2,f.getX()+SIZE*2,f.getY()+SIZE/2);
          ellipse(this.posX,this.posY+(m)*(SIZE/div),4,4);
        }
      }
    }
    strokeWeight(2);
    
    /*debug draw*/
    fill(255,255,255);
 
    
    text("ID:"+Integer.toString(id),posX+5,posY+10);
    if(SIZE>31){
      text(name,posX+5,posY+20);
    if(SIZE>41){
      text(functionDescription,posX+5,posY+30);
    }
    }
    /*-----*/
  }
  
  
}
