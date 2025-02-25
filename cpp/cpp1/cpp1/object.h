//
// Created by jakub on 27.09.2021.
//

#ifndef CPP1_OBJECT_H
#define CPP1_OBJECT_H

#include <string>
#include <vector>
#include <memory>

/**
 * Virtuální třída pro práci a udržování informací o prvku simulace
 * Od této třídy dědí různé druhy instance podle tvaru (kruh a obdelnik)
 * Třída poskytuje virtuální metody pro manipulaci s instancí a getry a setry potřebných hodnot instance
 * Tyto hodnoty jsou protected aby byla usnadněna manipulace potomkům
 * Objekt má jméno, startovní pozici, rychlost a směr pohybu, čas objevení a zmezení a speciální parametr, který se mění v závislosti na tvaru objektu
 * */
class object {
public:
    object(std::string name, float startX, float startY, float speedX, float speedY, int appear, int disappear, float spec1, float spec2);
    virtual bool check(std::shared_ptr<object> b)=0;
    virtual bool move(float x, float y)=0;
    virtual void bounce(bool x)=0;
    virtual std::string toString()=0;
    const std::string &getName() const;
    float getStartX() const;
    float getStartY() const;
    float getSpeedX() const;
    float getSpeedY() const;
    int getAppear() const;
    int getDisappear() const;
    float getSpec1() const;
    float getSpec2() const;
    float getCurrX() const;
    void setCurrX(float currX);
    float getCurrY() const;
    void setCurrY(float currY);

private:
    virtual bool operator +(std::shared_ptr<object> a)=0;

protected:
    std::string name;
    float startX;
    float startY;
    float speedX;
    float speedY;
    int appear;
    int disappear;
    float spec1;
    float spec2;
    float currX;
    float currY;

};

/**
 * Třída reprezentující kruh - dědí od objektu (tedy implementuje jeho virtuální metody)
 * */
class Circle: public virtual object{
public:
    explicit Circle(std::string name, float startX, float startY, float speedX, float speedY, int appear, int disappear, float spec1, float spec2 = 0);
    bool check(std::shared_ptr<object> b) override;
    bool move(float x, float y) override;
    std::string toString() override;
    void bounce(bool x) override;
private:
    bool operator +(std::shared_ptr<object> a) override;
};
/**
 * Třída reprezentující obdelník - dědí od objektu (tedy implementuje jeho virtuální metody)
 * Čtverec je reprezentován jako obdelník se stejnou výškou a šířkou
 * */
class Rect: public virtual object{
public:
    explicit Rect(std::string name, float startX, float startY, float speedX, float speedY, int appear, int disappear, float spec1, float spec2);
    bool check(std::shared_ptr<object> b) override;
    bool move(float x, float y) override;
    std::string toString() override;
    void bounce(bool x) override;
private:
    bool operator +(std::shared_ptr<object> a) override;
};

#endif //CPP1_OBJECT_H
