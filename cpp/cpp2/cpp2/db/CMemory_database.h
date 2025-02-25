//
// Created by jakub on 29.01.2022.
//

#ifndef CPP2_CMEMORY_DATABASE_H
#define CPP2_CMEMORY_DATABASE_H

#include "DatabaseHandler.h"
#include <sstream>
#include <functional>
enum class db_operation
{
    Equals,
    Greater_Than,
    Less_Than
};

class CMemory_databse{
public:

    DatabaseHandler h;
    explicit CMemory_databse() {
        h = DatabaseHandler();
    }

    //sablony pro predelani inputu na stringy prip vectory stringu
    template<typename T>std::string makeString(const T& t){
        std::stringstream ss;
        ss<<t;
        return ss.str();
    }
    template<typename P1, typename... P>std::vector<std::string> to_string(P1& p1, P& ...p){
        std::vector<std::string> s;
        s.push_back(makeString(p1));
        const auto v = to_string(p...);
        s.insert(s.end(),v.begin(),v.end());
        return s;
    }
    static std::vector<std::string> to_string(){return {};}


    //variadicka sablona pro insert
    template <typename KeyT, typename... ValsT>
    int Insert(const KeyT& key, const ValsT& ... vals) {
        std::vector<std::string> vector;
        std::string k = makeString(key);
        const auto v = to_string(vals...);
        vector.insert(vector.end(), v.begin(), v.end());
        return h.insert(k, vector);
    }

    //variadicka sablona pro delete
    template <typename KeyT, typename... ValsT>
    int Delete(const KeyT& key, const ValsT& ... vals)
    {
        std::vector<std::string> vector;
        std::string k = makeString(key);
        vector.push_back(k);
        const auto v = to_string(vals...);
        vector.insert(vector.end(), v.begin(),v.end());
        return h.deleter(vector);
    }

    std::vector<std::shared_ptr<dbMember>> Search_Key(std::variant<int, double, std::string,pair> key, db_operation op);

    // functor_type bude funktor/funkce/lambda, ktera splnuje koncept (vraci bool, zda vysledek vyhovuje nebo ne)
    static bool string_Equals(const std::string& s1, const std::string& s2);

    //funkce vyhledava zadanou hodnotu v databazi a vraci seznam klicu pod kterymi tato hodnota byla nalezena
    //tato fce vyuziva predikatu s porovnavanim stringu pro nalezeni techto hodnot
    //z duvodu implementace tohoto predikatu fce nevola jiz implementovanou fci, ktera je normalne volana behem standartniho spusteni davkoveho nebo interaktivniho systemu
    std::vector<std::shared_ptr<dbMember>> Find_Value(const std::function<bool(std::string, std::string)>& predicate, const std::string& find);

    //zavolani fce vrati prumer vsech ciselnych hodnot v databazi (vcetne tech v parech)
    double Average(std::variant<int, double, std::string,pair> key);
};


#endif //CPP2_CMEMORY_DATABASE_H
