//
// Created by jakub on 27.09.2021.
//

#include "object.h"
#include <memory>
#include <utility>
#include <iostream>

/**
 * Konstruktor obecného objektu, který přiřazuje hodnoty proměnným podle inicializace
 * */
object::object(std::string name, float startX, float startY, float speedX, float speedY, int appear, int disappear, float spec1, float spec2){
    this->name = std::move(name);
    this->startX = startX;
    this->startY = startY;
    this->speedX = speedX;
    this->speedY = speedY;
    this->appear = appear;
    this->disappear = disappear;
    this->spec1 = spec1;
    this->spec2 = spec2;
    this->currX = startX;
    this->currY = startY;
}
/**
 * Getry a setry jednotlivých parametrů objektu pro práci mimo třídu
 * */
const std::string &object::getName() const {
    return name;
}

float object::getStartX() const {
    return startX;
}

float object::getStartY() const {
    return startY;
}

float object::getSpeedX() const {
    return speedX;
}

float object::getSpeedY() const {
    return speedY;
}

int object::getAppear() const {
    return appear;
}

int object::getDisappear() const {
    return disappear;
}

float object::getSpec1() const {
    return spec1;
}

float object::getSpec2() const {
    return spec2;
}

float object::getCurrX() const {
    return currX;
}

void object::setCurrX(float crX) {
    object::currX = crX;
}

float object::getCurrY() const {
    return currY;
}

void object::setCurrY(float crY) {
    object::currY = crY;
}

/**
 * Konstruktor kruhu nastavující zbývající proměnné
 * */
Circle::Circle(std::string name, float startX, float startY, float speedX, float speedY, int appear, int disappear, float perimetr, float spec2) : object(std::move(name), startX, startY, speedX, speedY, appear, disappear, spec1, spec2) {
    spec1 = perimetr;
    currX = startX;
    currY = startY;
}
/**
 * Metoda pro zjištění zda jsou dvě instance typu kruh v kolizi
 * k tomu využívá přetíženého operátoru (další metoda)
 * */
bool Circle::check(std::shared_ptr<object> b){
    return *this+b;
}
bool Circle::operator+(std::shared_ptr<object> a) {
    float xDiff = (currX - a->getCurrX())*(currX - a->getCurrX());
    float yDiff = (currY - a->getCurrY())*(currY - a->getCurrY());
    float diff = sqrt(xDiff+yDiff);
    if(diff>(spec1+a->getSpec1()))return false;
    else return true;
}
/**
 * Metoda vykonávající přesun prvku tím, že změní jeho aktuální pozici
 * */
bool Circle::move(float x, float y){
    currX+=x;
    currY+=y;
    return true;
}
/**
 * Metoda vypisující základní informace o kruhu jako například jeho jméno, poloha, vektor pohybu,...
 * */
std::string Circle::toString(){
    std::string res="Crc: ";
    res+=name;
    res+="[";
    res+=std::to_string(currX);
    res+=",";
    res+=std::to_string(currY);
    res+="]->[";
    res+=std::to_string(speedX);
    res+=",";
    res+=std::to_string(speedY);
    res+="] appear: ";
    res+=std::to_string(appear);
    res+="| disappear: ";
    res+=std::to_string(disappear);
    res+="| spec (";
    res+=std::to_string(spec1);
    res+=")\n";
    return res;
}
/**
 * Metoda zajišťující změnu pohybu kruhu při odrazu od stěny arény
 * */
void Circle::bounce(bool x){
    if(x){
        speedX=0-speedX;
    }
    else speedY=0-speedY;

}


/**
 * Konstruktor obdelníku (nebo čtverce), který nastavuje některé z parametrů obdelníku
 * */

Rect::Rect(std::string name, float startX, float startY, float speedX, float speedY, int appear, int disappear,
           float a, float b) : object(std::move(name), startX, startY, speedX, speedY, appear, disappear, spec1, spec2) {
    currX = startX;
    currY = startY;
    spec1=a;
    spec2=b;
}
/**
 * Metoda pro zjištění zda jsou dvě instance typu obdelník nebo čtverec v kolizi
 * k tomu využívá přetíženého operátoru (další metoda)
 * */
bool Rect::check(std::shared_ptr<object> b){
    return *this+b;
}
bool Rect::operator+(std::shared_ptr<object> a) {
    float xDiff = abs(currX - a->getCurrX());
    float yDiff = abs(currY - a->getCurrY());
    float distX = spec1/2 + a->getSpec1()/2;
    float distY = spec2/2 + a->getSpec2()/2;
    if(xDiff>distX || yDiff>distY)return false;
    return true;
}
/**
 * Metoda vykonávající přesun prvku tím, že změní jeho aktuální pozici
 * */
bool Rect::move(float x, float y){
    currX+=x;
    currY+=y;
    return true;
}
/**
 * Metoda vypisující základní informace o kruhu jako například jeho jméno, poloha, vektor pohybu,...
 * */
std::string Rect::toString(){
    std::string res="Rec: ";
    res+=name;
    res+="[";
    res+=std::to_string(currX);
    res+=",";
    res+=std::to_string(currY);
    res+="]->[";
    res+=std::to_string(speedX);
    res+=",";
    res+=std::to_string(speedY);
    res+="] appear: ";
    res+=std::to_string(appear);
    res+="| disappear: ";
    res+=std::to_string(disappear);
    res+="| spec (";
    res+=std::to_string(spec1);
    res+=",";
    res+=std::to_string(spec2);
    res+=")\n";
    return res;
}
/**
 * Metoda zajišťující změnu pohybu kruhu při odrazu od stěny arény
 * */
void Rect::bounce(bool x){
    if(x){
        speedX=0-speedX;
    }
    else speedY=0-speedY;
}


