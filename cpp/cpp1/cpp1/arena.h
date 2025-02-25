//
// Created by jakub on 29.12.2021.
//

#include <memory>
#include <vector>
#include "object.h"

#ifndef CPP1_ARENA_H
#define CPP1_ARENA_H

#endif //CPP1_ARENA_H

/**
 * Třída reprezentující arénu, neboli místo a konání simulace
 * Obsahuje konstruktor a metodu ke spuštění simulace
 * Privátně má schované metody potřebné k simulaci a parametry arény
 * */
class Arena{
public:
    bool successfullyCreated = true;
    /**
     * Konstruktor arény přijímající potřebné parametry definované v zadání
     * */
    Arena(int width, int height, int step_size, int step_count, std::string params, std::string argv2);
    /**
     * Hlavní metoda programu zahajující a provádějící simulaci
     * Výstupem je výsledný řetězec jakožto zpráva o průběhu simulace
     * */
    std::string initiateSimulation(std::vector<std::shared_ptr<object>> objects, int* res);

private:
    int ARENA_WIDTH;
    int ARENA_HEIGHT;
    int STEP_SIZE;
    int STEP_COUNT;
    bool END_AFTER_COLLISION;
    bool REPORT_DISTANCE;
    int output;
    std::string outputFile;
    std::string out;
    int numberOfStepsSimulated = 0;
    int collisionCounter = 0;

    /**
     * Metoda, která zjišťuje zda došlo ke kolizím a kolize zaznamenává do výsledné zprávy, případně ukončuje simulace (záleží na nastavení)
     * */
    bool checkCollisions(std::vector<std::shared_ptr<object>> objects, std::vector<std::string> *results, int i);

    /**
     * Metoda která se snaží podchytit logické chyby ve vstupním souboru, aby se zamezilo nesmyslným výsledkům a nedeterminismu v rámci simulace
     * */
    bool checkForLogicalErrors(const std::vector<std::shared_ptr<object>>& objects) const;
    /**
     * Metoda pro zvýšení počítadla kroků simulace
     * */
    [[maybe_unused]] void StepsIncrement();
    /**
     * Metoda pro vygenerování hlášení o chybě vzniklé při inicializace simulace metodou "checkForLogicalErrors(objects)"
     * */
    void generateLogicalErrorReport(const std::string &err, int errCode) const;
};

