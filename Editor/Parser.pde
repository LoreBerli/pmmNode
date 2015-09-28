public class Parser{
  
  //in barba al SingleResponsibilityPrinciple, Parser parsa il JSON,crea i bottoni relativi alle funzioni
  //trovate nel JSON e ne istanzia le callback
   
   JSONArray funcs;   
   Manager boss;
   ControlP5 controller;
   Button[] btns;
   
   
   public Parser(Manager boss,ControlP5 controller,Button[] btns){
     funcs= loadJSONArray("function.json");
     this.boss = boss;
     this.controller = controller;
     this.btns = btns;
   }
   
   public void getFunctions(){
     JSONObject tmp;
     
     Button btn;
     
//     for(int i=0;i<funcs.size();i++){
//       tmp = funcs.getJSONObject(i);
//       tmpNode =(Block)boss.addNode("BLOC",tmp.getString("name"));
//       tmpNode.setParams(tmp.getInt("param"));
//       tmpNode.setFunctionDesc(tmp.getString("descr"));
//       tmpNode.setFunctionName(tmp.getString("name"));
//       
//       
//     }
       btns = new Button[funcs.size()];
       
       for(int i=0;i<funcs.size();i++){
       tmp = funcs.getJSONObject(i);
       btn = controller.addButton(tmp.getString("name"),1.0,452+42*(i%8),2+32*(i/8),40,30);//non ti curar di noi.Girone dei MAGIC NUMBERS
       btns[i] = btn;
       btn.setValue(i);
       btn.addCallback(new CoolButton(tmp));
     }
   }
   
   
}
