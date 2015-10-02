import java.util.*;
import controlP5.*;
ControlP5 cp5;

int SIZE = 32;          //parametro per la grandezza dei nodi
public Manager boss;
public VisualManager visual;
public Node[] arr;      //inutile??
public Parser parser;
//---------------GUI------------------
Textfield nameText;     //casella testo Nome nodo
Textfield comText;      //casella testo COM nodo
Textfield pinText;      //casella testo Pin nodo
Textfield descText;     //casella testo Descrizione nodo
Textfield loadPath;     //casella testo carica configurazione
Textfield savePath;     //casella testo salva configurazione
Textarea testo;         //casella testo info nodo
Button load;            //bottone caricamento
Button save;            //bottone salvataggio
public Button[] btns;   //array dei bottoni-funzione
//----------------------------------
boolean moving;         //TRUE quando un nodo sta venendo spostato


void setup() {
  size(1024, 700);      //dimensioni hard coded. TODO: adattabile? Forse
  frame.setTitle("EDITOR Noduino");
  moving=false;
  //---------------GUI------------------
  cp5 = new ControlP5(this);//controller della GUI
  cp5.addButton("Sensore", 0.0, 4, 2, 60, 32);
  cp5.addButton("Attuatore", 1.0, 70, 2, 60, 32);
  cp5.addButton("CLEAR", 1.0, 280, 2, 60, 32);
  cp5.addButton("+", 1.0, 2, 74, 16, 16);
  cp5.addButton("-", 1.0, 20, 74, 16, 16);
  loadPath = cp5.addTextfield("LoadConfig").setPosition(832, 2).setSize(122, 20).setColor(color(0)).setColorBackground(color(255));
  savePath = cp5.addTextfield("SaveConfig").setPosition(832, 38).setSize(122, 20).setColor(color(0)).setColorBackground(color(255));
  load =  cp5.addButton("Carica", 0.0, 958, 2, 64, 20);
  save =  cp5.addButton("Salva", 0.0, 958, 38, 64, 20);
  nameText = cp5.addTextfield("name").setPosition(4, 38).setSize(80, 20).setColor(color(0)).setColorBackground(color(255));
  comText = cp5.addTextfield("COM").setPosition(88, 38).setSize(60, 20).setColor(color(0)).setColorBackground(color(255));
  pinText = cp5.addTextfield("Pin").setPosition(88, 80).setSize(60, 20).setColor(color(0)).setColorBackground(color(255));
  descText = cp5.addTextfield("Description").setPosition(152, 38).setSize(188, 20).setColor(color(0)).setColorBackground(color(255));
  //cp5.addButton("Carica Funzioni", 1.0, 206, 2, 64, 32);
  testo = cp5.addTextarea("txt").setPosition(346, 2).setSize(100, 90).setLineHeight(10).setColor(color(0)).setColorBackground(color(255));
  //----------------------------------
  boss = new Manager();
  visual = boss.getVisual();
  parser = new Parser(boss, cp5, btns);
  parser.getFunctions();
}

void controlEvent(ControlEvent theEvent) { //controllore eventi della GUI
  if (theEvent.isController()) { 
    if (theEvent.controller().getName()=="Carica") {
      Loader l = new Loader(boss);
      l.load(loadPath.getText());
    }

    if (theEvent.controller().getName()=="Salva") {
      Loader l = new Loader(boss);
      l.save(savePath.getText());
    }

    if (theEvent.controller().getName()=="Sensore") {
      Node n = boss.addNode("SENS", "sensor");
      boss.relocation(n);
    }
    if (theEvent.controller().getName()=="Attuatore") {
      Node n =boss.addNode("ACTU", "actuator");
      boss.relocation(n);
    }
    if (theEvent.controller().getName()=="CLEAR") {
      boss.deleteEverything();
    }
    if (theEvent.controller().getName()=="Carica Funzioni") {
      parser.getFunctions();
    }

    if (theEvent.controller().getName()=="+") {
      if (SIZE<72) {
        SIZE = SIZE+10;
      }
    }
    if (theEvent.controller().getName()=="-") {
      if (SIZE>12) {
        SIZE = SIZE-10;
      }
    }
  }
}



