//
// Created by jakub on 15.01.2022.
//

#include "DatabaseHandler.h"
#include <string>
#include <utility>
#include <variant>
#include <fstream>
#include <regex>
#include <algorithm>
#include <tuple>


std::tuple<std::variant<int,double,std::string>, std::variant<int,double,std::string>> par(pair p){
    return std::make_tuple(p.st,p.nd);
}


//pridani prvku do databaze
int DatabaseHandler::insert(std::string key, const std::vector<std::string>& values) {
    //zjisteni hodnot parametru a jejich typu
    std::vector<memberType> types={};
    std::vector<std::variant<int, double, std::string, pair>> vals={};
    for(auto & value : values){
        int typ=0;
        vals.push_back(getValue(value, typ));
        if(typ==0){
            types.push_back(memberType::STRING);
        }
        else if(typ==1){
            types.push_back(memberType::INT);
        }
        else if(typ==2){
            types.push_back(memberType::DOUBLE);
        }
        else if(typ==3){
            types.push_back(memberType::PAIR);
        }
    }
    //zjisteni hodnoty klice a jeho typu
    int keyT=0;
    memberType kt={};
    std::variant<int, double, std::string, pair> keyVal = getValue(std::move(key), keyT);
    if(keyT == 2)kt=memberType(memberType::DOUBLE);
    else if(keyT == 3)kt=memberType(memberType::PAIR);
    else if(keyT == 1)kt=memberType(memberType::INT);
    else kt=memberType(memberType::STRING);
    //volani variadicke sablony pro vytvoreni noveho zaznamu a ulozeni do databaze
    dbContent.push_back(CreateMember(kt, keyVal, types, vals));
    return 0;
}

//odebrani prvku z databaze
int DatabaseHandler::deleter(std::vector<std::string> params) {
    //najit klic kde se ma odebirat
    int keyIndex=findKey(params[0]);
    bool foundErr=false;
    int counter = 0;
    //pokud se jej podarilo najit
    if(keyIndex>=0){
        //pokud chci odebrat cely zaznam
        if(params.size()==1){
            //odebrat cely zaznam
            dbContent.erase(std::next(dbContent.begin(),keyIndex));
        }
        //jinak budu odebirat jen cast
        else{
            //odebrat jen nektere zaznamy
            int type=0;
            bool found=false;
            std::variant<int,double,std::string,pair>val={};
            std::variant<int,double,std::string,pair>db={};
            for(int i = 0; i < dbContent[keyIndex].values.size(); i++){
                db = dbContent[keyIndex].values[i];
                found = false;
                for(int j = 1; j < params.size(); j++){
                    val = getValue(params[j],type);
                    if(val==db){
                        //odeberu prvek
                        dbContent[keyIndex].values.erase(std::next(dbContent[keyIndex].values.begin(),i));
                        //a jeho typ ve vektoru typu
                        dbContent[keyIndex].valuesTypes.erase(std::next(dbContent[keyIndex].valuesTypes.begin(),i));
                        //nemuzu break, protoze by mohl obsahovat vice stejnych hodnot a ja chci odebrat vsechny
                        counter++;
                        found=true;
                    }
                }
                if(!found)foundErr=true;
                if(found)i--;
            }
            if(found)deleter(params);//nevim jak jinak nez si to mazat pod rukama... takze aby mi neutekly nejake zaznamy udelam opakovani
            if(dbContent[keyIndex].values.empty()){
                //odebrat cely zaznam - je uz prazdny
                dbContent.erase(std::next(dbContent.begin(),keyIndex));
            }
        }
    }
    else{
        //chyba - neni takovy klic - nelze odebrat
        return 2;
    }
    if(foundErr && counter<params.size()-1)return 1;//nektere zaznamy se nepodarilo najit
    return 0;
}

//vyhledani zaznamu podle klice
std::shared_ptr<dbMember> DatabaseHandler::key_equals(std::string keyName) {
    //nacteni klice a jeho typu
    int typ=0;
    std::variant<int, double, std::string, pair>key = getValue(std::move(keyName),typ);
    std::shared_ptr<dbMember> ret={};
    bool found=false;
    for(auto & i : dbContent){
        //porovnani dotazovaneho klice se zaznamy v db
        if(i.key==key){
            ret=std::make_shared<dbMember>(i);
            found=true;
            break;
        }
    }
    //pokud se nepodarilo najit zaznam, vraci se nullptr, jinak se vraci ukazatel na zaznam
    if(!found)return nullptr;
    return ret;
}

