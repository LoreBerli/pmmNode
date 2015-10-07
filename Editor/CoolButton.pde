public class CoolButton implements CallbackListener{
   /* Aldilà del nome, CoolButton implementa l'interfaccia CallBackLIstener a cui aggiunge
   /* un riferimento ad un JSONObject necessario affinchè, quando il bottone chiami la callback
   /* sia possibile creare un blocco-funzione letto dal JSON
   */
   
   private JSONObject tmp;
   public CoolButton(JSONObject obj){
     super();
     tmp = obj;     
   } 
   
   public void controlEvent(CallbackEvent event){
     if (event.getAction() == ControlP5.ACTION_RELEASED) {
            Block tmpNode;
            tmpNode =(Block)boss.addNode("BLOC",tmp.getString("name"));
            tmpNode.setParams(tmp.getInt("param"));
            println("blocco:"+tmp.getString("name")+"param:"+tmp.getInt("param"));
            tmpNode.setFunctionDesc(tmp.getString("descr"));
            tmpNode.setFunctionName(tmp.getString("name"));
            boss.relocation(tmpNode);
              }
   }
}
