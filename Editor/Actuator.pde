public class Actuator extends Node {
  public Actuator(int id, int pin,int posX, int posY, String name,String COM) {
    super(id,pin, posX, posY, name,COM);
  }


  public void addFather(Node n) {
    if (this.fathers.size()>0) {
      fathers.remove(0);
    }
    fathers.add(n);
  }

  public String getType() {
    return "ACTU";
  }
  public int[] stateColor() {

    if (selected && overed) {
      return new int[] {
        255, 0, 0
      };
    }
    if (selected) {
      return new int[] {
        200, 0, 0
      };
    }
    if (overed) {
      return new int[] {
        128, 0, 0
      };
    }
    if (rSelected) {
      return new int[] {
        128, 0, 128
      };
    } else {

      return new int[] {
        128, 64, 64
      };
    }
  }
}

