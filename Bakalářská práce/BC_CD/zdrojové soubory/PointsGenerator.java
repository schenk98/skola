import java.io.File;
import java.io.FileWriter;
import java.io.IOException;

///Program pro generaci umelych dat pro CLassifier
public class PointsGenerator {
    private static String fn = ".\\unknown.txt";

    //nacteni argumentu a provedeni akci
    public static void main(String[] args) throws IOException {
        System.out.println("Program start");
        int ret = input(args);
        if(ret==2)System.out.println("Program failed to generate file");
        else System.out.println("Program finished succesfully");
    }


    //generace ctverce - vsupnim argumentem je velikost strany
    private static void generateSquare(int a) throws IOException {
        File f = new File(fn);
        FileWriter fw = new FileWriter(fn);
        fw.write("x y z\n");
        for(int i = 0; i < a; i++){
            for(int j = 0; j < a; j++){
                fw.write(i+" "+j+" 0\n");
            }
        }
        fw.close();
    }
    //generace kruhu, vstupnim argumentem je prumer kruhu
    private static void generateCircle(int a) throws IOException {
        File f = new File(fn);
        FileWriter fw = new FileWriter(fn);
        fw.write("x y z\n");
        for(int i = -a/2; i < a/2; i++){
            for(int j = -a/2; j < a/2; j++){
                if(Math.sqrt(i*i+j*j)<a/2)fw.write(i+" "+j+" 0\n");
            }
        }
        fw.close();
    }
    //generace tvaru C - vstupnim argumentem je prumer vnejsiho kruhu (kruhu opsaneho tomuto tvaru)
    private static void generateC(int a) throws IOException {
        File f = new File(fn);
        FileWriter fw = new FileWriter(fn);
        fw.write("x y z\n");
        for(int i = -a/2; i < a/2; i++){
            for(int j = -a/2; j < a/2; j++){
                if(Math.sqrt(i*i+j*j)<a/2 && Math.sqrt(i*i+j*j)>a/5 && !(i>-a/10 && i<a/10 && j>0))fw.write(i+" "+j+" 0\n");
            }
        }
        fw.close();
    }
    //generace krychle - vstupnim argumentem je velikost strany (krychle je duta)
    private static void generateCube(int a) throws IOException {
        File f = new File(fn);
        FileWriter fw = new FileWriter(fn);
        fw.write("x y z\n");
        //podstava
        for(int i = 0; i < a; i++){
            for(int j = 0; j < a; j++){
                fw.write(i+" "+j+" 0\n");
            }
        }
        //steny
        //vrstvy
        for(int i = 0; i < a; i++){
            //vodorovne
            for(int j = 0; j < a; j++){
                fw.write(0+" "+j+" "+i+"\n");
                fw.write(a+" "+j+" "+i+"\n");
            }
            //svisle
            for(int j = 0; j < a; j++){
                fw.write(j+" "+0+" "+i+"\n");
                fw.write(j+" "+a+" "+i+"\n");
            }
        }
        //druha podstava
        for(int i = 0; i < a; i++){
            for(int j = 0; j < a; j++){
                fw.write(i+" "+j+" "+a+"\n");
            }
        }
        fw.close();
    }
    //generace koule - vstupnim argumentem je prumer (koule je duta)
    private static void generateSphere(int a) throws IOException {
        File f = new File(fn);
        FileWriter fw = new FileWriter(fn);
        fw.write("x y z\n");
        for(int i = -a/2; i < a/2; i++){
            for(int j = -a/2; j < a/2; j++){
                for(int k = -a/2; k < a/2; k++){
                    if(Math.sqrt(i*i+j*j+k*k)>a/2-a/(a/2) && Math.sqrt(i*i+j*j+k*k)<a/2/*+a/(a/2)*/)fw.write(i+" "+j+" "+k+"\n");
                }
            }
        }
        fw.close();
    }
    //generace valce - vstupnimi parametry jsou prumer podstavy a vyska
    private static void generateCilinder(int a, int b) throws IOException {
        File f = new File(fn);
        FileWriter fw = new FileWriter(fn);
        fw.write("x y z\n");
        //podstavy
        for(int i = -a/2; i < a/2; i++){
            for(int j = -a/2; j < a/2; j++){
                if(Math.sqrt(i*i+j*j)<a/2){
                    fw.write(i+" "+j+" 0\n");
                    fw.write(i+" "+j+" "+b+"\n");
                }
            }
        }
        //steny
        //patra
        double ang, x, y;
        int cnst = 90;
        for(int i = 0; i < b; i++){
            //body kruznice
            for(int j = cnst; j > 0; j--){
               ang = (Math.PI * 2) * j/cnst;
               x = Math.cos(ang)*(a/2);
               y = Math.sin(ang)*(a/2);
               fw.write(x+" "+y+" "+i+"\n");
            }
        }

        fw.close();
    }