//vyhledani zaznamu s klici, ktere maji vetsi hodnotu nez je zadana
std::vector<std::shared_ptr<dbMember>> DatabaseHandler::key_greater(std::string keyName) {
    //nacteni klice a jeho typu
    int typ=0;
    std::variant<int, double, std::string, pair>key = getValue(std::move(keyName),typ);
    double keyVal=-DBL_MAX;
    if(typ==1)keyVal = std::get<int>(key);
    else if(typ==2)keyVal = std::get<double>(key);
    else if(typ==3){
        //pokud mam klic par a mam ho porovnavat na velikost, kouknu na hodnoty v paru a pokud je nektera cislo zvolim tu, pokud obe zvolim vetsi
        bool found = false;
        pair p = std::get<pair>(key);
        //kontrola a pripadne ulozeni prvniho prvku
        if(p.first==memberType::INT){
            found=true;
            keyVal=std::get<int>(p.st);
        }
        else if(p.first==memberType::DOUBLE){
            found=true;
            keyVal=std::get<double>(p.st);
        }
        //kontrola a pripadne prepsani druhym prvkem
        if(p.second==memberType::INT && std::get<int>(p.nd)>keyVal){
            found=true;
            keyVal = std::get<int>(p.nd);
        }
        else if(p.second==memberType::DOUBLE && std::get<double>(p.nd)>keyVal){
            found=true;
            keyVal = std::get<double>(p.nd);
        }
        //pokud se jedna o dva stringy, je to jako bych mel klic string - musim vratit prazdny vysledek
        if(!found)return std::vector<std::shared_ptr<dbMember>>{};
    }
    //byl zadan string nebo se nekde vyskytla chyba
    else return std::vector<std::shared_ptr<dbMember>>{};

    std::vector<std::shared_ptr<dbMember>> ret={};
    bool found = false;
    //zkouska hodnoty klice a pripadne pridani ukazatele do seznamu
    for(auto & i : dbContent){
        if(i.keyType==memberType::INT){
            if(std::get<int>(i.key) > keyVal){
                ret.push_back(std::make_shared<dbMember>(i));
                found=true;
            }
        }
        else if(i.keyType==memberType::DOUBLE){
            if(std::get<double>(i.key) > keyVal){
                ret.push_back(std::make_shared<dbMember>(i));
                found=true;
            }
        }
        else if(i.keyType==memberType::PAIR){
            if(std::get<pair>(i.key) > keyVal){
                ret.push_back(std::make_shared<dbMember>(i));
                found=true;
            }
        }
    }

    //pokud se neporadilo nic najit je vracen prazdny vector, jinak je vracen vektos s ukazateli na vysledky
    if(!found)return std::vector<std::shared_ptr<dbMember>>{};
    return ret;
}

//vyhledani zaznamu s klici, ktere maji vetsi hodnotu nez je zadana
std::vector<std::shared_ptr<dbMember>> DatabaseHandler::key_less(std::string keyName) {
    //nacteni klice a jeho typu
    int typ=0;
    std::variant<int, double, std::string, pair>key = getValue(std::move(keyName),typ);
    double keyVal=-DBL_MAX;
    if(typ==1)keyVal = std::get<int>(key);
    else if(typ==2)keyVal = std::get<double>(key);
    else if(typ==3){
        //pokud mam klic par a mam ho porovnavat na velikost, kouknu na hodnoty v paru a pokud je nektera cislo zvolim tu, pokud obe zvolim vetsi
        bool found = false;
        pair p = std::get<pair>(key);
        //kontrola a pripadne ulozeni prvniho prvku
        if(p.first==memberType::INT){
            found=true;
            keyVal=std::get<int>(p.st);
        }
        else if(p.first==memberType::DOUBLE){
            found=true;
            keyVal=std::get<double>(p.st);
        }
        //kontrola a pripadne prepsani druhym prvkem
        if(p.second==memberType::INT && std::get<int>(p.nd)<keyVal){
            found=true;
            keyVal = std::get<int>(p.nd);
        }
        else if(p.second==memberType::DOUBLE && std::get<double>(p.nd)<keyVal){
            found=true;
            keyVal = std::get<double>(p.nd);
        }
        //pokud se jedna o dva stringy, je to jako bych mel klic string - musim vratit prazdny vysledek
        if(!found)return std::vector<std::shared_ptr<dbMember>>{};
    }
        //byl zadan string nebo se nekde vyskytla chyba
    else return std::vector<std::shared_ptr<dbMember>>{};

    std::vector<std::shared_ptr<dbMember>> ret={};
    bool found = false;
    //zkouska hodnoty klice a pripadne pridani ukazatele do seznamu
    for(auto & i : dbContent){
        if(i.keyType==memberType::INT){
            if(std::get<int>(i.key) < keyVal){
                ret.push_back(std::make_shared<dbMember>(i));
                found=true;
            }
        }
        else if(i.keyType==memberType::DOUBLE){
            if(std::get<double>(i.key) < keyVal){
                ret.push_back(std::make_shared<dbMember>(i));
                found=true;
            }
        }
        else if(i.keyType==memberType::PAIR){
            if(std::get<pair>(i.key) < keyVal){
                ret.push_back(std::make_shared<dbMember>(i));
                found=true;
            }
        }
    }

    //pokud se neporadilo nic najit je vracen prazdny vector, jinak je vracen vektos s ukazateli na vysledky
    if(!found)return std::vector<std::shared_ptr<dbMember>>{};
    return ret;
}