void draw() {//TODO tutto il vidBuff è obsoleto, devo refreshare tutto comunque.
  //TODO:andrebbe pulito tutto il ciclo di DRAW

  String s; //diiogesùùùùùùùùùùùùùùùùùùù
  visual.drawNodes();
  //visual.drawCon();
  

  String sInfo;
  String dInfo;

  //...
  Node sInfoedNode;//Nodo di cui mostrare le info
  sInfoedNode = boss.getSSource();//è quello selezionato
  if (sInfoedNode!=null) {
    sInfo=sInfoedNode.getSonsInfo();
    dInfo=sInfoedNode.getFathersInfo();
  } else {
    sInfo=dInfo="No node selected";
  }
  testo.setText(Float.toString(frameRate)+"\n" + sInfo+"\n" +dInfo); 
  //...
  
  
  //---------------------------------
  Node tmp;//Nodo eventualmente selezionato
  tmp = visual.checkColl();//ritorna un riferimento ad un nodo se il puntatore collide con esso

  if (tmp!=null) {
    if (mousePressed && (mouseButton == LEFT) && boss.getMoving()==false) {//se sto cliccandoSX su di un nodo ed il nodo NON é in movimento
      nameText.clear();
      comText.clear();                 /*  Svuoto le caselle di testo  */
      descText.clear();
      pinText.clear();
      delay(100);
      boss.setNode(tmp);               /*   passo il riferimento al Manager */
      sInfoedNode = boss.getSSource(); /*   per qualche motivo questa riga è necessaria....TODO:capire perchè*/
      if (sInfoedNode!=null) {
        nameText.setText(sInfoedNode.name);
        comText.setText(sInfoedNode.getCOM());/*   riempio le caselle di testo con le info sul nodo */
        descText.setText(sInfoedNode.getDescr());
        pinText.setText(Integer.toString(sInfoedNode.getPin()));
      }
    }

    if (mousePressed && (mouseButton == RIGHT)) {//se sto cliccandoDX su di un nodo
      delay(90);//TODO: quanto deve essere il delay??
      boss.relocation(tmp);//procedura di relocation.Fino alla prossima chiamata a relocation(node) il nodo tmp è solidale con il puntatore
      } 
      else{
      boss.setOvered(tmp);//se il puntatore collide con un nodo MA nessun bottone è premuto poni Node.overed a true.
    }
  } else {//ramo in cui tmp è nullo => il puntatore non collide con niente.
    if (mousePressed &&(mouseButton == LEFT) && mouseY > 120) {//se premo col sinistro fuori dal pannello(y>100)
      if (sInfoedNode!=null) {                               /*.....???wtf */
        sInfoedNode.setFunctionDesc(descText.getText());     /*.....???wtf */
        sInfoedNode.setCom(comText.getText());   
        sInfoedNode.setPin(Integer.parseInt(pinText.getText()));        /*.....???wtf */
        boss.renameNode(sInfoedNode, nameText.getText());    /*.....???wtf */
      }

      nameText.clear();
      comText.clear();  /* svuoto le caselle di testo  */
      descText.clear();
      pinText.clear();
      boss.flushSel();  /* svuoto il riferimento a nodi selezionati */ 
      visual.majorDraw();
    }
    boss.flushOvered(); /* svuoto il riferimento a nodi overed */
  }
  /*-----------------------*/
  /* TODO:eliminabile????? */
  if (keyPressed) {
    if (key=='q') {
      boss.flushSel();
    }
    if (key==DELETE && boss.hasSelected()) {
      boss.deleteNode(boss.getSSource());
    }
    if (key==ENTER && boss.hasSelected()) {
    }
  }
  /*----------------------*/
  visual.majorDraw();
}

