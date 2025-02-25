import java.io.*;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Random;
import java.util.Scanner; // Import the Scanner class to read text files

public class Classifier {
    //globalni promenne, nastavovany parametry pri spusteni
    //pocet stredu
    public static int CLUSTERS = 5;
    //soubory pro cteni a zapis
    public static String fn = "C:\\Users\\jakub\\OneDrive\\Plocha\\bc\\clustering_intro\\clustering_intro\\data\\Room3";
    //klasifikovat geodeticky (true), nebo pouze podle metody spocitejVzdalenost (false) (napr. pro euclid, nebo manhatton distance)
    public static boolean geodKlasifikace = false;
    //vypocet vzdalenosti pomoci euclidovske (true) nebo manhattnovske metriky (false)? pro spravny beh geod (pokud je true) doporucuji euclid
    public static boolean euclidDistanceCompute = false;
    //prepocitavat stredy a menit jejich polohu
    public static boolean moveMeans = true;
    //počáteční pohola vygenerovaných means
    public static boolean meansStartPositionRandom = false;
    //počáteční pohola vygenerovaných means bude v oblasti některého z bodu datasetu - prednejsi nez ^^ meansStartPositionRandom ^^
    public static boolean meansStartPositionInPoints = true;
    //pohola means je známa z predchozich behu  - prednejsi nez ^^ meansStartPositionInPoints ^^
    public static boolean meansStartPositionKnown = false;
    //maximalni pocet iteraci s posunem mean
    public static int maxMoveMeans = 40;
    //pocet souradnic - pokud nebude 3 mohl by byt problem
    public static final int NUMBER_OF_COORDINADES = 3;

    //globalni promene potrebne pri vypoctech
    //vsechny nactene body
    public static ArrayList<Bod> body = new ArrayList<Bod>();
    //min hodnoty x y z
    public static double min[] = new double[NUMBER_OF_COORDINADES];
    //max hodnoty x y z
    public static double max[] = new double[NUMBER_OF_COORDINADES];
    //k jakemu stredu jaky bod patri
    public static int [] labels;
    //instance means
    public static Mean [] means;
    //character by which is input splited
    public static final String splitChar = " ";
    //soubor s ulozenymi vzdalenostmi
    public static String fnDist = fn.substring(0)+"_";
    //klasifikovat podle vzdalenosti geodeticke (true), nebo podle poctu bodu pres ktere se lze ke stredu dostat (false)
    public static final boolean ignoreCurrentIteration = true;
    //kombinace vice metrik
    public static final boolean multipleMetrics = true;