//fce pro vyhledavani vsech prvku v databazi se snahou najit zadanou hodnotu a vratit, jake zaznamy tuto hodnotu obsahuji
std::vector<std::shared_ptr<dbMember>> DatabaseHandler::find_value(std::string value) {
    //precteni klice a jeho typu
    int typ=0;
    memberType typParu={};
    std::variant<int, double, std::string, pair>input = getValue(std::move(value),typ);
    std::vector<std::shared_ptr<dbMember>> res={};
    std::variant<int, double, std::string, pair> val={};
    //pruchod databaze pres zaznamy
    for(auto & i : dbContent){
        //pruchod pres prvky v zaznamu
        for(int  j = 0; j < i.values.size(); j++){
            val = i.values[j];
            typParu = i.valuesTypes[j];
            //pokud jsem nasel hledany prvek, ulozim si ukazatel na zaznam
            if(input==val) {
                res.push_back(std::make_shared<dbMember>(i));
            }
            //kontrola vnitrku paru
            if(typParu==memberType::PAIR){
                pair p = std::get<pair>(val);
                auto dvojice = par(p);
                //prvni clen
                if(p.first==memberType::INT && typ==1){//hledany i prvni z paru jsou int
                    if(std::get<int>(input)==std::get<int>(std::get<0>(dvojice))){res.push_back(std::make_shared<dbMember>(i));continue;}
                }
                else if(p.first==memberType::DOUBLE && typ==2){//hledany i prvni z paru jsou double
                    if(std::get<double>(input)==std::get<double>(std::get<0>(dvojice))){res.push_back(std::make_shared<dbMember>(i));continue;}
                }
                else if(p.first==memberType::STRING && typ==0){//hledany i prvni z paru jsou int
                    if(std::get<std::string>(input)==std::get<std::string>(std::get<0>(dvojice))){res.push_back(std::make_shared<dbMember>(i));continue;}
                }
                //druhy clen
                if(p.second==memberType::INT && typ==1){//hledany i prvni z paru jsou int
                    if(std::get<int>(input)==std::get<int>(std::get<1>(dvojice)))res.push_back(std::make_shared<dbMember>(i));
                }
                else if(p.second==memberType::DOUBLE && typ==2){//hledany i prvni z paru jsou double
                    if(std::get<double>(input)==std::get<double>(std::get<1>(dvojice)))res.push_back(std::make_shared<dbMember>(i));
                }
                else if(p.second==memberType::STRING && typ==0){//hledany i prvni z paru jsou int
                    if(std::get<std::string>(input)==std::get<std::string>(std::get<1>(dvojice)))res.push_back(std::make_shared<dbMember>(i));
                }
            }
        }
    }

    return res;
}

