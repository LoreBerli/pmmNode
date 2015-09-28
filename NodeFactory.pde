public class NodeFactory{

  
  public Node getNode(String tipoNodo,String name,int id,int x,int y){
      if(tipoNodo == null){
         return null;
      }    
      if(tipoNodo.equalsIgnoreCase("SENS")){
         return new Sensor(id,x,y,name);
         
      } else if(tipoNodo.equalsIgnoreCase("ACTU")){
         return new Actuator(id,x,y,name);
         
      } else if(tipoNodo.equalsIgnoreCase("BLOC")){
         return new Block(id,x,y,name);
      }
      
      return null;
   }
}