    //zpracovani vstupnich parametru a nastaveni globalnich promennych
    //1=file, 2=means, 3=metrics, 4=generate on position, 5=moveMeans, 6=maxIter
    public static int setArguments(String[] args){
        //System.out.println("\n-----------------------------------------------------\n");
        //for(int i = 0; i < args.length; i++) System.out.println(args[i]+"("+i+")");
        if(args.length<2){
            System.out.println("Not enough arguments. At least two arguments are needed - file with points and number of means. More details in documentation.");
            return 2;
        }
        if(args.length>6) System.out.println("Too many arguments, program will try to start with just six of them.");

        //1 - cesta k souboru
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

        //2 - means
        int mns;
        try {
            mns = Integer.parseInt(args[1]);
            CLUSTERS = Math.abs(mns);
        }
        catch (NumberFormatException e)
        {
            System.out.println("Second argument has to be whole number representing number of generated means.");
            return 2;
        }

        //3 - metrika - 0/E = euklidovska, 1/G = geodeticka, 2/M = manhatton else chyba
        if(args.length>2){
            String met = args[2];
            if(met.length()>3){
                System.out.println("Unvalid format of metrics argument. Setting on default - euclidean metrics.");
                geodKlasifikace = false;
                euclidDistanceCompute = true;
            }
            else if(met.contains("E") || met.contains("e") || met.contains("0")){//euclid
                geodKlasifikace = false;
                euclidDistanceCompute = true;
            }
            else if(met.contains("G") || met.contains("g") || met.contains("1")){//geod
                geodKlasifikace = true;
                euclidDistanceCompute = true;
            }
            else if(met.contains("M") || met.contains("m") || met.contains("2")){//manhattan
                geodKlasifikace = false;
                euclidDistanceCompute = false;
            }
            else{//neznámý příkaz
                System.out.println("Unvalid format of metrics argument. Setting on default - euclidean metrics.");
                geodKlasifikace = false;
                euclidDistanceCompute = true;
            }
        }
        else {//set default
            geodKlasifikace = false;
            euclidDistanceCompute = true;
        }

        //4 - kde budou means vygenerovany
        if(args.length>3){
            String startPos = args[3];
            //random = R/0, known = K/1, points = P/2, rohy = C/3
            if(startPos.length()>3){
                System.out.println("Unvalid format of means starting position argument. Setting on default - random position.");
                meansStartPositionRandom = true;
                meansStartPositionKnown=false;
                meansStartPositionInPoints=false;
            }
            else if(startPos.contains("R") || startPos.contains("r") || startPos.contains("0")){//random
                meansStartPositionRandom = true;
                meansStartPositionKnown=false;
                meansStartPositionInPoints=false;
            }
            else if(startPos.contains("K") || startPos.contains("k") || startPos.contains("1")){//known
                meansStartPositionRandom = false;
                meansStartPositionKnown=true;
                meansStartPositionInPoints=false;
            }
            else if(startPos.contains("P") || startPos.contains("p") || startPos.contains("2")){//points
                meansStartPositionRandom = false;
                meansStartPositionKnown=false;
                meansStartPositionInPoints=true;
            }
            else if(startPos.contains("C") || startPos.contains("c") || startPos.contains("3")){//corner
                meansStartPositionRandom = false;
                meansStartPositionKnown=false;
                meansStartPositionInPoints=false;
            }
            else{
                System.out.println("Unvalid format of means starting position argument. Setting on default - random position.");
                meansStartPositionRandom = true;
                meansStartPositionKnown=false;
                meansStartPositionInPoints=false;
            }
        }
        else{
            //System.out.println("Unvalid format of means starting position argument. Setting on default - random position.");
            meansStartPositionRandom = true;
            meansStartPositionKnown=false;
            meansStartPositionInPoints=false;
        }

        //5 move means
        if(args.length>4) {
            String move = args[4];
            if(move.contains("0"))moveMeans=false;
            else if(move.contains("1"))moveMeans=true;
            else moveMeans=true;
        }
        else moveMeans=true;

        //6 maximum iteraci
        if(args.length>5) {
            int max;
            try {
                max = Integer.parseInt(args[5]);
                max = Math.abs(max);
                maxMoveMeans=max;
            }
            catch (NumberFormatException e)
            {
                System.out.println("Argument for maximal number of iterations has to be whole number. Setting on default - 40.");
                maxMoveMeans = 40;
            }
        }
        else maxMoveMeans=40;

        return 1;
    }

    //trida spoustici program, nacte parametry a posle ke zpracovani, ...
    public static void main(String[] args) throws IOException {
        int ret = setArguments(args);
        if(ret == 2)return;
        int pointCounter = 0;
        System.out.println("Program start");
        long start = System.nanoTime();

        //upravit a osetrit multiple metrics option
        if(multipleMetrics){
            fnDist=fn.substring(0)+"_";
            if(euclidDistanceCompute){
                if(geodKlasifikace)fnDist+="G";
                else fnDist+="E";
            }
            else fnDist+="M";
        }

        //pripravit min a max na zjistejni oblasti dat
        for(int i = 0; i < min.length; i++){
            min[i] = Double.MAX_VALUE;
            max[i] = -Double.MAX_VALUE;
        }
        //nacteni bodu do pameti
        try {
            File myObj = new File(fn+".txt");
            Scanner myReader = new Scanner(myObj);
            myReader.nextLine();

            String [] lineArrayS = new String[NUMBER_OF_COORDINADES];
            double[] lineArray = new double[NUMBER_OF_COORDINADES];

            while (myReader.hasNextLine()) {
                String data = myReader.nextLine();
                lineArrayS = data.split(splitChar);
                for(int i = 0; i < NUMBER_OF_COORDINADES; i++){
                    lineArray[i] = Double.parseDouble(lineArrayS[i]);
                    if(lineArray[i]<min[i])min[i] = lineArray[i];
                    if(lineArray[i]>max[i])max[i] = lineArray[i];
                }
                //ziskani bodu a zapsani do seznamu
                body.add(new Bod(lineArray[0], lineArray[1], lineArray[2], pointCounter));
                pointCounter++;
            }
            //vypis informujici o uspesnem nacteni hodnot
            System.out.println(pointCounter + " points found");
            myReader.close();
            labels = new int[body.size()];

        } catch (FileNotFoundException e) {
            System.out.println("An error occurred.");
            e.printStackTrace();
        }

        //volani fce ktera body klasifikuje dle zadane metriky
        Mean[] means = klasifikuj(body, CLUSTERS);

        //pokud byla zvolena euklidovska a manahattanska metrika byli napocitany vzdalenosti od vsech means automaticky, pokud ne je nutne je napocitat pomoci nasledujici metody
        if(geodKlasifikace){
            //napocitat vzdalenosti od vsech mean
            allMeanDistances();
        }
        //zapis vysledku
        try {
            zapisLabels(means);
        } catch (IOException e) {
            e.printStackTrace();
        }
        //zapis do souboru s dodatkem _E, _M, nebo _G dle parametru spusteni
        if(multipleMetrics){
            //zapsat vzdalenosti
            //todo MARKER

            File fDist = new File(fnDist+".txt");
            fDist.createNewFile();
            FileWriter fw = new FileWriter(fnDist+".txt");
            for(int i = 0; i < body.size(); i++){
                double [] tmp = body.get(i).getDistances();
                for(int j = 0; j < CLUSTERS; j++){
                    //zapsat vysledky vzdalenosti do prislusnych souboru
                    if(j<CLUSTERS-1)fw.write(tmp[j]+" ");
                    else fw.write(tmp[j]+"\n");
                }
            }
            fw.write("\n");
            fw.close();

        }
        //vypsani delky vypoctu a ukonceni procesu
        long end = System.nanoTime();
        System.out.println(min[0]+" "+max[0]+"\n"+min[1]+" "+max[1]+"\n"+min[2]+" "+max[2]+"\n");
        System.out.println("Program finished within "+((end-start)/1000000000.0)+" sec");
    }