//fce ktera vraci prumernou hodnotu vsech ciselnych prvku v zaznamu, nebo vsech zaznamech
double DatabaseHandler::average(const std::string& param) {
    int counter=0;
    double sum=0;
    //pokud se jedna o pruchod jednoho zaznamu
    if(!param.empty()){
        int typ=0;
        std::variant<int, double, std::string, pair>input = getValue(param,typ);
        //pouze pro jeden zaznam
        for(auto & i : dbContent) {
            if(i.key==input){
                //nasel se hledany zaznam
                for (int j = 0; j < i.values.size(); j++) {
                    //pokud je to string, tak ho preskocim, jinak prictu hodnotu do sumy
                    if(i.valuesTypes[j]!=memberType::STRING){
                        counter++;
                        if(i.valuesTypes[j]==memberType::INT) sum+=std::get<int>(i.values[j]);
                        else if(i.valuesTypes[j]==memberType::DOUBLE) sum+=std::get<double>(i.values[j]);
                        else{//pair
                            pair p = std::get<pair>(i.values[j]);
                            double a=0,b=0;
                            if(p.first==memberType::INT)a = std::get<int>(p.st);
                            else if(p.first==memberType::DOUBLE)a = std::get<double>(p.st);
                            if(p.second==memberType::INT)b = std::get<int>(p.nd);
                            else if(p.second==memberType::DOUBLE)b = std::get<double>(p.nd);
                            //2 stringy nijak neprispivaji k prumeru - nemely by ho ovlivnit
                            if(p.first==memberType::STRING && p.second==memberType::STRING)counter--;
                            else if(p.first==memberType::STRING)sum+=b;
                            else if(p.second==memberType::STRING)sum+=a;
                            //pokud jsou obe cisla, prictu jejich prumer - tim zaridim aby nemel par se dvema hodnotama vahu 2 pri pocitaci prumeru
                            else sum+=(a+b)/2;
                        }
                    }
                }
                break;
            }
            else return -DBL_MAX;
        }
        return sum/counter;
    }
    //pro vsechny zaznamy
    //pres vsechny zaznamy
    for(auto & i : dbContent){
        //pres vsechny prvky v kazdym zaznamu
        for(int  j = 0; j < i.values.size(); j++) {
            //pokud se jedna o string, tak preskocim, jinak prictu hodnotu do sumy
            if(i.valuesTypes[j]!=memberType::STRING){
                counter++;
                if(i.valuesTypes[j]==memberType::INT) sum+=std::get<int>(i.values[j]);
                else if(i.valuesTypes[j]==memberType::DOUBLE) sum+=std::get<double>(i.values[j]);
                else{//pair
                    pair p = std::get<pair>(i.values[j]);
                    double a=0,b=0;
                    if(p.first==memberType::INT)a = std::get<int>(p.st);
                    else if(p.first==memberType::DOUBLE)a = std::get<double>(p.st);
                    if(p.second==memberType::INT)b = std::get<int>(p.nd);
                    else if(p.second==memberType::DOUBLE)b = std::get<double>(p.nd);
                    //2 stringy nijak neprispivaji k prumeru - nemely by ho ovlivnit
                    if(p.first==memberType::STRING && p.second==memberType::STRING)counter--;
                    else if(p.first==memberType::STRING)sum+=b;
                    else if(p.second==memberType::STRING)sum+=a;
                        //pokud jsou obe cisla, prictu jejich prumer - tim zaridim aby nemel par se dvema hodnotama vahu 2 pri pocitaci prumeru
                    else sum+=(a+b)/2;
                }
            }
        }
    }
    return sum/counter;
}



//fce pro pruchod vsech prvku v zaznamu/vsech zaznamech a vraceni nejvyssi hodnoty
double DatabaseHandler::maximum(const std::string& keyName) {
    double tmp,currentMax=-DBL_MAX;//minimal double value
    //pokud chci jen jeden zaznam
    if(!keyName.empty()){
        //nacteni klice
        int typ=0;
        std::variant<int, double, std::string, pair>input = getValue(keyName,typ);
        //pouze pro jeden zaznam
        for(auto & i : dbContent) {
            if(i.key==input){
                //nasel se hledany input
                for (int j = 0; j < i.values.size(); j++) {
                    //striny preskakuju
                    if(i.valuesTypes[j]!=memberType::STRING){
                        //pokud se jedna o int
                        if(i.valuesTypes[j]==memberType::INT){
                            tmp = std::get<int>(i.values[j]);
                            if(currentMax<tmp){
                                currentMax=tmp;
                            }
                        }
                        else if(i.valuesTypes[j]==memberType::DOUBLE){
                            //pokud se jedna o double
                            tmp = std::get<double>(i.values[j]);
                            if(currentMax<tmp){
                                currentMax=tmp;
                            }
                        }
                        else{//pair
                            pair p = std::get<pair>(i.values[j]);
                            if(p>currentMax){
                                //currentMax=p;
                                if(p.first==memberType::INT)currentMax=std::get<int>(p.st);
                                else if(p.first==memberType::DOUBLE)currentMax=std::get<double>(p.st);
                                if(p.second==memberType::INT && std::get<int>(p.nd)>currentMax)currentMax=std::get<int>(p.nd);
                                else if(p.second==memberType::DOUBLE && std::get<double>(p.nd)>currentMax)currentMax=std::get<double>(p.nd);
                            }
                        }
                    }
                }
                break;
            }
        }
        return currentMax;
    }
    //pro vsechny zaznamy
    for(auto & i : dbContent){
        for(int  j = 0; j < i.values.size(); j++) {
            //vsechny zaznamy a jejich vsechny hodnoty - pokud se jedna o string, tak preskocim
            if(i.valuesTypes[j]!=memberType::STRING){
                //kontroly intu
                if(i.valuesTypes[j]==memberType::INT){
                    tmp = std::get<int>(i.values[j]);
                    if(currentMax<tmp){
                        currentMax=tmp;
                    }
                }
                else if(i.valuesTypes[j]==memberType::DOUBLE){
                    //kontroly doublu
                    tmp = std::get<double>(i.values[j]);
                    if(currentMax<tmp){
                        currentMax=tmp;
                    }
                }
                else{//pair
                    pair p = std::get<pair>(i.values[j]);
                    if(p>currentMax){
                        //currentMax=p;
                        if(p.first==memberType::INT)currentMax=std::get<int>(p.st);
                        else if(p.first==memberType::DOUBLE)currentMax=std::get<double>(p.st);
                        if(p.second==memberType::INT && std::get<int>(p.nd)>currentMax)currentMax=std::get<int>(p.nd);
                        else if(p.second==memberType::DOUBLE && std::get<double>(p.nd)>currentMax)currentMax=std::get<double>(p.nd);
                    }
                }
            }
        }
    }
    return currentMax;
}

