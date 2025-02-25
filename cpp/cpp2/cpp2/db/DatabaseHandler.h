//
// Created by jakub on 15.01.2022.
//

#ifndef CPP2_DATABASEHANDLER_H
#define CPP2_DATABASEHANDLER_H


#include <iostream>
#include <utility>
#include <vector>
#include <variant>
#include <string>
#include <tuple>


enum class memberType{
    INT, DOUBLE, STRING, PAIR
};

struct pair{
    memberType first;
    memberType second;
    std::variant<int,double,std::string> st;
    std::variant<int,double,std::string> nd;
    bool operator==(const pair b) const{
        bool ret = true;
        //porovnani first
        if(this->first == memberType::INT && b.first==memberType::INT){
            if(std::get<int>(this->st)!=std::get<int>(b.st))ret=false;
        }
        else if(this->first == memberType::DOUBLE && b.first==memberType::DOUBLE){
            if(std::get<double>(this->st)-std::get<double>(b.st)>0.0001)ret=false;
        }
        else if(this->first == memberType::STRING && b.first==memberType::STRING){
            if(std::get<std::string>(this->st)!=std::get<std::string>(b.st))ret=false;
        }
        else ret = false;
        //to same pro second
        if(this->second == memberType::INT && b.second==memberType::INT){
            if(std::get<int>(this->nd)!=std::get<int>(b.nd))ret=false;
        }
        else if(this->second == memberType::DOUBLE && b.second==memberType::DOUBLE){
            if(std::get<double>(this->nd)-std::get<double>(b.nd)>0.0001)ret=false;
        }
        else if(this->second == memberType::STRING && b.second==memberType::STRING){
            if(std::get<std::string>(this->nd)!=std::get<std::string>(b.nd))ret=false;
        }
        else ret = false;
        return ret;
    }

    //vybere se vetsi hodnota z paru dvou ciselnych hodnot
    bool operator>(double b){
        //obe hodnoty jsou string, nelze porovnat
        if(this->first==this->second && this->first==memberType::STRING)return false;
        double keyVal=-DBL_MAX;
        if(this->first==memberType::INT){
            keyVal=std::get<int>(this->st);
        }
        else if(this->first==memberType::DOUBLE){
            keyVal=std::get<double>(this->st);
        }
        //kontrola a pripadne prepsani druhym prvkem
        if(this->second==memberType::INT && std::get<int>(this->nd)>keyVal){
            keyVal = std::get<int>(this->nd);
        }
        else if(this->second==memberType::DOUBLE && std::get<double>(this->nd)>keyVal){
            keyVal = std::get<double>(this->nd);
        }
        return keyVal>b;
    }

    //vybere se mensi hodnota z paru dvou ciselnych hodnot
    bool operator<(double b){
        //obe hodnoty jsou string, nelze porovnat
        if(this->first==this->second && this->first==memberType::STRING)return false;
        double keyVal=DBL_MAX;
        if(this->first==memberType::INT){
            keyVal=std::get<int>(this->st);
        }
        else if(this->first==memberType::DOUBLE){
            keyVal=std::get<double>(this->st);
        }
        //kontrola a pripadne prepsani druhym prvkem
        if(this->second==memberType::INT && std::get<int>(this->nd)<keyVal){
            keyVal = std::get<int>(this->nd);
        }
        else if(this->second==memberType::DOUBLE && std::get<double>(this->nd)<keyVal){
            keyVal = std::get<double>(this->nd);
        }
        return keyVal<b;
    }

    std::string toString(){
        std::string s = "[";
        if(this->first==memberType::INT)s.append(std::to_string(std::get<int>(this->st)));
        else if(this->first==memberType::DOUBLE)s.append(std::to_string(std::get<double>(this->st)));
        else s.append(std::get<std::string>(this->st));
        s.append(":");
        if(this->second==memberType::INT)s.append(std::to_string(std::get<int>(this->nd)));
        else if(this->second==memberType::DOUBLE)s.append(std::to_string(std::get<double>(this->nd)));
        else s.append(std::get<std::string>(this->nd));
        s.append("]");
        return s;
    }
};

/**
 * Struktura obsahujici potrebne info o prvcich ukladanych do databaze
 * */
struct dbMember{
    memberType keyType;
    std::variant<int, double, std::string, pair>key;
    std::vector<memberType> valuesTypes;
    std::vector<std::variant<int, double, std::string, pair>> values;
    std::string toString();

};

