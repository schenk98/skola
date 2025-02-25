import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Scanner;

public class SampleFile {
    public static String fn = ".\\unknown.txt";
    // data/sampleConst = sampleData  - > cim vetsi tim min dat
    public static int sampleConst = 5;
    public static String splitter = " ";
    public static boolean simplify = true;

    //nacteni parametru spusteni a nastaveni globalnich promennych jako zakladnich hodnot pro spravny beh programu
    private static int setArgs(String[] args) {
        if (args.length <2) {
            System.out.println("Wrong number of arguments.");
            return 2;
        }
        //cesta k souboru
        String fileName = args[0];
        if (fileName.contains(".")) {
            String str = fileName.substring(fileName.lastIndexOf('.') + 1, fileName.lastIndexOf('.') + 2);
            if (str.contains("\\") || str.contains("/")) {
            } else fileName = fileName.substring(0, fileName.lastIndexOf('.'));
        }
        //System.out.println("file path trimmed from "+args[0]+" to "+fileName);
        File file = new File(fileName + ".txt");
        if (!file.exists()) {
            System.out.println("Couldn't find your file.");
            return 2;
        }
        fn = fileName;


        //simplify?
        if(args[1].contains("1")){
            simplify=true;
            if(args.length>2){
                try {
                    int cnst = Integer.parseInt(args[2]);
                    sampleConst = cnst;
                } catch (NumberFormatException e) {System.out.println("Wrong argument format");return 2;}
            }
        }
        else if(args[1].contains("0")){
            simplify=false;
            if(args.length>2){
                splitter = args[2];
            }
        }
        return 0;
    }

    //vstupni bod programu, nacte parametry a posle je na zpracovani, podle vysledku pak zavola pozadovanou metodu
    public static void main(String[] args) throws IOException {
        System.out.println("Program start");
        int ret = setArgs(args);
        if(ret == 2)return;
        if(simplify)Simplify();
        else TrimPointsToThree();
        System.out.println("Program finished");
    }

    //z poskytnuteho souboru vezme a zapise pouze prvni tri slozky vektoru popisujici bod. Jedna se o nutnost, pokud soubor obsahuje prok pozice bodu i jine hodnoty zapsane jako dimenze, pokud bychom jej chteli nasledne zobrazit pomoc Vizualizeru.
    //vysledky jsou ukladany do souboru s dodatkem _trimmed
    private static void TrimPointsToThree() {
        try {
            File myObj = new File(fn+".txt");
            File myObjIn = new File(fn+"_trimmed.txt");
            Scanner myReader = new Scanner(myObj);
            FileWriter mw = new FileWriter(myObjIn);
            //myReader.nextLine();
            mw.write("x y z\n");
            String valuesS [];
            while (myReader.hasNextLine()) {
                String data = myReader.nextLine();
                valuesS = data.split(splitter);
                mw.write(valuesS[0]+" "+valuesS[1]+" "+valuesS[2]+"\n");
            }
            myReader.close();
            mw.close();
        } catch (FileNotFoundException e) {
            System.out.println("An error occurred.");
            e.printStackTrace();
        } catch (IOException e) {
            System.out.println("An error occurred.");
            e.printStackTrace();
        }
    }

    //metoda pro zkraceni velkeho souboru. Rovnomerne odebira cast bodu aby vypocet byl jednodussi a data stale relativne rozumne distribuovana. Podle parametru zachova kazdy x-ty prvek.
    //nakonec vola metodu zapisSamples() pro samotne zapsani vysledku do souboru
    private static void Simplify() throws IOException {
        ArrayList<String>sample = new ArrayList<String>();
        try {
            File myObj = new File(fn+".txt");
            Scanner myReader = new Scanner(myObj);
            myReader.nextLine();

            int counter = 0;
            while (myReader.hasNextLine()) {
                counter++;
                String data = myReader.nextLine();
                if(counter == sampleConst){
                    sample.add(data);
                    counter = 0;
                }
            }
            myReader.close();
        } catch (FileNotFoundException e) {
            System.out.println("An error occurred.");
            e.printStackTrace();
        }
        zapisSamples(sample);
    }

    //Vysledky jsou ukladany do souboru s doplnkem _small
    private static void zapisSamples(ArrayList<String> sample) throws IOException {
        String fileName = fn+"_small.txt";
        File out = new File(fileName);
        out.createNewFile();
        FileWriter mw = new FileWriter(fileName);
        mw.write("x y z\n");
        for(int i = 1; i < sample.size(); i++){
            mw.write(sample.get(i)+"\n");
        }
        mw.close();
    }
}