//fce je velice podobna fci maximum
double DatabaseHandler::minimum(const std::string& keyName) {
    double tmp=0, currentMin=DBL_MAX;//maximal double value
    if(!keyName.empty()){
        int typ=0;
        std::variant<int, double, std::string, pair>input = getValue(keyName,typ);
        //pouze pro jeden zaznam
        for(auto & i : dbContent) {
            if(i.key==input){
                //nasel se hledany input
                for (int j = 0; j < i.values.size(); j++) {
                    if(i.valuesTypes[j]!=memberType::STRING){
                        if(i.valuesTypes[j]==memberType::INT){
                            tmp = std::get<int>(i.values[j]);
                            if(currentMin>tmp){
                                currentMin=tmp;
                            }
                        }
                        else if(i.valuesTypes[j]==memberType::DOUBLE){
                            tmp = std::get<double>(i.values[j]);
                            if(currentMin>tmp){
                                currentMin=tmp;
                            }
                        }
                        else{//pair
                            pair p = std::get<pair>(i.values[j]);
                            if(p<currentMin){
                                //currentMax=p;
                                if(p.first==memberType::INT)currentMin=std::get<int>(p.st);
                                else if(p.first==memberType::DOUBLE)currentMin=std::get<double>(p.st);
                                if(p.second==memberType::INT && std::get<int>(p.nd)<currentMin)currentMin=std::get<int>(p.nd);
                                else if(p.second==memberType::DOUBLE && std::get<double>(p.nd)<currentMin)currentMin=std::get<double>(p.nd);
                            }
                        }
                    }
                }
                break;
            }
        }
        return currentMin;
    }
    //pro vsechny zaznamy
    for(auto & i : dbContent){
        for(int  j = 0; j < i.values.size(); j++) {
            if(i.valuesTypes[j]!=memberType::STRING){
                if(i.valuesTypes[j]==memberType::INT){
                    tmp = std::get<int>(i.values[j]);
                    if(currentMin>tmp){
                        currentMin=tmp;
                    }
                }
                else if(i.valuesTypes[j]==memberType::DOUBLE){
                    tmp = std::get<double>(i.values[j]);
                    if(currentMin>tmp){
                        currentMin=tmp;
                    }
                }
                else{//pair
                    pair p = std::get<pair>(i.values[j]);
                    if(p<currentMin){
                        //currentMax=p;
                        if(p.first==memberType::INT)currentMin=std::get<int>(p.st);
                        else if(p.first==memberType::DOUBLE)currentMin=std::get<double>(p.st);
                        if(p.second==memberType::INT && std::get<int>(p.nd)<currentMin)currentMin=std::get<int>(p.nd);
                        else if(p.second==memberType::DOUBLE && std::get<double>(p.nd)<currentMin)currentMin=std::get<double>(p.nd);
                    }
                }
            }
        }
    }
    return currentMin;
}

