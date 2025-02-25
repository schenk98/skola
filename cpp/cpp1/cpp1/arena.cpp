//
// Created by jakub on 29.12.2021.
//

#include <string>
#include <iostream>
#include <chrono>
#include <fstream>
#include <utility>
#include "arena.h"
/**
* Konstruktor arény přijímající potřebné parametry definované v zadání
* */
Arena::Arena(int width, int height, int step_size, int step_count, std::string params, std::string argv2) {
    if(width>0 || height>0)successfullyCreated=true;
    ARENA_WIDTH = width;
    ARENA_HEIGHT = height;
    STEP_SIZE = step_size;
    STEP_COUNT = step_count;
    END_AFTER_COLLISION = false;
    REPORT_DISTANCE = false;
    out = std::move(argv2);


    if(params[0] == 'e')END_AFTER_COLLISION = true;
    else if(params[0] == 'r')REPORT_DISTANCE = true;
    for(int i = 0; i < params.length(); i++){
        if(params[i]==',' && (params[i+1]=='e' || params[i+1]=='E'))END_AFTER_COLLISION = true;
        else if(params[i]==',' && (params[i+1]=='r' || params[i+1]=='R'))REPORT_DISTANCE = true;
    }

    if(out == "cout") output=1;
    else if(out == "null")  output=0;
    else {
        output = 2;
        outputFile = out;
    }
}
/**
 * Metoda pro zvýšení počítadla kroků simulace
 * */
[[maybe_unused]] void Arena::StepsIncrement(){
    numberOfStepsSimulated++;
}
/**
* Hlavní metoda programu zahajující a provádějící simulaci
* Výstupem je výsledný řetězec jakožto zpráva o průběhu simulace
* */
std::string Arena::initiateSimulation(std::vector<std::shared_ptr<object>> objects, int *res) {
    //check for logical errors
    bool ret = checkForLogicalErrors(objects);
    if(!ret){
        *res = 3;
        return "";
    }
    std::string result;
    auto start = std::chrono::high_resolution_clock::now();
    std::vector<std::string> collisionResults;
    std::vector<float> distanceResults;
    distanceResults.reserve(objects.size());
for(int i = 0; i < objects.size(); i++)distanceResults.push_back(0);
    bool reasonIters = true;
    for(int i = 0; i < this->STEP_COUNT; i++){
        //move
        float moveX, moveY;
        for(int j = 0; j < objects.size(); j++){
            if(objects[j]->getAppear()>i || objects[j]->getDisappear()<=i)continue;
            moveX = (float)this->STEP_SIZE*objects[j]->getSpeedX();
            moveY = (float)this->STEP_SIZE*objects[j]->getSpeedY();
            objects[j]->move(moveX, moveY);
            if(objects[j]->getCurrX()<0 || objects[j]->getCurrX()>(float)this->ARENA_WIDTH || objects[j]->getCurrY()<0 || objects[j]->getCurrY()>(float)this->ARENA_HEIGHT){
                //zmenit vektory pohybu objektu co narazily do sten (a ZMENIT JEJICH POZICI - JSOU MIMO ARENU)
                if(objects[j]->getCurrX()<0){
                    objects[j]->bounce(true);
                    objects[j]->setCurrX(-objects[j]->getCurrX());
                }
                else if(objects[j]->getCurrX()>(float)this->ARENA_WIDTH){
                    objects[j]->bounce(true);
                    objects[j]->setCurrX(objects[j]->getCurrX()-2*(objects[j]->getCurrX() - (float)this->ARENA_WIDTH));
                }
                if(objects[j]->getCurrY()<0){
                    objects[j]->bounce(false);
                    objects[j]->setCurrY(-objects[j]->getCurrY());
                }
                else if(objects[j]->getCurrY()>(float)this->ARENA_HEIGHT){
                    objects[j]->bounce(false);
                    objects[j]->setCurrY(objects[j]->getCurrY()-2*(objects[j]->getCurrY() - (float)this->ARENA_HEIGHT));
                }

            }

            //zapsat pohyb (pokud je zapisovan) (asi do jineho pole)
            if(this->REPORT_DISTANCE){
                distanceResults[j]+=sqrt((moveX*moveX + moveY*moveY));
            }
        }

        bool collision = checkCollisions(objects, &collisionResults, i);
        if(collision && this->END_AFTER_COLLISION){
            reasonIters = false;
            break;
        }
        numberOfStepsSimulated++;
    }

    result+=std::to_string(numberOfStepsSimulated);
    result+=" steps\n";
    auto end = std::chrono::high_resolution_clock::now();
    auto mseconds = duration_cast<std::chrono::milliseconds>(end - start).count();

    if(reasonIters)result+="Simulation ended after all iterations were successfully simulated.\n";
    else result+="Simulation ended after 1st collision, because it was meant to stop after 1st collision.\n";
    result += std::to_string(mseconds);
    result+=" ms\n";
    result+="COLLISIONS\n";
    for(auto & collisionResult : collisionResults){
        result += collisionResult;
        result += "\n";
    }

    if(this->REPORT_DISTANCE){
        result+="DISTANCES\n";
        for(int i = 0; i < objects.size(); i++){
            result += objects[i]->getName();
            result += " ";
            result += std::to_string(distanceResults[i]);
            result += "\n";
        }
    }

    return result;
}
/**
 * Metoda která se snaží podchytit logické chyby ve vstupním souboru, aby se zamezilo nesmyslným výsledkům a nedeterminismu v rámci simulace
 * */
