public class Loader{
  /*serve a caricare e salvare i file creati con l'editor in formato JSON*/
  
  String path;
  Manager boss;
  JSONArray config;
  
  public Loader(Manager boss){
    this.boss=boss;
    path="none";
    
  }
  
  public void load(String lPath){
    boss.deleteEverything();
    config = loadJSONArray(lPath);
    frame.setTitle("EDITOR Noduino - "+lPath);
    build();
  }
  
  public void build(){ /*costruisce il grafo leggendolo dal JSON*/
    JSONObject tmp;
    Node tmpNode;
    int maxId =0;
    for(int i=0;i<config.size();i++){
      tmp = config.getJSONObject(i);
      tmpNode = boss.addNode(tmp.getInt("id"),tmp.getInt("pin"),tmp.getString("type"),tmp.getString("name"),tmp.getInt("posX"),tmp.getInt("posY"),tmp.getString("COM"));
      tmpNode.setDescr(tmp.getString("desc"));
    }
    Node n;
    Node son;
    for(int i=0;i<config.size();i++){
        
      tmp = config.getJSONObject(i);    
      int id=tmp.getInt("id");
      n = boss.getNodeById(id);
      if(tmp.getInt("id")>maxId){maxId=tmp.getInt("id");}
      JSONArray sons =tmp.getJSONArray("sons");
      int[] figli = sons.getIntArray();
      for(int s=0;s<sons.size();s++){    
        boss.setSourceNode(n);
        son = boss.getNodeById(figli[s]);
        boss.setNode(son);        
      }
      boss.flushSel();
      boss.setID(maxId+1);
      
    }


  }
  
  public void save(String sPath){
    /*{"id":1,"name":"block1","type":"BLOC","posX":300,"posY":200,"sons":[2,3],"fathers":[0]},*/
    JSONObject ogesu;
    JSONArray saveFile=new JSONArray();
    JSONObject tmp;
    for(Node n: boss.getNodes()){
     tmp = n.getJSON();      
     saveFile.setJSONObject(saveFile.size(),tmp);  
    }
    frame.setTitle("EDITOR Noduino - "+sPath);
    saveJSONArray(saveFile,sPath);
    treeBuilder();
    sensorsBuilder();
    actuatorsBuilder();
  }
  
  public void treeBuilder(){
    JSONArray tree=new JSONArray();
    JSONArray tmpAct=new JSONArray();
    JSONObject tmpChild;
    Node tmp;
    ArrayList<Node> actuators= new ArrayList<Node>(0);
    
    for(Node n:boss.getNodes()){
       if(n.getType()=="ACTU"){
         actuators.add(n);
       }
    }
    for(Node act: actuators){
      
      ArrayList<Node> queue=new ArrayList<Node>(0);
      
      ListIterator<Node> it =queue.listIterator();
      queue.add(act);
      int i=0;
      while(i<queue.size())
      {
        tmp = queue.get(i);

        tmpAct.setJSONObject(tmpAct.size(),tmp.getTJSON());
        for(Node s:tmp.getFathers()){

              queue.add(s);

              
            }

        queue.remove(i);        
      }
      
      tree.setJSONArray(tree.size(),tmpAct);
      
      
      
    }
    saveJSONArray(tree,"tree.json");
    
  }
  
  public void sensorsBuilder(){
    //{"id" : "2" , "tag" : "sensore1" , "COM" : "COM2" , "pin" : 0, "actuators" : ["A1", "A2", "A3"]} ,
    JSONArray tree=new JSONArray();
    
    JSONObject tmpChild;
    Node tmp;
    ArrayList<Node> sensors= new ArrayList<Node>(0);
    
    for(Node n:boss.getNodes()){
       if(n.getType()=="SENS"){
         sensors.add(n);
         println("---------------------"+n.getTJSON());
       }
    }
    for(Node sen: sensors){
      JSONObject tmpSen=new JSONObject();
      JSONArray actus  =new JSONArray(); //attuatori relativi al sensore sen
      ArrayList<Node> queue=new ArrayList<Node>(0);
      
      ListIterator<Node> it =queue.listIterator();
      queue.add(sen);
      int i=0;
      while(i<queue.size())
      {
        tmp = queue.get(i);
//      tmpAct.setJSONObject(tmpAct.size(),tmp.getTJSON());
        for(Node s:tmp.getSons()){
              println(s.getJSON());
              queue.add(s);
              if(s.getType()=="ACTU"){
                println("appended!");
                actus.append(s.getId());}
              
            }

        queue.remove(i);        
      }
      tmpSen.setInt("id",sen.getId());
      tmpSen.setString("name",sen.getName());
      tmpSen.setString("com",sen.getCOM());
      tmpSen.setInt("pin",sen.getPin());
      tmpSen.setJSONArray("actuators",actus);
      tree.append(tmpSen);
      
      
      
    }
    saveJSONArray(tree,"sensors.json");
  }

 
  
  public void actuatorsBuilder(){
    //{"id" : "2" , "tag" : "sensore1" , "COM" : "COM2" , "pin" : 0, "actuators" : ["A1", "A2", "A3"]} ,
    JSONArray tree=new JSONArray();
    JSONObject tmpChild;
    Node tmp;
    ArrayList<Node> actuators= new ArrayList<Node>(0);
    
    for(Node n:boss.getNodes()){
       if(n.getType()=="ACTU"){
         actuators.add(n);
         println("---------------------"+n.getTJSON());
       }
    }
    for(Node act: actuators){
      JSONObject tmpAct=new JSONObject();
      JSONArray sens  =new JSONArray(); //sensori relativi al'attuatore act
      ArrayList<Node> queue=new ArrayList<Node>(0);
      
      ListIterator<Node> it =queue.listIterator();
      queue.add(act);
      int i=0;
      while(i<queue.size())
      {
        tmp = queue.get(i);
//      tmpAct.setJSONObject(tmpAct.size(),tmp.getTJSON());
        for(Node s:tmp.getFathers()){
              println(s.getJSON());
              queue.add(s);
              if(s.getType()=="ACTU"){
                println("appended!");
                sens.append(s.getId());}
              
            }

        queue.remove(i);        
      }
      tmpAct.setInt("id",act.getId());
      tmpAct.setString("name",act.getName());
      tmpAct.setString("com",act.getCOM());
      tmpAct.setInt("pin",act.getPin());
      tmpAct.setJSONArray("sensors",sens);
      tree.append(tmpAct);
      
      
      
    }
    saveJSONArray(tree,"actuators.json");
  }

  }