//metoda prevadejici string na prislusny datovy typ (int double, nebo string)
//typ je ukazatel na hodnotu, ktera bude informovat o tom co je vraceno (jaky typ)
//typ = 0 pro string, typ = 1 pro int a typ = 2 pro double
std::variant<int, double, std::string, pair> DatabaseHandler::getValue(std::string in, int& typ, bool par) {
    bool isInt=false, isString=true;
    //je to sice trochu chude, ale jedna se o vyjimku... ostatni veci jsou osetrene jinak a umele tam cpat vyjimky mi prijde hloupe
    try{
        double newVal = std::stod(in);
        int tryInt = newVal; //tady je schvalne oriznuti
        if(abs(newVal-tryInt) < 0.0001)isInt = true;
        isString=false;
    }
    catch(...){
        isString = true;
    }
    if(isString){
        if(in[0]=='[' && in[in.size()-1]==']'){
            //pair
            std::string a="",b="";
            int pos = in.find(':');
            if(pos==in.size()-1 || par){
                typ=0;
                return in;
            }
            a=in.substr(1,pos-1);
            b=in.substr(pos+1,in.size()-pos-1-1);
            //vytvoreni noveho paru
            typ=3;
            struct pair par1={};
            int t1=0,t2=0;
            std::variant<int,double,std::string>v1={},v2={};
            std::variant<int,double,std::string,pair>a1={},a2={};
            //ziskani variant a zmenseni o pair (zakazani rekurze)
            a1=getValue(a,t1,true);
            a2=getValue(b,t2,true);
            v1=makeVariant(a1,t1);
            v2=makeVariant(a2,t2);
            par1.st=v1;
            par1.nd=v2;
            //prirazeni typu
            if(t1==1)par1.first=memberType::INT;
            else if(t1==2)par1.first=memberType::DOUBLE;
            else par1.first=memberType::STRING;

            if(t2==1)par1.second=memberType::INT;
            else if(t2==2)par1.second=memberType::DOUBLE;
            else par1.second=memberType::STRING;

            return par1;
        }
        typ=0;
        return in;
    }
    else if(isInt){
        typ=1;
        return std::stoi(in);
    }
    else{
        typ=2;
        return std::stod(in);
    }
}

//fce pro hledani klice pomoci jeho nazvu - vraci index do databaze
int DatabaseHandler::findKey(const std::string& searchKey){
    int foundMember=0;
    bool found = false;
    int keyT=0;
    std::variant<int, double, std::string, pair>findKey = getValue(searchKey,keyT);
    //v databazi hledam zaznam
    for(int i = 0; i < dbContent.size(); i++){
        if(findKey==dbContent[i].key){
            foundMember=i;
            found=true;
            break;
        }
    }
    if(!found){
        //nastala chyba - takovy klic neni v db
        return -1;
    }
    return foundMember;
}

//pro spusteni programu s input souborem s prikazy a s vystupem do output souboru
void DatabaseHandler::startFileVariant(std::string input, const std::string& output) {
    //precist soubor input provest akce (osetreni dale) a zapsat vysledek do souboru output
    auto in = [inFile = std::move(input)]()->std::vector<std::string>{
        /**
         * Lambda která načítá data ze souboru do vektoru se kterým se dále pracuje
         * */
        //založení streamu
        std::fstream in (inFile);
        std::string inputTmp="";
        std::vector<std::string> input={};
        //přečtení první položky
        std::getline(in, inputTmp);
        input.push_back(inputTmp);
        //přečtení dalších položek
        while(!in.eof()){
            std::getline(in, inputTmp);
            input.push_back(inputTmp);
        }
        //přečtení poslední položky z bufferu
        in.close();
        return input;
    };

    std::string out;
    for(int i = 0; i < in().size(); i++){
        out.append("> ");
        out.append(in()[i]);
        out.append("\n");
        out.append(callMethod(in()[i]));
        out.append("\n");
    }
    //zapis vysledku do output souboru
    std::ofstream outFile (output);
    outFile.write(out.c_str(), out.length());
    outFile.close();
}

//fce pro spusteni programu s konzoli - vstupni prikazy i vystup jsou smerovane na konzoli
void DatabaseHandler::startConsoleVariant() {
    //zacit while loop a vysledky postupne vypisovat na konzoli
    std::cout<<"Welcome in KIV/CPP semestral work - memory database.\nPlease, enter your query."<<std::endl;
    std::string in="",out="";
    while(true){
        //ukonceni programu pomoci exit
        std::getline(std::cin,in);
        if(in=="exit" || in=="EXIT"){
            std::cout<<"The program will now shut down and the data will be lost."<<std::endl;
            break;
        }
        //zavolani metody a vypsani vysledku
        std::cout<<callMethod(in)<<std::endl;
    }
}

