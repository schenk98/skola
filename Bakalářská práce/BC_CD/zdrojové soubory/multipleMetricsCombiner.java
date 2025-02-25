import java.io.*;
import java.util.ArrayList;

public class multipleMetricsCombiner {
    public static String fn =  ".\\unknown.txt";
    // data/sampleConst = sampleData  - > cim vetsi tim min dat
    //pomer jednotlivych slozek v kombinaci
    public static double gPart = 0.8;
    public static double ePart = 0.2;
    public static double mPart = 0.0;

    //seznamy jednotlivych vzdalenosti pro vsechny slozky
    public static ArrayList<double []> distancesG = new ArrayList<double[]>();
    public static ArrayList<double []> distancesE = new ArrayList<double[]>();
    public static ArrayList<double []> distancesM = new ArrayList<double[]>();

    //nacteni parametru, zpracovani, znormalizovani vstupu a provedeni vypoctu
    public static void main(String[] args) throws IOException {
        int ret = setArgs(args);
        if(ret == 2)return;
        System.out.println("Program start");
        //srazit soucet na 1
        double sum = gPart + ePart + mPart;
        gPart /= sum;
        ePart /= sum;
        mPart /= sum;

        readFiles();
    }

    //nacteni a zkontrolovani prijatych parametru
    private static int setArgs(String[] args){
        if(args.length!=4){
            System.out.println("Wrong number of arguments.");
            return 2;
        }

        //cesta k souboru
        String fileName = args[0];
        if(fileName.contains(".")){
            String str = fileName.substring(fileName.lastIndexOf('.')+1,fileName.lastIndexOf('.')+2);
            if(str.contains("\\") || str.contains("/")){}
            else fileName=fileName.substring(0, fileName.lastIndexOf('.'));
        }
        //System.out.println("file path trimmed from "+args[0]+" to "+fileName);
        File file = new File(fileName+".txt");
        if(!file.exists()){
            System.out.println("Couldn't find your file.");
            return 2;
        }
        fn = fileName;


        //e
        try {
            double eu = Double.parseDouble(args[1]);
            ePart = eu;
        }catch (NumberFormatException e){System.out.println("Wrong argument format");return 2;}
        //m
        try {
            double ma = Double.parseDouble(args[2]);
            mPart = ma;
        }catch (NumberFormatException e){System.out.println("Wrong argument format");return 2;}
        //g
        try {
            double ge = Double.parseDouble(args[3]);
            gPart = ge;
        }catch (NumberFormatException e){System.out.println("Wrong argument format");return 2;}
        return 0;
    }


    //nacteni obsahu kombinovanych souboru a nasledny vypocet a zapis vysledku
    private static void readFiles() throws IOException {
        //zpracovani geodeticke casti
        if(gPart>0){
            //otevreni souboru
            File fg = new File(fn+"_G.txt");
            if(fg.length()<=1){
                System.out.println("didnt fing G file");
                return;
            }
            //nacteni souboru
            FileReader rg = new FileReader(fg);
            BufferedReader brg = new BufferedReader(rg);
            String s1 = brg.readLine();
            String [] tmp;
            double [] values;
            //zpracovani vstupu a prevedeni na cisla se kterymi pujde snadno pracovat
            while(!s1.isEmpty() || !s1.equals("")){
                tmp = s1.split(" ");
                values = new double[tmp.length];
                for(int i = 0; i < tmp.length; i++){
                    values[i] = Double.parseDouble(tmp[i]);
                    //System.out.print(values[i]+" ");
                }
                //System.out.println();
                distancesG.add(values);
                s1 = brg.readLine();
            }
            brg.close();
            rg.close();
        }
        //obdobne zpracovani casti pro euklidovskou metriku
        if(ePart>0){
            File fe = new File(fn+"_E.txt");
            if(fe.length()<=1){
                System.out.println("didnt fing E file");
                return;
            }
            FileReader re = new FileReader(fe);
            BufferedReader bre = new BufferedReader(re);
            String s1 = bre.readLine();
            String [] tmp;
            double [] values;
            while(!s1.isEmpty() || !s1.equals("")){
                tmp = s1.split(" ");
                values = new double[tmp.length];
                for(int i = 0; i < tmp.length; i++){
                    values[i] = Double.parseDouble(tmp[i]);
                    //System.out.print(values[i]+" ");
                }
                //System.out.println();
                distancesE.add(values);
                s1 = bre.readLine();
            }
            bre.close();
            re.close();
        }
        //obdobne zpracovani casti pro manhattanskou metriku
        if(mPart>0){
            File fm = new File(fn+"_M.txt");
            if(fm.length()<=1){
                System.out.println("didnt fing M file");
                return;
            }
            FileReader rm = new FileReader(fm);
            BufferedReader brm = new BufferedReader(rm);
            String s1 = brm.readLine();
            String [] tmp;
            double [] values;
            while(!s1.isEmpty() || !s1.equals("")){
                tmp = s1.split(" ");
                values = new double[tmp.length];
                for(int i = 0; i < tmp.length; i++){
                    values[i] = Double.parseDouble(tmp[i]);
                    //System.out.print(values[i]+" ");
                }
                //System.out.println();
                distancesM.add(values);
                s1 = brm.readLine();
            }
            brm.close();
            rm.close();
        }


        //cteni pripraveno -> nacit hodnoty ze souboru do promennych
        FileWriter labelsWriter = new FileWriter(new File(fn+"_labels.txt"));
        //ziskani poctu potrebnych iteraci - bodu v datasetu
        int iterations = distancesG.size();
        if(gPart==0.0)iterations = distancesE.size();

        //pro kazdy bod je nutne prepocitat vzdalenost ke vsem strdum shluku ze vsech poskytnutych vysledku s konstantou odpovidajici podilu teto slozky. Výsledne vzdalenosti jsou potreba porovnat a bod priradit k nejblizsimu stredu shluku
        for(int i = 0; i < iterations; i++){
            int minIndex = -1;
            double min = Double.POSITIVE_INFINITY;
            int iterations2 = distancesG.get(i).length;
            if(gPart==0.0)iterations2 = distancesE.get(i).length;

            for(int j = 0; j < iterations2; j++){
                double sum;
                //k sume pricist vzdalenost bodu od stredu shluku prenasobenou vzdy konstantou znacici cast kterou metrika ve vypostu zaujima (pro vsechny metriky)
                if(gPart==0)sum = distancesE.get(i)[j]*ePart + distancesM.get(i)[j]*mPart;
                else if(ePart==0)sum = distancesG.get(i)[j]*gPart + distancesM.get(i)[j]*mPart;
                else if(mPart==0)sum = distancesG.get(i)[j]*gPart + distancesE.get(i)[j]*ePart;
                else sum = distancesG.get(i)[j]*gPart + distancesE.get(i)[j]*ePart + distancesM.get(i)[j]*mPart;
                if(sum<min){
                    min = sum;
                    minIndex = j;
                }
            }
            //System.out.println(iterations2+" "+iterations+" "+min+" "+minIndex);
            if(minIndex==-1){
                System.out.println("something went terribly wrong");
                return;
            }
            //zapsani vysledku
            if(i==0)labelsWriter.write(minIndex+"");
            else labelsWriter.write(" "+minIndex);

        }
        labelsWriter.close();


    }
}
