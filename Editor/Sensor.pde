public class Sensor extends Node{
  
  public Sensor(int id,int pin,int posX,int posY,String name,String COM){
    super(id,pin,posX,posY,name,COM);
    
  }
  public String getType(){return "SENS";}
  public int[] stateColor(){
    
    if(selected && overed){return new int[]{0,255,0};}
    if(selected){return new int[]{0,225,0};}
    if(overed){return new int[]{0,100,0};}
    if(rSelected){return new int[]{128,0,128};}
    else {
      
    return new int[]{64,128,64};    }
  }
  
  public void drawNode(int k){
    int thk=1;
    if(overed){thk=4;}
    strokeWeight(thk);
    fill(stateColor()[0],stateColor()[1],stateColor()[2]);
    stroke(stateColor()[0],stateColor()[1],stateColor()[2]);
    //if(overed){k=4;}
    rect(posX,posY,k+SIZE*2,SIZE+k);
    ellipse(this.posX+SIZE*2,this.posY+SIZE/2,4,4);
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
          line(this.posX,this.posY+(m)*(SIZE/div),this.posX-10,this.posY+(m)*(SIZE/div)-10);
          line(this.posX-10,this.posY+(m)*(SIZE/div)-10,f.getX()+10+SIZE*2,f.getY()+10+SIZE/2);
          line(f.getX()+10+SIZE*2,f.getY()+10+SIZE/2,f.getX()+SIZE*2,f.getY()+SIZE/2);
          //line(this.posX,this.posY+(m)*(SIZE/div),f.getX()+SIZE*2,f.getY()+SIZE/2);
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