    //spocitani vzdalenosti od bodu ke vsem means (pro geodetickou metriku)
    private static void allMeanDistances() {
        int lastStopper = 0;
        //pro kazde mean
        for(int m = 0; m < means.length; m++){
            //System.out.println("work in progress");
            boolean [] checked = new boolean[body.size()];
            boolean stopper = false;
            //sousede bodu ktery budu kontrolovat
            Bod[] nbrs = new Bod[body.get(0).getNeighbours().length];
            //vzdalenosti od nich
            Double [] distances = new Double[nbrs.length];
            //urci prvni checked
            nbrs = means[m].getNeighbours();
            for(int i = 0; i < body.size(); i++){
                if(labels[i]==m)checked[i]=true;
            }

            while(!stopper){
                int remainCounter = 0;
                stopper = true;
                //projed vsechny body
                for(int i = 0; i < checked.length; i++){
                    //kdyz najdes bod uz se zapsanou vzdalenosti, preskoc ho
                    if(checked[i] || labels[i]>=CLUSTERS){continue;}
                    //nacteni sousedu
                    nbrs = body.get(i).getNeighbours();
                    //za kazdeho souseda zkuntroluj jestli ma konecnou vzdalenost k mean
                    for(int j = 0; j < nbrs.length; j++){
                        //ma soused vzdalenost od mean? zapsat ji k pozdejsimu porovnani s ostatnimi sousedy
                        if(checked[nbrs[j].getIndex()]){
                            //vzdalenost zkoumaneho bodu k mean pres urciteho souseda
                            distances[j] = nbrs[j].getDistances()[m]+spocitejVzdalenost(nbrs[j].getBod(), body.get(i));
                        }
                        else distances[j]=-1.0;
                    }
                    //mam vsechny vzdalenosti -> zjistit jaka je minimalni a zapsat ji do distancesToMeans[m]
                    Double min = Double.POSITIVE_INFINITY;
                    int minIndex = -1;
                    //najdi souseda pres ktereho budu k mean nejbliz
                    for(int j = 0; j < distances.length; j++){
                        if(distances[j]!=-1.0 && distances[j]<min){
                            min = distances[j];
                            minIndex = j;
                        }
                    }
                    //pokud takoveho souseda mas, zaspi bodu vzdalenost
                    if(minIndex!=-1){
                        //bodu prirad vzdalenost od urciteho mean
                        body.get(i).setDistanceToOtherMean(min, m);
                        checked[i]=true;
                    }
                    stopper=false;
                    remainCounter++;
                }
                if(lastStopper==remainCounter){
                    //maxDist je uhlopricka celeho datasetu
                    //todo maxDist měnit podle charakteru dat
                    Double maxDist = Math.sqrt((min[0]-max[0])*(min[0]-max[0]) + (min[1]-max[1])*(min[1]-max[1]) + (min[2]-max[2])*(min[2]-max[2]));

                    stopper=true;
                    System.out.println("unreachable mean for certain group of points");
                    //v datech jsou body, které maji nekonecnou vzdalenost od nějakého z means -> dam jim nesmyslně vysokou vzdalenost a poslu to dal, aby se nezasekl algoritmus
                    for(int i = 0; i < checked.length; i++){
                        //kdyz najdes bod uz se zapsanou vzdalenosti, preskoc ho
                        if(checked[i] || labels[i]>=CLUSTERS){continue;}
                        checked[i]=true;
                        body.get(i).setDistanceToOtherMean(Math.min(Double.MAX_VALUE,2*maxDist), m);
                    }
                }
                else lastStopper=remainCounter;

            }
        }
    }