    //generace jehlanu - vstupnim argumentem je delka hrany podstavy
    private static void generatePyramid(int a) throws IOException {
        File f = new File(fn);
        FileWriter fw = new FileWriter(fn);
        fw.write("x y z\n");
        //podstava
        for(int i = 0; i < a; i++){
            for(int j = 0; j < a; j++){
                fw.write(i+" "+j+" 0\n");
            }
        }
        //steny
        //vrstvy
        for(int i = 0; i < a; i++){
            //vodorovne
            for(int j = i; j < a-i; j++){
                fw.write((a-i)+" "+j+" "+i+"\n");
                fw.write(i+" "+j+" "+i+"\n");
            }
            //svisle
            for(int j = i; j < a-i; j++){
                fw.write(j+" "+(a-i)+" "+i+"\n");
                fw.write(j+" "+i+" "+i+"\n");
            }
        }
        fw.close();
    }

    //generace kuzelu - parametrem je prumer podstavy
    private static void generateCone(int a) throws IOException {
        File f = new File(fn);
        FileWriter fw = new FileWriter(fn);
        fw.write("x y z\n");
        //podstavy
        for(int i = -a/2; i < a/2; i++){
            for(int j = -a/2; j < a/2; j++){
                if(Math.sqrt(i*i+j*j)<a/2){
                    fw.write(i+" "+j+" 0\n");
                }
            }
        }
        //steny
        //patra
        //nelze mit stale stejny pocet bodu v patre - ve vrcholu by bylo prilis mnoho bodu na jedne pozici
        double ang, x, y;
        int cnst = 90;
        for(int i = 0; i < a; i++){
            //body kruznice
            for(int j = cnst; j > 0; j--){
                ang = (Math.PI * 2) * j/cnst;
                x = Math.cos(ang)*((a-i)/2);
                y = Math.sin(ang)*((a-i)/2);
                x = Math.floor(x * 10000) / 10000;
                y = Math.floor(y * 10000) / 10000;

                if(x==0 && y==0)continue;
                fw.write(x+" "+y+" "+i+"\n");
                cnst-=cnst/(a-i)-1;
            }
        }
        fw.write("0 0 0\n");
        fw.close();
    }

    //generace prvniho slozitejsiho objektu, jedna se o neco co by mohlo pripominat rohovy schod - parametrem je velikost datasetu v ose x (nebo y)
    private static void generateStep1(int a) throws IOException {
        File f = new File(fn);
        FileWriter fw = new FileWriter(fn);
        fw.write("x y z\n");
        //podstavy
        for(int i = 0; i < a/2; i++){
            for(int j = 0; j < a/2; j++){
                fw.write(i+" "+j+" 0\n");
            }
        }
        for(int i = a/2; i < a; i++){
            for(int j = 0; j < a/2; j++){
                fw.write(i+" "+j+" 0\n");
            }
        }
        for(int i = 0; i < a/2; i++){
            for(int j = a/2; j < a; j++){
                fw.write(i+" "+j+" 0\n");
            }
        }
        //steny
        //vrstvy
        for(int i = 0; i < a/2; i++){
            //vodorovne
            for(int j = a/2; j < a; j++){
                fw.write(a/2+" "+j+" "+i+"\n");
                fw.write(a-1+" "+j+" "+i+"\n");
            }
            //svisle
            for(int j = a/2; j < a; j++){
                fw.write(j+" "+a/2+" "+i+"\n");
                fw.write(j+" "+(a-1)+" "+i+"\n");
            }
        }
        //druha podstava
        for(int i = a/2; i < a; i++){
            for(int j = a/2; j < a; j++){
                fw.write(i+" "+j+" "+a/2+"\n");
            }
        }
        fw.close();
    }