/**
 * sablona pro vytvoreni prvku, tyto prvky jsou pak udrzovany v databazi
 * s vyuzitim zakladnich principu konceptu (pomerne hloupe)
 * */

template<typename key>
concept IsKeyNotEmpty = !std::is_empty_v<key>;
template<typename keyType>
concept IsKeyTypeNotEmpty = !std::is_empty_v<keyType>;
template<typename types>
concept IsValuesTypesNotEmpty = !std::is_empty_v<types>;
template<typename vals>
concept IsValuesNotEmpty = !std::is_empty_v<vals>;

//enum, variant, vector<enum>, vector<variant>
template<typename keyType, typename key, typename types, typename vals>
requires IsKeyNotEmpty<key> && IsKeyTypeNotEmpty<types> && IsValuesNotEmpty<vals> && IsValuesTypesNotEmpty<types>
dbMember CreateMember(keyType&& kt, key&& k, types&& t, vals&& v){
    dbMember dm;
    dm.keyType=kt;
    dm.key=k;
    dm.valuesTypes=t;
    dm.values=v;
    return dm;
}



class DatabaseHandler {
public:
    /**
     * Vektor obsahujici vsechny prvky databaze
     * Jelikoz jsou prvky v podstate nemenne manipuluje se pouze s ukazateli
     * */
    std::vector<dbMember> dbContent;

    /**
     * Prazdny konstruktor potrebny pro volani metod tridy
     * */
    explicit DatabaseHandler()= default;


    /**
     * Nasleduji funkce ktere odpovidaji funkcim definovanych v zadani
     * */
    int insert(std::string key, const std::vector<std::string>&values);

    int deleter(std::vector<std::string> params);

    std::shared_ptr<dbMember> key_equals(std::string keyName);

    std::vector<std::shared_ptr<dbMember>> key_greater(std::string keyName);

    std::vector<std::shared_ptr<dbMember>> key_less(std::string keyName);

    std::vector<std::shared_ptr<dbMember>> find_value(std::string value);

    double average(const std::string& param);

    double maximum(const std::string& keyName);

    double minimum(const std::string& keyName);

    /**
     * Funkce ktere jsou spusteny podle toho jestli ma byt spusten interaktivni nebo davkovy beh
     * startFileVariant je urcen pro davkovy beh, kdy nacte prikazy ze souboru a vysledek zapise do jineho souboru
     * startConsoleVariant je urcen pro interaktivni beh, kdy jsou prikazy cteny z konzole a vysledky jsou tam postupne vypisovany
     * */
    void startFileVariant(std::string input, const std::string& output);

    void startConsoleVariant();

    /**
     * Fce ktera ma za ukol ziskat typ a variant stringu, ktery je ziskan ze vstupu
     * */
    static std::variant<int, double, std::string, pair> getValue(std::string in, int& typ, bool par = false);

private:
    /**
     * Fce ktera vraci index klice zadaneho nazvem
     * */
    int findKey(const std::string& findThis);

    /**
     * Rozsahla fce ktera podle vstupu zavola prislusnou fci a vrati pozadovany vysledek pripadne chybovou hlasku
     * */
    std::string callMethod(std::string input);

    /**
     * Podpurna fce pro "callMethod", ktera prijme vector zaznamu a vytvori z nich viceradkovy string vhodny pro vypis
     * */
    static std::string readRows(std::vector<std::shared_ptr<dbMember>> res);

    static std::variant<int, double, std::string> makeVariant(std::variant<int, double, std::string, pair> in, int typ);
};

/*
 template<typename keyT, typename ... valsT>
requires IsKeyNotEmpty<keyT> && IsValuesNotEmpty<valsT>
dbMember CreateMemberVariant(keyT&& k, valsT... v){
    dbMember dm;
    DatabaseHandler h;
    int type = 0;
    std::variant<int,double,std::string,pair> key={};
    //ziskani infa o klici
    key = h.getValue(k,type);
    std::vector<std::variant<int,double,std::string,pair>>vals={};
    std::vector<memberType> valTypes={};
    //info o vlaues
    for(int i = 0; i < v.)
    dm.keyType=kt;
    dm.key=k;
    dm.valuesTypes=t;
    dm.valus=v;
    return dm;
}
 * */

#endif //CPP2_DATABASEHANDLER_H