    //klasifikuje a prijima body a pocet clusteru, vraci true pokud se povedlo
    public static Mean[] klasifikuj(ArrayList<Bod> body, int k) throws IOException {
        //podle parametru jsou znamy pozice stredu shluku - nacti a klasifikuj s nimi (param K)
        if(meansStartPositionKnown){
            moveMeans=false;
            //precti soubor s ulozenymi stredy shluku a nacti data
            FileReader fr = new FileReader(fn+"_means.txt");
            BufferedReader br = new BufferedReader(fr);
            br.readLine();
            String input = br.readLine();
            double tmpArr [];
            int counter = 0;
            ArrayList<Mean> meanList = new ArrayList<Mean>();
            //nacti data a uloz si je do seznamu stredu shluku
            while(!input.isEmpty() && !input.equals("\n")){
                String inArr [] = input.split(" ");
                tmpArr = new double[inArr.length];
                for(int i = 0; i < inArr.length; i++){
                    tmpArr[i] = Double.parseDouble(inArr[i]);
                }
                Mean newMean = new Mean(tmpArr[0], tmpArr[1], tmpArr[2], counter);
               meanList.add(newMean);
                counter++;
                input = br.readLine();
                if(input == null)break;
            }

            means=new Mean[meanList.size()];
            for(int i = 0; i < meanList.size(); i++){
                means[i]=meanList.get(i);
            }
        }
        //pokud je zadano P - vygeneruj stredy rovnomerne mezi body datasetu
        else if(meansStartPositionInPoints) means = vygenerujStredy(k);
        //pokud je zadano R vygeneruj stredy nahodne
        else if(meansStartPositionRandom) means = vygenerujStredyNahodne(k);
        //jinak vygeneruj stredy v rozich datasetu
        else means = vygenerujStredyVRozich(k);
        //Bod [] means = vygenerujStredy(k);

        //pokud klasifikuji geodeticky je nutne pro tento algoritmus, aby kazdy bod znal sve okoli se kterym muze pocitat vzdalenost
        if(geodKlasifikace){
            //kazdemu bodu najdi jeho nejblizsi sousedy
            napocitejSousedy();
            meanHledaSousedy(means);
        }

        //maximalni pocet iteraci zadanych parametrem
        int iter = maxMoveMeans;
        //menit jen konstantu -> konstanta = minimalni pocet iteraci
        int minIter = iter-0;
        boolean change = true;
        double [] dist = new double[means.length];
        //dokud probihaji zmeny v datech nebo nedojdou iterace
        while(iter > 0 && change || iter>minIter){
            iter--;
            change = false;
            int minJ = -1;


            //klasifikuje body k means podle euklidovske vzdalenosti
            for(int i = 0; i < body.size(); i++){
                minJ = -1;
                double minDist = Double.MAX_VALUE;
                double[] meansDist = new double[means.length];
                //spocitej vzdalenost bodu od means

                for(int j = 0; j < means.length; j++){
                    dist[j] = spocitejVzdalenost(means[j].getBod(), body.get(i));
                    meansDist[j] = dist[j];
                    if(minDist>dist[j]){
                        minJ = j;
                        minDist = dist[j];
                    }
                }
                body.get(i).setNearestMean(means[minJ]);
                body.get(i).setDistances(meansDist);
                labels[i] = minJ;
            }
            //pokud se ma klasifikovat geodeticky -> zavolej klasifikator, ktery je k tomu potreba, jinak zachovej vysledky ktere mas pomoci metody spocitejVzdalenost
            if(geodKlasifikace)klasifikujGeodeticky();

            System.out.println("End of iteration. At most "+iter+" iteratioins reamins.");
            if(moveMeans){
                change = prepocitejStredy(means);
                if(!change)break;
            }
            else change=false;

        }

        return means;
    }