    //generace druheho slozitejsiho objektu, jedna se o slozitejsi verzi predchoziho datasetu. Muze to pripominat nekolik krychlich poskladanych do rohu - parametrem je velikost datasetu v ose x (nebo y)
    private static void generateStep2(int a) throws IOException {
        File f = new File(fn);
        FileWriter fw = new FileWriter(fn);
        fw.write("x y z\n");
        //podstavy
        for(int i = 0; i < a/3; i++){
            for(int j = 0; j < a/3; j++){
                fw.write(i+" "+j+" 0\n");
            }
        }
        for(int i = a/3; i < 2*a/3; i++){
            for(int j = 0; j < a/3; j++){
                fw.write(i+" "+j+" 0\n");
            }
        }
        for(int i = 0; i < a/3; i++){
            for(int j = a/3; j < 2*a/3; j++){
                fw.write(i+" "+j+" 0\n");
            }
        }
        //prvni patro
        for(int i = 2*a/3; i < a; i++){
            for(int j = 0; j < a/3; j++){
                fw.write(i+" "+j+" "+a/3+"\n");

            }
        }
        for(int i = 0; i < a/3; i++){
            for(int j = 2*a/3; j < a; j++){
                fw.write(i+" "+j+" "+a/3+"\n");

            }
        }
        for(int i = a/3; i < 2*a/3; i++){
            for(int j = a/3; j < 2*a/3; j++){
                fw.write(i+" "+j+" "+a/3+"\n");

            }
        }
        //steny
        for(int i = 0; i < a/3; i++){
            //segment a
            for(int j = 0; j < a/3; j++){
                fw.write(a+" "+j+" "+i+"\n");
                fw.write(((2*a/3)+j)+" "+0+" "+i+"\n");

                fw.write((2*a/3)+" "+j+" "+i+"\n");
                fw.write(((a/3)+j)+" "+(a/3)+" "+i+"\n");

                fw.write((a/3)+" "+((a/3)+j)+" "+i+"\n");
                fw.write(j+" "+(2*(a/3))+" "+i+"\n");

                fw.write(0+" "+((2*a/3)+j)+" "+i+"\n");
                fw.write(j+" "+a+" "+i+"\n");

            }
        }

        //druhe patro
        //vrstvy
        for(int i = 2*a/3; i < a; i++){
            for(int j = a/3; j < 2*a/3; j++){
                fw.write(i+" "+j+" "+2*a/3+"\n");

            }
        }
        for(int i = a/3; i < 2*a/3; i++){
            for(int j = 2*a/3; j < a; j++){
                fw.write(i+" "+j+" "+2*a/3+"\n");

            }
        }
        //steny
        for(int i = 0; i < (2*a/3); i++){
            //segment b
            for(int j = 0; j < a/3; j++){
                fw.write(a+" "+((a/3)+j)+" "+i+"\n");
                if(i>(a/3))fw.write(((2*a/3)+j)+" "+(a/3)+" "+i+"\n");


                if(i>(a/3))fw.write((2*a/3)+" "+((a/3)+j)+" "+i+"\n");
                if(i>(a/3))fw.write(((a/3)+j)+" "+(2*a/3)+" "+i+"\n");


                if(i>(a/3))fw.write((a/3)+" "+((2*a/3)+j)+" "+i+"\n");
                fw.write(((a/3)+j)+" "+a+" "+i+"\n");

            }
        }

        //treti patro
        //vrstvy
        for(int i = 2*a/3; i < a; i++){
            for(int j = 2*a/3; j < a; j++){
                fw.write(i+" "+j+" "+a+"\n");

            }
        }
        //steny
        for(int i = 0; i < a; i++){
            //segment c
            for(int j = 0; j < a/3; j++){
                if(i>(2*a/3)){fw.write(2*a/3+" "+((2*(a/3))+j)+" "+i+"\n");
                fw.write((2*a/3)+j+" "+(2*(a/3))+" "+i+"\n");}


                fw.write(a+" "+(a-j)+" "+i+"\n");
                fw.write((a-j)+" "+a+" "+i+"\n");

            }
        }

        fw.close();
    }

