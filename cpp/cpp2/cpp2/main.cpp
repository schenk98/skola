#include <iostream>
#include <variant>
#include <string>
#include "db/DatabaseHandler.h"
#include "db/CMemory_database.h"


int main(int argc, char ** argv) {

    CMemory_databse db = CMemory_databse();
    /**
     * Náseduje ukázka práce v programátorském prostředí
     * */
    if(db.Insert("klic1", "avnrdno", "ajaouvjbj", "30.1", "2022", "[jedna:dva]")==0)
        std::cout<<"OK"<<std::endl;
    if(db.Insert(10, 1, 2, 3)==0)
        std::cout<<"OK"<<std::endl;
    if(db.Insert(11, 1.1, 1.2, 1.3, 3)==0)
        std::cout<<"OK"<<std::endl;
    if(db.Insert(12.1, "abc", "def", 4, 4.20)==0)
        std::cout<<"OK"<<std::endl;
    if(db.Insert("trinact", "[4:5]", "[4.5:ahoj]", "[abc:16]")==0)
        std::cout<<"OK"<<std::endl;
    if(db.Delete(10,2)==0)
        std::cout<<"delete some - OK"<<std::endl;
    else
        std::cout<<"key or some values were not found"<<std::endl;
    if(db.Delete(10)==0)
        std::cout<<"delete all - OK"<<std::endl;
    auto r = db.Search_Key(11,db_operation::Equals);
    std::cout<<std::endl;
    for(auto & i : r)std::cout<<i->toString()<<std::endl;

    r=db.Search_Key(12.01,db_operation::Less_Than);
    std::cout<<std::endl;
    for(auto & i : r)std::cout<<i->toString()<<std::endl;

    r=db.Search_Key(10,db_operation::Greater_Than);
    std::cout<<std::endl;
    for(auto & i : r)std::cout<<i->toString()<<std::endl;

    r=db.Search_Key("trinact", db_operation::Equals);
    std::cout<<std::endl;
    for(auto & i : r)std::cout<<i->toString()<<std::endl;

    r=db.Find_Value(db.string_Equals,"3");
    std::cout<<std::endl;
    for(auto & i : r)std::cout<<i->toString()<<std::endl;

    std::cout<<std::endl;
    std::cout<<db.Average("")<<std::endl;

    /**
     * Nasleduje spusteni programu interaktivnim resp. davkovym zpusobem (zalezi na vstupnich argumentech)
     * */

    //kontrola poctu vstupnich parametru
    if(argc==3){
        //nastaveni inputu a outputu
        std::string inputFile=argv[1];
        std::string outputFile = argv[2];
        db.h.startFileVariant(inputFile,outputFile);
        return 0;
    }
    else if(argc==1){
        //spusteno bez parametru - interaktivni rezim s konzoli
        db.h.startConsoleVariant();
        return 0;
    }
    else{std::cout<<"wrong_number_of_arguments"<<std::endl; return 2; }
}