    //metoda obarvi sousedy stredu a zavola metodu, ktera bude obarvovat zbytek
    //TODO MARKER
    private static void klasifikujGeodeticky() {
        //reset vsech labels
        for(int j = 0; j < body.size(); j++){
            labels[j] = -1;
            body.get(j).setMyMean(null);
        }
        //pro kazdy shluk se od stredu shluku rozpinej na sousedy techto stredu shluku
        for(int i = 0; i < CLUSTERS; i++){
            Bod[] sousediMean = means[i].getNeighbours();
            for(int j = 0; j < sousediMean.length; j++){
                //obarvim nejprve jen sousedy mean a zapisu jejich labels
                sousediMean[j].setMyMean(means[i]);
                labels[sousediMean[j].getIndex()]=means[i].getIndex();
                sousediMean[j].setDistToMyMean(spocitejVzdalenost(sousediMean[j], means[i].getBod()));
            }
        }
        //mam spoustu neklasifikovanych bodu, nebo se zastaralou klasifikaci a par nove klasifikovanych ktere jsou sousede means
        if(ignoreCurrentIteration){
            klasifikujZbytekVzdalenost();
        }
        else {
            klasifikujZbytekNSousedu();
        }

    }
    //u kazdeho bodu zjistim jestli ma obarvene sousedy, jestli ano, tak se obarvim stejnou barvou jako je vetsina sousedu
    //to opakuji dokud nejsou obarveny vsechny body
    private static void klasifikujZbytekVzdalenost() {
        boolean klasifikovano = false;
        int maxCounter = body.size()/2;
        while(!klasifikovano && maxCounter>0){
            maxCounter--;
            klasifikovano = true;
            int counter = 0;
            //u kazdeho bodu zjistim jestli ma obarvene sousedy, jestli ano, tak se obarvim tak abych barevně odpovídal s nejblizsim mean
            //pokud mam obarvene sousedy a neshodnou se na barve, tak se prekontroluji, zda jsem spravne
            for(int i = 0; i < body.size(); i++){
                //System.out.println("1: "+labels[i]);
                Bod[] sousede = body.get(i).getNeighbours();
                //bod je uz klasifikovany? jen rychla kontrola
                boolean kontrola = true;
                if(labels[i]!=-1){
                    kontrola = false;
                    int barva = labels[i];
                    for(int j = 0; j < sousede.length; j++) {
                        //pokud je tento soused obarveny ale neni stejne barvy jako kontrolovany bod
                        if (labels[sousede[j].getIndex()] != -1 && labels[sousede[j].getIndex()] != barva) {
                            kontrola = true;
                            break;
                        }
                    }
                }
                if(!kontrola)continue;

                //bod musi byt zkontrolovan - bud nema barvu, nebo se jeho sousede na barve neshodnou
                //koukni na sve sousedy a zapisuj si jejich barvy
                for(int j = 0; j < sousede.length; j++){
                    //ma muj soused  barvu (nepocitaje tuto iteraci)?
                    //System.out.println("2: "+labels[i]);
                    if(labels[sousede[j].getIndex()]!=-1){
                        double distThere = sousede[j].getDistToMyMean()+spocitejVzdalenost(sousede[j], body.get(i));
                        //mam to pres meho souseda bliz k jeho mean nez to mam k memu soucasnemu?
                        //jestli nemam mean, zkontroluji, ze mam vzdalenost nastavenou na max value
                        if(body.get(i).getMyMean()==null)body.get(i).setDistToMyMean(Double.MAX_VALUE);
                        if(distThere<body.get(i).getDistToMyMean()){
                            //pres tento bod je to k jeho mean bliz nez predtim -> uznavam to jako lepsi cestu a beru za sve jeho mean
                            body.get(i).setDistToMyMean(distThere);
                            body.get(i).setMyMean(sousede[j].getMyMean());
                        }
                    }
                }
            }

            //uloz tuto iteraci
            for(int i = 0; i < body.size(); i++){
                if(labels[i]==-1) {
                    klasifikovano = false;
                }
                //pokud ma bod sve mean a nemel ho uz pred tim, zapis jej jako vysledek teto iterace
                if(body.get(i).getMyMean()==null)continue;
                //System.out.println("lab: "+labels[i]+"\t points: "+body.get(i).getMyMean().getIndex()+"\tc="+counter);
                if(labels[i]!=body.get(i).getMyMean().getIndex() && body.get(i).getMyMean().getIndex()<=CLUSTERS){
                    //tuto iteraci se zmenilo nejake obarveni bodu -> nastala zmena a musime znovu iterovat
                    klasifikovano=false;
                    counter++;
                    labels[i] = body.get(i).getMyMean().getIndex();
                }
            }
        }

        if(maxCounter<=0){
            for(int i = 0; i < body.size(); i++){
                if(labels[i]==-1) {
                    labels[i]=CLUSTERS;
                }
            }
        }
    }


