Reálná data nejsou součástí odevzdané práce z důvodu copyrightu.

Příklady spuštění:


python main.py umela_data\custom1.txt
python main.py umela_data\custom1.txt 1000
python main.py umela_data\custom1.txt 1000 False
python main.py umela_data\custom3.txt 1500
python main.py umela_data\custom4.txt 1000



Po změně konfigurace v config.py

pozn. Při práci s převisy a jejich povolením v konfiguraci je silně doporučeno zpracovávat pouze část dat s převisem jako 1 buňku, dokud nebude program upravený pro práci s támto typem dat


Změna: OVERHANGS_PROCESSED = True
Příkaz: python main.py umela_data\Z_hole.txt 1

Změna:	OVERHANG_SPLIT_TOP = 0.75
		OVERHANGS_PROCESSED = True
Příkaz: python main.py umela_data\2_hole.txt 1