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
    
    Node tmpNode;
    for(int i=0;i<boss.getNodes().size();i++){
      tmp = new JSONObject();
      tmpNode = boss.getNodes().get(i);
      tmp.setInt("id",tmpNode.getId());
      tmp.setInt("pin",tmpNode.getPin());
      tmp.setString("desc",tmpNode.getDescr());
      tmp.setString("name",tmpNode.getName());
      tmp.setString("type",tmpNode.getType());
      tmp.setInt("posX",tmpNode.getX());
      tmp.setInt("posY",tmpNode.getY());
      JSONArray sons = new JSONArray();
      for(int j=0;j<tmpNode.getSons().size();j++){
        sons.setInt(j,tmpNode.getSons().get(j).getId());
      }
      tmp.setJSONArray("sons",sons);      
      JSONArray fathers = new JSONArray();
      for(int j=0;j<tmpNode.getFathers().size();j++){
        fathers.setInt(j,tmpNode.getFathers().get(j).getId());
      }
      tmp.setJSONArray("fathers",fathers);
      
     saveFile.setJSONObject(i,tmp);
      
      
      
    }
    frame.setTitle("EDITOR Noduino - "+sPath);
    saveJSONArray(saveFile,sPath);
  }

  }