    //generace rovvineho tvaru delaneho na miru pro otestovani urcitych vlastnosti metrik
    private static void generateRoom1() throws IOException {
        File f = new File(fn);
        FileWriter fw = new FileWriter(fn);
        fw.write("x y z\n");
        for(int x = 0; x < 200; x++){
            for(int y = 0; y < 200; y++){
                if((x<70 && y>90 && y<110) ||
                   (x>50 && x<70 && (y<50 || y>140 || (y<=90 && y>65))) ||
                   (x>90 && x<110 && y>70) ||
                   (x>130 && x<145 && (y<50 || y>=90 && y<110)) ||
                   (x>160 && x<175 && (y<=70 && y>20 || y>150)) ||
                   (x>130 && y<90 && y>70) ||
                   (x>170 && y<170 && y>150) ||
                   (x>185 && y<60 && y>35)
                ){
                    continue;
                }
                else fw.write(x+" "+y+" 0\n");

            }
        }
        fw.close();
    }
    //generace rovvineho tvaru delaneho na miru pro otestovani urcitych vlastnosti metrik
    private static void generateRoom2() throws IOException {
        File f = new File(fn);
        FileWriter fw = new FileWriter(fn);
        fw.write("x y z\n");
        for(int x = 0; x < 200; x++){
            for(int y = 0; y < 200; y++){
                if((x>40 && y<160 && y>140) ||
                        (x>40 && x<160 && y>40 && y<60) ||
                        (x>90 && x<160 && y<110 && y>90) ||
                        (x>40 && x<60 && y>40 && y<160) ||
                        (x>140 && x<160 && y<110 && y>=60)
                ){}
                else fw.write(x+" "+y+" 0\n");

            }
        }
        fw.close();
    }
    //generace rovvineho tvaru delaneho na miru pro otestovani urcitych vlastnosti metrik
    private static void generateRoom3() throws IOException {
        File f = new File(fn);
        FileWriter fw = new FileWriter(fn);
        fw.write("x y z\n");
        for(int x = 0; x < 200; x++){
            for(int y = 0; y < 200; y++){
                int circleVar = (x - 100) * (x - 100) + (y - 100) * (y - 100);
                if(
                        (Math.sqrt(circleVar)<30) ||
                        (Math.sqrt(circleVar)>50 && Math.sqrt(circleVar)<65 && !(x>90 && x<110)) ||
                        ((x<30 || x>170) && ((y>45 && y<55) || (y>155 && y<165))) ||
                        ((y<30 || y>170) && ((x>45 && x<55) || (x>155 && x<165))) ||
                        ((x>20 && x<30 || x>170 && x<180) && y>70 && y<130) ||
                        (y>70 && y<80 && x<30) ||
                        (x>=55 && x<140 && y>20 && y<30)
                ){}
                else fw.write(x+" "+y+" 0\n");
            }
        }
        fw.close();
    }

