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
      tmpNode = boss.addNode(tmp.getInt("id"),tmp.getInt("pin"),tmp.getString("type"),tmp.getString("name"),tmp.getInt("posX"),tmp.getInt("posY"));
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
        println("-"+tmp.getJSON());
        tmpAct.setJSONObject(tmpAct.size(),tmp.getTJSON());
        for(Node s:tmp.getFathers()){
              println("---------------------"+s.getTJSON());
              queue.add(s);
              println("Aggiunto:"+s.getName()+" ADESSO:[SIZE:"+queue.size()+"]");
              
            }

        queue.remove(i);        
      }
      
      tree.setJSONArray(tree.size(),tmpAct);
      
      
      
    }
    saveJSONArray(tree,"tree.json");
  }

  }
