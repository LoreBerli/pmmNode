public class Manager {

  /*--------------- T O D O ---------------------
  /* Tutto ciò che riguarda la selezione dei nodi(SelectedSource,SelectedDrain,setNode(),setSourceNode(),setDrainNode())
  /* si regge in piedi a malapena.
  /* Ripulire e fare un interfaccia unica per poter SELEZIONARE/DESELEZIONARE nodi sorgente/nodi pozzo
  /*
  /*---------------------------------------------
   */

  public  VisualManager visual;
  public NodeFactory nFactory;
  private int lastID;
  private ArrayList<Node> sensors;//Eliminabile(?)
  private ArrayList<Node> actuators;//Eliminabile(?)
  private ArrayList<Node> nodes;
  private ArrayList<Node> vidBuff;//Eliminabile(?)
  private ArrayList<Connection> cons;//Eliminabile(?)
  private Node overed;
  private Node selectedSource;
  private Node selectedDrain;
  private boolean moving;



  public Manager() /*Costruttore*/
  {
    //    JSONObject tmp;            //Eliminabile(?)
    //    this.numS=sens.size();     
    //    this.numA=actu.size();
    //    sensors = new Sensor[numS];
    //    actuators = new Actuator[numA];
    //    for (int i=0; i<sens.size (); i++) {
    //      tmp = sens.getJSONObject(i);
    //      sensors[i] = new Sensor(i, 100, 32+50*i, tmp.getString("tag"));
    //
    //    }
    //    for (int i=0; i<actu.size (); i++) {
    //      tmp = actu.getJSONObject(i);
    //      actuators[i] = new Actuator(i, 800, 32+50*i, tmp.getString("tag"));
    //
    //    }
    nodes = new ArrayList<Node>(0);
    lastID =0;
    cons = new ArrayList<Connection>(0);  //Eliminabile(?)
    visual = new VisualManager(nodes, cons);
    nFactory = new NodeFactory();
    overed=selectedSource=selectedDrain=null;  
    vidBuff = new ArrayList<Node>(0);    //Eliminabile(?)
  }

  //questa cosa sta in piedi per miracolo. 
  //TODO:rivedere la procedura di SELEZIONE di un nodo
  public void setID(int id){
    lastID=id;
  }

  public Node getSSource() {
    return selectedSource;
  }
  public Node getDrain() {
    return selectedDrain;
  }

  public Node addNode(String type, String name) {//si occupa di chiamare la factory,dare un ID consistente con gli altri e aggiungerlo all'arraylist
    int id = lastID;
    lastID++;
    Node n = nFactory.getNode(type, name,id, id, 100, 100,"COM3");
    nodes.add(n);
    visual.addToBuff(n);//Eliminabile(?)
    return n;
  }

  public Node addNode(int id,int pin, String type, String name, int x, int y,String COM) {//prevede i parametri ID (follleee!),ed X,Y
    Node n = nFactory.getNode(type, name,pin, id, x, y,COM);
    nodes.add(n);
    visual.addToBuff(n);
    return n;
  }

  public Node getSource() {
    return selectedSource;
  }//gesù perchè ne ho messi due???

  public void renameNode(Node n, String s) {
    if (n!=null) {
      n.setName(s);
    }
  }

  public boolean getMoving() {
    return moving;
  }

  public void relocation(Node n) {
    visual.setMovingNode(n);
    moving=!moving;
  }


  public VisualManager getVisual() {
    return visual;
  }

  public boolean hasSelected() {
    if (selectedSource != null) {
      return true;
    } else {
      return false;
    }
  }

  //-----------------------------------------
  public void setSourceNode(Node n) {
    //if(!(n instanceof Actuator)){
    if (selectedSource != null) {
      selectedSource.clicked();
      //visual.addToBuff(selectedSource);
    }
    selectedSource = n;
    n.clicked();
    //delay(100);
    // }
  }
  public Node getNodeById(int id) {
    for (int j=0; j<nodes.size (); j++) {
      if (nodes.get(j).getId()==id) {
        return nodes.get(j);
      }
    }
    return null;
  }

  public void setDrainNode(Node n) {
    //disastro ma funziona.
    //EDIT:non funziona.BUG quando rimuovo una connessione e la reinstanzio sullo stesso nodo figlio
    //EDIT:BUG RIMOSSO
    
    if (selectedSource !=null && !(n instanceof Sensor)  && !(selectedSource instanceof Actuator)) {//se non esiste già un nodo sorgente e quello selezionato non è un sensore
      selectedDrain =n; //pongo il nuovo nodo a pozzo
      //delay(100);//gesù
      if (!selectedSource.isSon(selectedDrain)) {//se il nuovo pozzo NON è già figlio della sorgente
        //cons.add(new Connection(selectedSource, selectedDrain));//c'è bisogno di Connection??
        selectedSource.addSon(selectedDrain);
        selectedDrain.addFather(selectedSource);
        selectedDrain = null;
      } else {//altrimenti rimuovo il figlio
        selectedDrain.deleteFather(selectedSource);
        selectedSource.deleteSon(selectedDrain);
        selectedDrain = null;
        visual.majorDraw();
      }
      visual.addToBuff(selectedSource);
    } else {
      setSourceNode(n);
    }
  }

  public void deleteEverything() {
    nodes.clear();
    setID(0);
  }

  public void deleteNode(Node n) {
    if (nodes.contains(n)) {
      for (int j=0; j<n.getFathers ().size(); j++) {
        Node father= n.getFathers().get(j);
        father.deleteSon(n);
      }
      for (int j=0; j<n.getSons ().size(); j++) {
        Node son = n.getSons().get(j);
        son.deleteFather(n);
      }
      nodes.remove(n);

      visual.majorDraw();
    }
  }
  //---------------------------------------
  public void setNode(Node n) {
    if (selectedSource == null) {
      setSourceNode(n);
    } else {
      if (selectedSource != n && selectedDrain != n) {
        setDrainNode(n);
      } else {

        if (n==selectedSource) {
          selectedSource.clicked();
          //delay(100);
          visual.majorDraw();
          selectedSource=null;
        }
        //else{selectedDrain.clicked();}
      }
    }
  }

  public Node getSourceNode() { //esistono 3 metodi uguali.............
    return selectedSource;
  }

  public Node getDrainNode() {
    return selectedDrain;
  }

  public void setOvered(Node n) {
    if (overed!=null) {
      if (overed != n) {
        overed.over(false);
        visual.addToBuff(overed);
        overed=null;
        n.over(true);
        overed=n;
        visual.addToBuff(n);
      }
    } else {
      //println("overed era NULL");
      n.over(true);
      overed=n;
      visual.addToBuff(n);
    }
  }

  public void flushOvered() {
    if (overed!=null) {
      overed.over(false);
      visual.addToBuff(overed);
      overed=null;
    }
  }


  public String lastNodes() {//Eliminabile(?)
    if (cons.size()>0) {
      Connection a = cons.get(cons.size()-1);
      return a.getString();
    } else return "";
  }

  public int getConsSize() {//Eliminabile(?)
    return cons.size();
  }

  public void flushSel() {
    if (selectedSource!=null) {
      selectedSource.clicked();
      visual.addToBuff(selectedSource);
      selectedSource=null;
    }
    if (selectedDrain!=null) {
      //selectedDrain.clicked();
      visual.addToBuff(selectedDrain);
      selectedDrain=null;
    }
  }


  public ArrayList<Node> getNodes() {
    return nodes;
  }
}

