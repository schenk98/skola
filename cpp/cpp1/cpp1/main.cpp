#include <iostream>
#include <fstream>
#include <vector>
#include <string>
#include "arena.h"

int output = 0;
std::string outputFile;
std::string inputFile;
int objectNumber;
[[maybe_unused]] bool rect, square;
int lineCounter;
/**
 * Metoda která načítá data ze souboru do vektoru se kterým se dále pracuje
 * */
std::vector<std::string> readInputFile(const std::string& inFile);
/**
 * Metoda, která čte vstupní vektor (s daty ze souboru) a podle nich vytváří objekty, které pak slouží jako prvky v simulaci
 * */
std::vector<std::shared_ptr<object>> readObjects(std::vector<std::string> in, bool *res, int step, int offset);
/**
 * Metoda vytvářející výstup programu
 * Při pádu programu z důvodu chyby vygeneruje chybové hlášení a je vráceno na požadovaný výstup
 * Pokud program úspěšně proběhne a simulace je úspěšně dokončena, je sem předána zpráva ke zpracování a zápis na výstup
 * */
void generateReport(const std::string& report, int codeNumber);
/**
 * Spouštějící třída programu
 * Zde jsou přečteny parametry spuštění
 * Zavoláno čtení souboru
 * Vyhodnoceno s jakými tvary proběhne simulace
 * Ošetřen vstup (zda sedí formát vstupního souboru)
 * Vytvořena aréna a spuštěna simulace
 * A nakonec spuštění metody pro generování výsledků na požadovaný výstup a ukončení programu
 * */
int main(int argc, char ** argv){
    //kontrola poctu vstupnich parametru
    if(argc==3){
        //nastaveni inputu a outputu
        inputFile=argv[1];
        if(strcmp(argv[2],"cout")==0) output=1;
        else if(strcmp(argv[2], "null")==0)  output=0;
        else {
            output = 2;
            outputFile = argv[2];
        }
    }
    else{std::cout<<"wrong_number_of_arguments"<<std::endl; generateReport("wrong_number_of_arguments", 2); return 2; }
    lineCounter = 0;

    //precteni souboru do vectoru po slozkach
    std::vector<std::string> input = readInputFile(inputFile);
    bool res = true;

    //kontrola a vytvoreni areny
    if(input[0]!="ARENA"){ std::cout<<"invalid_format"<<std::endl; generateReport("invalid_format", 1); return 1;}

    rect = false;
    square = false;
    if(input[7]=="rectangle" || input[7]=="RECTANGLE"){
        rect = true;
    }
    else if(input[7]=="ball" || input[7]=="square" || input[7]=="BALL" || input[7]=="SQUARE"){
        rect=false;
        if(input[7]=="square" || input[7]=="SQUARE")square = true;
        else square = false;
    }

    //vytvoření arény pomocí lambda funkce
    auto arena = [input, argv2=argv[2]]()->Arena{
        int w,h,s1,s2;
        try{
            w = std::stoi(input[1]);
            h = std::stoi(input[2]);
            s1 = std::stoi(input[3]);
            s2 = std::stoi(input[4]);
        }
        catch(...){std::cout<<"invalid_format"<<std::endl; generateReport("invalid_format", 1); return Arena(0,0,0,0,"",argv2);}
        return Arena(w,h,s1,s2, input[5], argv2);
    };

    //pri vytvareni areny doslo k potizim s formatem
    if(!arena().successfullyCreated){std::cout<<"invalid_format"<<std::endl; generateReport("invalid_format", 1); return 1;}

    //načtení objektů
    try{
        objectNumber = std::stoi(input[8]);
    }
    catch(...){ std::cout<<"invalid_format"<<std::endl; generateReport("invalid_format", 1); return 1;}

    if(input[6]!="OBJECTS"){std::cout<<"invalid_format"<<std::endl; generateReport("invalid_format", 1); return 1;}


    int iterStep = 8;
    if(rect)iterStep = 9;
    //kontrola poctu parametru pro nacteni vsech objektu
    if((objectNumber*iterStep+9)<lineCounter){
        std::cout<<"invalid_format"<<std::endl; generateReport("invalid_format", 1); return 1;}
    res = true;

    //samotne precteni vsech objektu do jednoho vectoru
    std::vector<std::shared_ptr<object>> objects = readObjects(input, &res, iterStep, 9);
    if(!res){std::cout<<"invalid_format"<<std::endl; generateReport("invalid_format", 1); return 1;}


    // ------------------------------------ vse je precteno -> presun k simulaci ---------------------------------------
    int ires = 0;
    auto simulationResults = arena().initiateSimulation(objects, &ires);

    for(char simulationResult : simulationResults)std::cout<<simulationResult;

    //Zvývá výsledky sumarizovat do výstupního souboru/konzole
    switch(ires){
        case 0: {std::cout<<"simulation_success"<<std::endl; generateReport(simulationResults, 0); return 0;}
        case 1: {std::cout<<"invalid_format"<<std::endl; generateReport("invalid_format", 1); return 1;}
        case 2: {std::cout<<"wrong_number_of_arguments"<<std::endl; generateReport("wrong_number_of_arguments", 2); return 2;}
        case 3: {std::cout<<"logic_error"<<std::endl; generateReport("logic_error", 3); return 3;}
        default: {std::cout<<"unknown_error"<<std::endl; generateReport("unknown_error", 3); return 5;}
    }
}
/**
 * Metoda vytvářející výstup programu
 * Při pádu programu z důvodu chyby vygeneruje chybové hlášení a je vráceno na požadovaný výstup
 * Pokud program úspěšně proběhne a simulace je úspěšně dokončena, je sem předána zpráva ke zpracování a zápis na výstup
 * */