    //klasifikace bodu, ktere primo nesousedi se stredem shluku na zaklade toho, jestli s nimi sousedi jiz obarvene body, nebo ne -> vice iteraci
    private static void klasifikujZbytekNSousedu() {
        boolean klasifikovano = false;
        //pokud je vse klasifikovano ukoncit klasifikaci a presunout se dale
        while(!klasifikovano){
            klasifikovano = true;
            int counter = 0;
            int counter2 = 0;
            //u kazdeho bodu zjistim jestli ma obarvene sousedy, jestli ano, tak se obarvim tak, abych mel barvu vetsiny
            int [] barvySousedu = new int[CLUSTERS];
            for(int i = 0; i < body.size(); i++){
                //bod je uz klasifikovany? preskocit
                if(labels[i]!=-1){
                    counter2++;
                    continue;
                }
                Bod[] sousede = body.get(i).getNeighbours();
                //vsechny barvy resetovat na 0
                for(int j = 0; j<CLUSTERS; j++){
                    barvySousedu[j]=0;
                }
                //koukni na sve sousedy a zapisuj si jejich barvy
                for(int j = 0; j < sousede.length; j++){
                    //ma muj soused barvu?
                    if(labels[sousede[j].getIndex()]!=-1){
                        barvySousedu[labels[sousede[j].getIndex()]]++;
                    }
                }
                int max = 0;
                int maxID = -1;
                //jaka je vetsinova barva
                for(int j = 0; j<CLUSTERS; j++){
                    if(barvySousedu[j]>max){
                        max=barvySousedu[j];
                        maxID = j;
                    }
                }
                //obarvit bod vetsinovou barvou
                if(maxID!=-1){
                    counter++;
                    body.get(i).setMyMean(means[maxID]);
                    labels[i] = means[maxID].getIndex();
                }
            }

            //pokud je neklasifikovany bod, neskoncili jsme
            for(int i = 0; i < body.size(); i++){
                if(labels[i]==-1){
                    klasifikovano=false;
                    break;
                }
            }
        }

    }


    //jednoduche pro zmeny ve vzdalenosti
    //todo spocitej vzdalenost MARKER
    //zde je euklidovska a manahttanska metrika (pro vypocet vzdalenosti mezi dvema body u geodeticke metriky je v zakladu pouzivana euklidovska metrika)
    private static double spocitejVzdalenost(Bod mean, Bod bod) {
        //double res = 0;
        double a1 = mean.getX();
        double a2 = mean.getY();
        double a3 = mean.getZ();
        double b1 = bod.getX();
        double b2 = bod.getY();
        double b3 = bod.getZ();

        double res;
        if(euclidDistanceCompute)res = Math.sqrt((a1-b1)*(a1-b1) + (a2-b2)*(a2-b2) + (a3-b3)*(a3-b3));
        else res = Math.abs(a1-b1)+Math.abs(a2-b2)+Math.abs(a3-b3);
        //res = Math.sqrt(normX*normX + normY*normY + normZ*normZ);

        return res;
    }

