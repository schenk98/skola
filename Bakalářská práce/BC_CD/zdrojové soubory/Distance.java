import java.util.ArrayList;

//Trida, ktera byla vyuzivana jen pri vyvoji a debuggovani. Neni vyuzivana vyslednym programem
public class Distance {
    private double overAllDistance;
    private Bod start;
    private Mean end;
    private ArrayList<Bod> way;

    public Distance(Bod start, Mean end){
        this.start = start;
        this.end  = end;
        this.overAllDistance = 0;
        this.way = new ArrayList<Bod>();
    }

    public void addBod(Bod a){
        way.add(a);
    }

    public void setOverAllDistance(double overAllDistance) {
        this.overAllDistance = overAllDistance;
    }

    public void setStart(Bod start) {
        this.start = start;
    }

    public void setEnd(Mean end) {
        this.end = end;
    }

    public void setWay(ArrayList<Bod> way) {
        this.way = way;
    }

    public double getOverAllDistance() {
        return overAllDistance;
    }

    public Bod getStart() {
        return start;
    }

    public Mean getEnd() {
        return end;
    }

    public ArrayList<Bod> getWay() {
        return way;
    }
}