    //nacteni parametru a nasledne zavolani pozadovane fce - zapis do souboru probiha primo v jednotlivych metodach
    //elif se ridi nasledujicim shrnutim
    //generateSquare(100);          //1 - square
    //generateCircle(100);          //2 - circle
    //generateC(100);               //3 - c
    //generateCube(100);            //4 - cube
    //generateSphere(100);          //5 -sphere
    //generateCilinder(100, 50);    //6  cilinder
    //generatePyramid(100);         //7 - pyramid
    //generateCone(100);            //8 - cone
    //generateStep1(100);           //9 - step1
    //generateStep2(90);            //10 - step2
    //generateRoom1();              //11 - room1
    //generateRoom2();              //12 - room2
    //generateRoom3();              //13 - room3
    public static int input(String[] args) throws IOException {
        if(args.length<2)return 2;
        fn = args[0];

        String fce = args[1];
        if((fce.contains("1") && !fce.contains("10") && !fce.contains("11") && !fce.contains("12") && !fce.contains("13")) || fce.contains("square")){
            try {
                int arg;
                if(args.length>1) arg = Integer.parseInt(args[2]);
                else arg=100;
                generateSquare(arg);
                return 0;
            }
            catch (NumberFormatException | IOException e){System.out.println("Wrong argument");return 2;}
        }
        else if(fce.contains("2") && !fce.contains("12") || fce.contains("circle")){
            try {
                int arg;
                if(args.length>1) arg = Integer.parseInt(args[2]);
                else arg=100;
                generateCircle(arg);
                return 0;
            }
            catch (NumberFormatException | IOException e){System.out.println("Wrong argument");return 2;}
        }
        else if(fce.contains("3") && !fce.contains("13") || fce.contains("c") || fce.contains("C")){
            try {
                int arg;
                if(args.length>1) arg = Integer.parseInt(args[2]);
                else arg=100;
                generateC(arg);
                return 0;
            }
            catch (NumberFormatException | IOException e){System.out.println("Wrong argument");return 2;}
        }
        else if(fce.contains("4") || fce.contains("cube")){
            try {
                int arg;
                if(args.length>1) arg = Integer.parseInt(args[2]);
                else arg=100;
                generateCube(arg);
                return 0;
            }
            catch (NumberFormatException | IOException e){System.out.println("Wrong argument");return 2;}
        }
        else if(fce.contains("5") || fce.contains("sphere")){
            try {
                int arg;
                if(args.length>1) arg = Integer.parseInt(args[2]);
                else arg=100;
                generateSphere(arg);
                return 0;
            }
            catch (NumberFormatException | IOException e){System.out.println("Wrong argument");return 2;}
        }
        else if(fce.contains("6") || fce.contains("cilinder")){
            try {
                int arg, arg2;
                if(args.length>2) {
                    arg = Integer.parseInt(args[2]);
                    arg2 = Integer.parseInt(args[3]);
                }
                else {arg=100;arg2=50;}

                generateCilinder(arg, arg2);
                return 0;
            }
            catch (NumberFormatException | IOException e){System.out.println("Wrong argument");return 2;}
        }
        else if(fce.contains("7") || fce.contains("pyramid")){
            try {
                int arg;
                if(args.length>1) arg = Integer.parseInt(args[2]);
                else arg=100;
                generatePyramid(arg);
                return 0;
            }
            catch (NumberFormatException | IOException e){System.out.println("Wrong argument");return 2;}
        }
        else if(fce.contains("8") || fce.contains("cone")){
            try {
                int arg;
                if(args.length>1)arg = Integer.parseInt(args[2]);
                else arg = 100;
                generateCone(arg);
                return 0;
            }
            catch (NumberFormatException | IOException e){System.out.println("Wrong argument");return 2;}
        }
        else if(fce.contains("9") || fce.contains("step1")){
            try {
                int arg;
                if(args.length>1)arg = Integer.parseInt(args[2]);
                else arg = 100;
                generateStep1(arg);
                return 0;
            }
            catch (NumberFormatException | IOException e){System.out.println("Wrong argument");return 2;}
        }
        else if(fce.contains("10") || fce.contains("step2")){
            try {
                int arg;
                if(args.length>1)arg = Integer.parseInt(args[2]);
                else arg = 90;
                generateStep2(arg);
                return 0;
            }
            catch (NumberFormatException | IOException e){System.out.println("Wrong argument");return 2;}
        }
        else if(fce.contains("11") || fce.contains("room1")){generateRoom1();return 0;}
        else if(fce.contains("12") || fce.contains("room2")){generateRoom2();return 0;}
        else if(fce.contains("13") || fce.contains("room3")){generateRoom3();return 0;}
        else System.out.println("Wrong argument");return 2;
    }


}
