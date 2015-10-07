public class NodeFactory{
  //chi mantiene gli ID????????
  
  public Node getNode(String tipoNodo,String name,int pin,int id,int x,int y,String COM){
      if(tipoNodo == null){
         return null;
      }    
      if(tipoNodo.equalsIgnoreCase("SENS")){
         return new Sensor(id,pin,x,y,name,COM);
         
      } else if(tipoNodo.equalsIgnoreCase("ACTU")){
         return new Actuator(id,pin,x,y,name,COM);
         
      } else if(tipoNodo.equalsIgnoreCase("BLOC")){
         return new Block(id,pin,x,y,name);
      }
      
      return null;
   }
}