//Fce zpraovavajici uzivatelsky vsup a volajici prislusne metody
//vraci vysledek pripadne chybove hlaseni
std::string DatabaseHandler::callMethod(std::string input) {
    std::string result="";
    std::string method="";
    std::vector<std::string> params={};
    size_t pos={};
    //nacteni metody
    pos = input.find('(');
    if(pos != std::string::npos)method = input.substr(0, pos);
    else{
        //error - zadany string neobsahuje zavorku
        //jelikoz to nenajde metodu s klicovym slovem, bude error vypsan jakoze to nenaslo metodu
        //pokud to bude klicove slovo, prikaz se pouze nevykona, ale nenahlasi to chybu...
        return "";
    }
    input.erase(0, pos + 1);
    //parsovani parametru
    while ((pos = input.find(", ")) != std::string::npos) {
        params.push_back(input.substr(0, pos));
        input.erase(0, pos + 2);
    }
    params.push_back(input.substr(0, input.size()-1));

    //v params jsou rozparsovane parametry
    //regexp
    std::regex r {"[A-Z_]+",std::regex::icase};
    std::regex r2 {R"([A-Z0-9.!?:\/*+\-")(-_[]*)",std::regex::icase};
    if(std::regex_match(method,r)){
        //metoda neobsahuje osklive znaky - otestovat params
        for(auto & param : params){
            if(!std::regex_match(param,r2)){
                return "Parametres contains restricted characters. Use only letters and numbers please: "+param+"\n";
            }
        }
        //zavolat metodu s parametry
        //INSERT
        if((method=="insert" || method=="INSERT") && params.size()>1){
            std::string key = params[0];
            params.erase(params.begin());
            int res = insert(key,params);
            if(res==0){
                result.append("OK\n");
                result.append("1 rows.\n");
            }
        }
        //DELETE
        else if((method=="delete" || method=="DELETE") && !params.empty()){
            int res = deleter(params);
            if(res==0){
                result.append("OK\n");
                result.append("1 rows.\n");
            }
            else if(res==1){
                result.append("ERROR\n");
                result.append("Some of searched values were not found. Those found were deleted.\n");
            }
            else if(res==2){
                result.append("ERROR\n");
                result.append("Key not found.\n");
            }
        }
        //KEY_EQUALS
        else if((method=="key_equals" || method=="KEY_EQUALS") && params.size()==1){
            std::shared_ptr<dbMember> res = key_equals(params[0]);
            std::string key="";
            if(res!= nullptr){
                result.append("OK\n");
                result.append("1 rows.\n");
                if(res->keyType==memberType::STRING)key = std::get<std::string>(res->key);
                else if(res->keyType==memberType::INT)key = std::to_string(std::get<int>(res->key));
                else if(res->keyType==memberType::DOUBLE)key = std::to_string(std::get<double>(res->key));
                else if(res->keyType==memberType::PAIR)key = std::get<pair>(res->key).toString();
                result.append(key);
                result.append(" - ");
                for(int i = 0; i < res->values.size(); i++){
                    if(res->valuesTypes[i]==memberType::STRING)key = std::get<std::string>(res->values[i]);
                    else if(res->valuesTypes[i]==memberType::INT)key = std::to_string(std::get<int>(res->values[i]));
                    else if(res->valuesTypes[i]==memberType::DOUBLE)key = std::to_string(std::get<double>(res->values[i]));
                    else if(res->valuesTypes[i]==memberType::PAIR)key = std::get<pair>(res->values[i]).toString();

                    result.append(key);
                    if(i!=res->values.size()-1)result.append(", ");
                }
                result.append("\n");
            }
            else{
                result.append("ERROR\n");
                result.append("Key not found.\n");
            }
        }

        //KEY_LESS & KEY_GREATER
        else if((method=="key_less" || method=="KEY_LESS" || method=="key_greater" || method == "KEY_GREATER") && params.size()==1){
            std::vector<std::shared_ptr<dbMember>> res={};
            if(method=="key_less" || method=="KEY_LESS"){
                res = key_less(params[0]);
            }
            else{
                res = key_greater(params[0]);
            }
            std::string key="";
            result.append("OK\n");
            result.append(std::to_string(res.size()));
            result.append(" rows.\n");
            result.append(readRows(res));
        }
        //FIND_VALUE
        else if((method=="find_value" || method=="FIND_VALUE") && params.size()==1){
            std::vector<std::shared_ptr<dbMember>> res = find_value(params[0]);
            std::string key="";
            result.append("OK\n");
            result.append(std::to_string(res.size()));
            result.append(" rows.\n");
            result.append(readRows(res));
        }
        //AVERAGE
        else if((method=="average" || method=="AVERAGE") && params.size()<2){
            std::string par="";
            int rows=dbContent.size();
            if(!params.empty()){
                par=params[0];
                rows=1;
            }
            double res = average(par);

            result.append("OK\n");
            result.append(std::to_string(rows));
            result.append(" rows.\nAVERAGE() - ");
            if(res==-DBL_MAX)result.append("Key not found");
            else result.append(std::to_string(res));
            result.append("\n");
        }
        //MAX & MIN
        else if((method=="max" || method=="MAX" || method=="min" || method == "MIN") && params.size()<2){
            std::string par="";
            int rows=dbContent.size();
            if(!params.empty()){
                par=params[0];
                rows=1;
            }
            double res=0;
            if(method=="MAX" || method=="max"){
                res = maximum(par);
            }
            else{
                res = minimum(par);
            }
            //je potrea zkontrolovat, zda jsme dospeli k nejakemu vysledku, nebo ne
            if(res==-DBL_MAX || res==DBL_MAX){
                result.append("ERROR\n");
                result.append("This key name was not found or there were no values to count with.\n");
            }
            else{
                result.append("OK\n");
                result.append(std::to_string(rows));
                if(method=="MAX" || method=="max")result.append(" rows.\nMAX() - ");
                else result.append(" rows.\nMIN() - ");
                result.append(std::to_string(res));
            }
            result.append("\n");
        }
        //ERROR - pokud bylo na vstupu neco co se nepodarilo rozpoznat
        else{
            //chyba - neznama metoda nebo spatne parametry
            result.append("ERROR\nThe method you called does not exist or parameters were incorrect. Try again.\n");
        }
    }
    else return "ERROR\nMethod you called contains restricted characters, use just letters and \"_\".\n";

    return result;
}