bool Arena::checkForLogicalErrors(const std::vector<std::shared_ptr<object>>& objects) const {
    if(this->STEP_COUNT<1 || this->STEP_SIZE==0 || this->ARENA_HEIGHT<1 || this->ARENA_WIDTH<1){
        //arena has non logical value
        std::cout<<"logic_error"<<std::endl; generateLogicalErrorReport("logic_error", 3);return false;
    }
    for(auto & object : objects){
        if(object->getStartX()>(float)this->ARENA_WIDTH || object->getStartY()>(float)this->ARENA_HEIGHT || object->getStartX()<0 || object->getStartY()<0){
            //object starts outside the arena
            std::cout<<"logic_error"<<std::endl; generateLogicalErrorReport("logic_error", 3); return false;
        }
        else if(object->getAppear()<0 || object->getDisappear()<object->getAppear() || object->getSpec1()<0 || object->getSpec2()<0){
            //object has non logical value
            std::cout<<"logic_error"<<std::endl; generateLogicalErrorReport("logic_error", 3); return false;
        }
    }
    return true;
}
/**
* Metoda, která zjišťuje zda došlo ke kolizím a kolize zaznamenává do výsledné zprávy, případně ukončuje simulace (záleží na nastavení)
* */
bool Arena::checkCollisions(std::vector<std::shared_ptr<object>> objects, std::vector<std::string> *results, int iterace) {
    //check if there are objects intersecting with each other
    bool collision = false;

    for(int i = 0; i < objects.size(); i++){
        if(objects[i]->getAppear()>iterace || objects[i]->getDisappear()<=iterace)continue;
        for(int j = i+1; j < objects.size(); j++){
            if(objects[j]->getAppear()>iterace || objects[j]->getDisappear()<=iterace)continue;

            bool checkRet;
            checkRet = objects[i]->check(objects[j]);

            if(checkRet){
                std::string tmpRes;
                collision = true;
                collisionCounter++;
                tmpRes += std::to_string(collisionCounter);
                tmpRes += ") ";
                tmpRes += objects[i]->getName();
                tmpRes += " x ";
                tmpRes += objects[j]->getName();
                results->push_back(tmpRes);
            }
        }
    }
    return collision;
}
/**
* Metoda pro vygenerování hlášení o chybě vzniklé při inicializace simulace metodou "checkForLogicalErrors(objects)"
* */
void Arena::generateLogicalErrorReport(const std::string& report, int codeNumber) const {
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
        std::ofstream outStream (outputFile);
        outStream.write(stringReport.c_str(), stringReport.length());
        outStream.close();
    }

}