    //pohyb stredu shluku do teziste svych shluku na konci iterace
    private static boolean prepocitejStredy(Mean [] means) {
        //System.out.println("--------------------------CHANGING POSITIONS OF MEANS--------------------------");
        boolean change = false;
        Mean[] meansCopy = new Mean[means.length];
        //zaloha predchozi iterace
        for(int a = 0; a < means.length; a++){
            meansCopy[a] = new Mean(means[a].getX(), means[a].getY(), means[a].getZ(), means[a].getIndex());
        }
        //presun kazdeho stredu shluku jednotlive
        for(int i = 0; i < means.length; i++){
            double x1 = means[i].getX();
            double y1 = means[i].getY();
            double z1 = means[i].getZ();
            BigDecimal x = new BigDecimal(x1);
            BigDecimal y = new BigDecimal(y1);
            BigDecimal z = new BigDecimal(z1);

            int counter = 0;
            for(int j = 0; j < labels.length; j++) {
                if (labels[j] == i) {
                    counter++;
                }
            }
            //scitani vsech bodu nalezici shluku
            for(int j = 0; j < labels.length; j++) {
                if (labels[j] == i && counter != 0) {
                    x = x.add(new BigDecimal((body.get(j).getX() - x1) / counter));
                    y = y.add(new BigDecimal((body.get(j).getY() - y1) / counter));
                    z = z.add(new BigDecimal((body.get(j).getZ() - z1) / counter));
                }
            }
            //nastaveni nove pozice
            means[i].setMean(x.doubleValue(),y.doubleValue(),z.doubleValue());
        }
        //pokud nejaky bod nesouhlasi se svou predchozi kopii byla ucinena v teto iteraci zmena
        //odchylka urcuje, kdy je pohyb stredu zanedbatelny a tedy uz neni potreba prepocitavani (budou se prepocitavat vsechny dokud bude alespon jeden nevyhovovat)
        //lze experimentovat s konstantou (napr zvysit odchylku a tim zkratit vypocet)
        double odchylka = Math.max(max[0]-min[0], Math.max(max[1]-min[1],max[2]-min[2]))/10000000;
        for(int k = 0; k < means.length; k++){
            if(!means[k].stejne(meansCopy[k], 0.000001))change = true;
        }

        //mean si musi najit sve sousedy
        meanHledaSousedy(means);
       return change;
    }

    //prohledani datasetu a nalezeni novych nejblizsich bodu pro stred shluku - novy sousede - prvni obraveni pri dalsi iteraci
    private static void meanHledaSousedy(Mean[] means) {
        int numOfN = (int)Math.pow(body.size(),1/2);
        if(numOfN<9)numOfN=9;
        for(int i = 0; i < means.length; i++){
            Bod[] sousede = new Bod[numOfN];
            double [] vzdalenostiSousedu = new double[numOfN];
            double dist;
            double currMaxD = Double.MAX_VALUE;
            int indexOut = -1;
            Bod bodA = means[i].getBod();

            //nastav si vzdalenosti na vychozi
            for(int j = 0; j < sousede.length; j++){vzdalenostiSousedu[j] = Double.MAX_VALUE;}
            //zkontroluj vsechny body
            for (int j = 0; j < body.size(); j++){
                Bod bodB = body.get(j);
                dist = spocitejVzdalenost(bodA, bodB);
                if(dist<currMaxD){
                    //je blizko a chci ji v sousedech nez najdu blizsi
                    sousede[numOfN-1] = bodB;
                    vzdalenostiSousedu[numOfN-1] = dist;
                    currMaxD = 0;
                    for(int k = 0; k < sousede.length; k++){
                        if(vzdalenostiSousedu[k]>currMaxD){
                            indexOut = k;
                            currMaxD = vzdalenostiSousedu[k];
                        }
                    }
                    //na konec pole dam nevzdalenejsi bod
                    sousede[numOfN-1] = sousede[indexOut];
                    vzdalenostiSousedu[numOfN-1] = vzdalenostiSousedu[indexOut];
                    //misto nej dam novy bod
                    sousede[indexOut] = bodB;
                    vzdalenostiSousedu[indexOut] = dist;
                }
            }
            means[i].setNeighbours(sousede, vzdalenostiSousedu);
        }
    }

    //generovani stredu nahode v ramci rozmeru datasetu
    private static Mean[] vygenerujStredyNahodne(int k) {
        Mean [] means = new Mean[k];
        double [] coords = new double[NUMBER_OF_COORDINADES];
        Random r = new Random();
        double [] multiplier = new double [NUMBER_OF_COORDINADES];
        for(int j = 0; j < NUMBER_OF_COORDINADES; j++) {
            multiplier[j] = max[j]-min[j];
        }

        for(int i = 0; i < k; i++){
            for(int j = 0; j < NUMBER_OF_COORDINADES; j++){
                coords[j] = r.nextDouble() * multiplier[j] + min[j];
            }
            means[i] = new Mean(coords[0], coords[1], coords[2], i);
            System.out.println("Generated mean "+i+": "+coords[0]+" "+coords[1]+" "+coords[2]);
        }
        return means;
    }

