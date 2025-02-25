public class Mean{
    private double x;
    private double y;
    private double z;
    private Bod[] neighbours;
    private double[] neighboursDist;
    private double[] distancesToMeans;
    private int myIndex;

    //standartni konstruktor
    public Mean(double x, double y, double z, int index){
        this.x = x;
        this.y = y;
        this.z = z;
        this.myIndex = index;
        //System.out.println("BOD: "+index);
    }

    //gettry a settry
    public double getX() {
        return x;
    }

    public double getY() {
        return y;
    }

    public double getZ() {
        return z;
    }

    public Mean getMean(){
        return this;
    }

    public int getIndex(){return myIndex;}

    public void setMean(double x, double y, double z){
        this.x = x;
        this.y = y;
        this.z = z;
        //myIndex = -1;
    }

    public Bod getBod(){
        return new Bod(x,y,z);
    }

    //metoda pro porovnani
    public boolean stejne(Mean b, double odchylka){
        double xDiff = Math.abs(this.getX() - b.getX());
        double yDiff = Math.abs(this.getY() - b.getY());
        double zDiff = Math.abs(this.getZ() - b.getZ());
        //System.out.println(xDiff+"|"+yDiff+"|"+zDiff);
        //System.out.println(this.getX() +" "+b.getX()+" | "+this.getY() +" "+b.getY()+" | "+this.getZ() +" "+b.getZ());
        if((xDiff + yDiff + zDiff)<odchylka)return true;

        else return false;
    }

    //toStringy pro debugging
    @Override
    public String toString(){
        return "Mean "+myIndex+": "+x+" "+y+" "+z;
    }

    public String toString2(){
        return x+" "+y+" "+z;
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
}
