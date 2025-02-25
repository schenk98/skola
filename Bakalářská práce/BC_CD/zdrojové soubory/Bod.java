import java.util.ArrayList;

public class Bod {
    private double x;
    private double y;
    private double z;
    private Bod[] neighbours;
    private double[] neighboursDist;
    private double[] distancesToMeans;
    private int myIndex;
    private ArrayList<Bod> wayToMean = new ArrayList<Bod>();
    private Mean nearestMean;
    private Mean myMean = null;
    private double distToMyMean = Double.MAX_VALUE;

    //zakladni gettry a setry
    public Mean getMyMean() {
        return myMean;
    }

    public void setMyMean(Mean myMean) {
        this.myMean = myMean;
    }

    public double getDistToMyMean() {
        return distToMyMean;
    }

    public void setDistToMyMean(double distToMyMean) {
        this.distToMyMean = distToMyMean;
    }

    public void setDistanceToOtherMean(double dist, int mean){distancesToMeans[mean]=dist;}

    //zakladni konstruktory
    public Bod(double x, double y, double z){
        this.x = x;
        this.y = y;
        this.z = z;
    }
    public Bod(double x, double y, double z, int index){
        this.x = x;
        this.y = y;
        this.z = z;
        this.myIndex = index;
        //System.out.println("BOD: "+index);
    }

    //dalsi zakladni gettry a settry
    public double getX() {
        return x;
    }

    public double getY() {
        return y;
    }

    public double getZ() {
        return z;
    }

    public Bod getBod(){
        return this;
    }

    public int getIndex(){return myIndex;}

    public void setBod(double x, double y, double z){
        this.x = x;
        this.y = y;
        this.z = z;
        myIndex = -1;
    }

    //toString pro debugging
    @Override
    public String toString(){
        return myIndex+": "+x+" "+y+" "+z;
    }

    //porovnavaci metoda
    public boolean stejne(Bod b){
        if(this.getX() == b.getX() && this.getY() == b.getY() &&this.getZ() == b.getZ())return true;
        else return false;
    }

    //dalsi standartni gettry a settry
    public void setNeighbours(Bod[] neighbours, double[] distances){
        this.neighbours = neighbours;
        this.neighboursDist = distances;
    }

    public Bod[] getNeighbours(){
        return neighbours;
    }

    public void setDistances(double[] distances){
        this.distancesToMeans = distances;
    }

    public double[] getDistances(){
        return distancesToMeans;
    }


    //pridej prvek do cesty k mean  (nakonec nevyuzito)
    public void addToWTM(Bod a){
        this.wayToMean.add(a);
    }
    //zadej celou cestu k mean  (nakonec nevyuzito)
    public void setWTM(ArrayList<Bod> a){
        this.wayToMean = a;
    }
    //získej cestu k mean  (nakonec nevyuzito)
    public ArrayList<Bod> getWTM(){return wayToMean;}
    //získej cestu k mean ve stringu (nakonec nevyuzito)
    public String getWTMString(){
        String res = "";
        for(int i = 0; i < wayToMean.size(); i++){
            res+=wayToMean.get(i).getIndex()+" ";
        }
        return res;
    }

    //gettry a settry nejblizsiho stredu shluku
    public void setNearestMean(Mean m){this.nearestMean = m;}
    public Mean getNearestMean(){return this.nearestMean;}
}