//fce pro zpracovani seznamu prvku do nekolikaradkoveho stringu pripraveneho pro vypis
std::string DatabaseHandler::readRows(std::vector<std::shared_ptr<dbMember>> res) {
    //vyuziti a otestovani algoritmu pro serazeni -
    std::ranges::sort(res);
    std::string key="", result="";
    for(auto & re : res){
        //pridani klice do vypisu
        if(re->keyType==memberType::STRING)key = std::get<std::string>(re->key);
        else if(re->keyType==memberType::INT)key = std::to_string(std::get<int>(re->key));
        else if(re->keyType==memberType::DOUBLE)key = std::to_string(std::get<double>(re->key));
        else if(re->keyType==memberType::PAIR)key = std::get<pair>(re->key).toString();
        result.append(key);
        result.append(" - ");
        for(int j = 0; j < re->values.size(); j++){
            //pridani prvku do vypisu
            if(re->valuesTypes[j] == memberType::STRING)key = std::get<std::string>(re->values[j]);
            else if(re->valuesTypes[j] == memberType::INT)key = std::to_string(std::get<int>(re->values[j]));
            else if(re->valuesTypes[j] == memberType::DOUBLE)key = std::to_string(std::get<double>(re->values[j]));
            else if(re->valuesTypes[j] == memberType::PAIR)key = std::get<pair>(re->values[j]).toString();
            result.append(key);
            if(j != re->values.size() - 1)result.append(", ");
        }
        result.append("\n");
    }

    return result;
}

std::variant<int, double, std::string> DatabaseHandler::makeVariant(std::variant<int, double, std::string, pair> in, int typ) {
    std::variant<int, double, std::string>ret={};
    if(typ==0) ret = std::get<std::string>(in);
    else if(typ==1) ret = std::get<int>(in);
    else if(typ==2) ret = std::get<double>(in);
    else return std::get<pair>(in).toString();
    return ret;
}


std::string dbMember::toString() {
    std::string result="", s="";
    if(this->keyType==memberType::STRING)s = std::get<std::string>(this->key);
    else if(this->keyType==memberType::INT)s = std::to_string(std::get<int>(this->key));
    else if(this->keyType==memberType::DOUBLE)s = std::to_string(std::get<double>(this->key));
    else if(this->keyType==memberType::PAIR)s = std::get<pair>(this->key).toString();
    result.append(s);
    result.append(" - ");
    for(int i = 0; i < this->values.size(); i++){
        if(this->valuesTypes[i]==memberType::STRING)s = std::get<std::string>(this->values[i]);
        else if(this->valuesTypes[i]==memberType::INT)s = std::to_string(std::get<int>(this->values[i]));
        else if(this->valuesTypes[i]==memberType::DOUBLE)s = std::to_string(std::get<double>(this->values[i]));
        else if(this->valuesTypes[i]==memberType::PAIR)s = std::get<pair>(this->values[i]).toString();

        result.append(s);
        if(i!=this->values.size()-1)result.append(", ");
    }
    return result;
}
