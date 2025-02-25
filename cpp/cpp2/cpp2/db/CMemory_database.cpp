//
// Created by jakub on 29.01.2022.
//

#include "CMemory_database.h"

std::vector<std::shared_ptr<dbMember>> CMemory_databse::Search_Key(std::variant<int, double, std::string, pair> key, db_operation op){
    std::string k = "";
    if(key.index()==0)k=std::to_string(std::get<int>(key));
    else if(key.index()==1)k=std::to_string(std::get<double>(key));
    else if(key.index()==2)k=std::get<std::string>(key);
    else k=std::get<pair>(key).toString();

    if(op==db_operation::Equals){
        return {h.key_equals(k)};
    }
    else if(op==db_operation::Greater_Than){
        return h.key_greater(k);
    }
    else if(op==db_operation::Less_Than){
        return h.key_less(k);
    }
    else return {};
}


std::vector<std::shared_ptr<dbMember>> CMemory_databse::Find_Value(const std::function<bool(std::string, std::string)>& predicate, const std::string& find){
    std::vector<std::shared_ptr<dbMember>> result={};
    std::string s="";
    for(auto & i : h.dbContent){
        for(int j = 0; j < i.values.size(); j++){
            if(i.valuesTypes[j]==memberType::STRING)s = std::get<std::string>(i.values[j]);
            else if(i.valuesTypes[j]==memberType::INT)s = std::to_string(std::get<int>(i.values[j]));
            else if(i.valuesTypes[j]==memberType::DOUBLE)s = std::to_string(std::get<double>(i.values[j]));
            else if(i.valuesTypes[j]==memberType::PAIR)s = std::get<pair>(i.values[j]).toString();

            if(predicate(find, s)){
                result.push_back(std::make_shared<dbMember>(i));
                break;
            }

        }
    }

    return result;
}

bool CMemory_databse::string_Equals(const std::string& s1, const std::string& s2){
    return s1==s2;
}

double CMemory_databse::Average(std::variant<int, double, std::string,pair> key){
    std::string k;
    if(key.index()==0)k=std::to_string(std::get<int>(key));
    else if(key.index()==1)k=std::to_string(std::get<double>(key));
    else if(key.index()==2)k=std::get<std::string>(key);
    else k=std::get<pair>(key).toString();
    return h.average(k);
}