    //Bod reprezentujici stred se vygeneruje v miste kde je nejaky bod urcite casti seznamu bodu (rozdeleni seznamu na k casti, kde k je pocet stredu)
    private static Mean[] vygenerujStredy(int k) {
        Mean [] means = new Mean[k];
        double [] coords = new double[NUMBER_OF_COORDINADES];

        for(int i = 0; i < k; i++){
            int konst = i*body.size()/k+body.size()/(2*k);
            coords[0] = body.get(konst).getX();
            coords[1] = body.get(konst).getY();
            coords[2] = body.get(konst).getZ();

            means[i] = new Mean(coords[0], coords[1], coords[2], i);
            System.out.println("Generated mean (1st time): "+coords[0]+" "+coords[1]+" "+coords[2]);
        }
        return means;
    }

    //generace stredu v rozich - pak nahodne
    private static Mean[] vygenerujStredyVRozich(int k) {
        Mean [] means = new Mean[k];
        double [] coords = new double[NUMBER_OF_COORDINADES];

        //vygeneruj stred
        for(int i = 0; i < k; i++){
            if(i==0){coords[0] = min[0];coords[1] = min[1];coords[2] = min[2];}
            else if(i==2){coords[0] = min[0];coords[1] = max[1];coords[2] = min[2];}
            else if(i==3){coords[0] = max[0];coords[1] = min[1];coords[2] = max[2];}
            else if(i==1){coords[0] = max[0];coords[1] = max[1];coords[2] = max[2];}
            //pokud je potreba generovat dalsi stredy shluku, generuji se na nahodnych mistech
            else{
                Mean [] rand = vygenerujStredy(1);
                Mean r = rand[0];
                coords[0] = r.getX();
                coords[1] = r.getY();
                coords[2] = r.getZ();
            }
            means[i] = new Mean(coords[0], coords[1], coords[2], i);
            System.out.println("Generated mean (1st time): "+coords[0]+" "+coords[1]+" "+coords[2]);
        }
        return means;
    }

    //najdi nejblizsi sousedy kazdeho bodu (pro pocitani vzdalenosti po povrchu)
    //ziskani informace o okoli kazdeho bodu pro nasledne spocitani geodeticke metriky
    private static void napocitejSousedy(){
        int numOfN = (int)Math.pow(body.size(),1/2);
        if(numOfN<9)numOfN=9;
        //najdi kazdemu bodu numOfN sousedu
        for(int i = 0; i < body.size(); i++){
            Bod[] sousede = new Bod[numOfN];
            double [] vzdalenostiSousedu = new double[numOfN];
            double dist;
            double currMaxD = Double.MAX_VALUE;
            int indexOut = -1;
            Bod bodA = body.get(i);

            //nastav si vzdalenosti na vychozi
            for(int j = 0; j < sousede.length; j++){vzdalenostiSousedu[j] = Double.MAX_VALUE;}
            //zkontroluj vsechny body
            for (int j = 0; j < body.size(); j++){
                if(i!=j){
                    Bod bodB = body.get(j);
                    dist = spocitejVzdalenost(bodA, bodB);
                    if(dist<currMaxD){
                        //je blizko a chci ji v sousedech nez najdu blizsi
                        sousede[numOfN-1] = bodB;
                        vzdalenostiSousedu[numOfN-1] = dist;
                        currMaxD = 0;
                        for(int k = 0; k < sousede.length; k++){
                            if(vzdalenostiSousedu[k]>currMaxD){
                                indexOut = k;
                                currMaxD = vzdalenostiSousedu[k];
                            }
                        }
                        //na konec pole dam nevzdalenejsi bod
                        sousede[numOfN-1] = sousede[indexOut];
                        vzdalenostiSousedu[numOfN-1] = vzdalenostiSousedu[indexOut];
                        //misto nej dam novy bod
                        sousede[indexOut] = bodB;
                        vzdalenostiSousedu[indexOut] = dist;
                    }
                }

            }
            bodA.setNeighbours(sousede, vzdalenostiSousedu);
        }
    }


    //do souboru zapis k jakemu stredu jaky bod patri - zapis vysledku
    private static void zapisLabels(Mean[] means) throws IOException {

        String fileName = fn+"_labels.txt";
        File out = new File(fileName);
        out.createNewFile();
        FileWriter mw = new FileWriter(fileName);
        mw.write(labels[0]+"");
        for(int i = 1; i < labels.length; i++){
            mw.write(" "+labels[i]);
        }
        mw.close();

        String fileNameMeans = fn+"_means.txt";
        File outMeans = new File(fileNameMeans);
        outMeans.createNewFile();
        FileWriter mw2 = new FileWriter(fileNameMeans);
        mw2.write("x y z\n");
        for(int j = 0; j < means.length; j++){
            mw2.write(means[j].toString2()+"\n");
        }
        mw2.close();
    }
}