void generateReport(const std::string& report, int codeNumber) {
    if(output==0)return;
    std::string stringReport;
    if(codeNumber!=0){
        stringReport += "REPORT\nERROR\n";
        stringReport += report;
        switch(codeNumber){
            case 1: stringReport+="\nInput data contains error, there are not enough or there are too much arguments, or key words are spelled wrongly (check if there is right lower and upper case characters).\n";
            case 2: stringReport+="\nProgram was started with not enough arguments. There has to be path to input file and specifier of output.\n";
            case 3: stringReport+="\nThere was logical error in input data, doublecheck them if there are none objects outside arena etc.\n";
            case 4: stringReport+="\nidentifier fail placeholder\n";

            default: stringReport+="\nThere was unidentified failiure in the process. (Or rather programmer screwed up report.)\n";
        }
    }
    else{
        stringReport += "REPORT\nOK\n";
        stringReport += report;
    }

    if(output==1){
        //vypis na konzoli
        std::cout<<stringReport<<std::endl;
    }
    else{
        //vypis do souboru
        std::ofstream out (outputFile);
        out.write(stringReport.c_str(), stringReport.length());
        out.close();
    }

}
/**
 * Metoda která načítá data ze souboru do vektoru se kterým se dále pracuje
 * */
std::vector<std::string> readInputFile(const std::string& inFile) {
    //založení streamu
    std::fstream in (inFile);
    std::string inputTmp;
    std::vector<std::string> input;
    //přečtení první položky
    in>>inputTmp;
    input.push_back(inputTmp);
    //přečtení dalších položek
    while(!in.eof()){
        lineCounter++;
        in >> inputTmp;
        input.push_back(inputTmp);
    }
    lineCounter++;
    //přečtení poslední položky z bufferu
    in >> inputTmp;
    input.push_back(inputTmp);
    in.close();
    return input;
}

/**
 * Metoda, která čte vstupní vektor (s daty ze souboru) a podle nich vytváří objekty, které pak slouží jako prvky v simulaci
 * */
std::vector<std::shared_ptr<object>> readObjects(std::vector<std::string> in, bool *res, int step, int offset) {
    std::vector<std::shared_ptr<object>> objects;
    int shape;
    /*try{
        objectNumber = stoi(in[8]);
    }
    catch(...){ std::cout<<"invalid_format"<<std::endl; generateReport("invalid_format", 1); *res = false; return output; }
*/
    //rozhodnutí o tvaru objektu
    if(in[7]=="ball")shape = 1;
    else if(in[7]=="rectangle")shape = 2;
    else shape = 3;

    //načtení objektu do pameti jako odkazu na instance příslušných tříd
    for(int i = 0; i < objectNumber; i++){
        try{
            if(shape == 1){//načtení kruhů
                Circle c1 (in[i * step + offset], stof(in[i * step + offset + 1]),
                           stof(in[i * step + offset + 2]), stof(in[i * step + offset + 3]),
                           stof(in[i * step + offset + 4]), stoi(in[i * step + offset + 5]),
                           stoi(in[i * step + offset + 6]), stof(in[i * step + offset + 7]));
                std::shared_ptr<object> c = std::make_shared<Circle>(c1);
                objects.push_back(c);
            }
            else if(shape == 2){//načtení obdelníků
                Rect r1 (in[i * step + offset], stof(in[i * step + offset + 1]),
                         stof(in[i*step+offset+2]), stof(in[i*step+offset+3]),
                         stof(in[i*step+offset+4]), stoi(in[i*step+offset+5]),
                         stoi(in[i*step+offset+6]), stof(in[i*step+offset+7]),
                         stof(in[i*step+offset+8]));
                std::shared_ptr<object> r = std::make_shared<Rect>(r1);
                objects.push_back(r);
            }
            else{//načtení čtverců
                Rect r2 (in[i * step + offset], stof(in[i * step + offset + 1]),
                        stof(in[i*step+offset+2]), stof(in[i*step+offset+3]),
                        stof(in[i*step+offset+4]), stoi(in[i*step+offset+5]),
                        stoi(in[i*step+offset+6]), stof(in[i*step+offset+7]),
                        stof(in[i*step+offset+7]));
                std::shared_ptr<object> r = std::make_shared<Rect>(r2);
                objects.push_back(r);
            }
        }
        catch(...){ std::cout<<"invalid_format"<<std::endl; generateReport("invalid_format", 1); *res = false; return objects;}
    }
    *res = true;

    return objects;
}