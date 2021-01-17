# 334CC Filimon Adrian
# Tema Flex Limbaje formale si aautomate

Pentru rezolvarea temei am folosit FLEX si Limbajul C. Partea de parsare am
facut-o integral in FLEX.

## Rulare tema: 
    - `make run1` - rulează tema pe testul input1.in -- fisierul dat in PDF
    - `make run2` - rulează tema pe testul input2.in
    - `make run3` - rulează tema pe testul input3.in

## Detalii de implementare

Pentru rezolvarea temei am folosit 4 stari:
- func_name
- func_params 
- func_content
- local_vars

1. func_name
-  este folosita pentru identificarea numelui de functiilor

2. func_params 
- este folosita pentru a extrage parametrii primiti de functie
- foloseste regula `function_parameters` pentru a extrage tot ce este intre paranteze

3. func_content
- aceasta stare este folosita pentru a parsa ceea ce se afla in functie, in cazul nostru variabilele locale
- se poate ajunge in mai multe cazuri in aceasta functie:
    - daca este un comentariu, se va intra pe regula de `comment` in aceeasi stare si se va ignora comentariul
    - daca este tip de date primar(int, float, double, char), se va intra pe regula de `data_type`
    - daca este un apel de functie(printf sau sum) sau instructiune( while, for), se va trece peste ea. Se foloseste regula de `function_name` urmata de paranteze
    - daca se face match pe regula `end_function` inseamna ca functia s-a terminat si se pot afisa datele despre functie
        - datele sunt tinute intr-o structura `function`. Se tin datele despre nume, tip, argumente si variabilele locale. Ultimele sunt tinute intr-o structura de tip `variables`, ce contine detalii despre nume si tip.

4. local_vars
    - daca este un comentariu, se va intra pe regula de `comment` si se va reintra in stare
    - daca este regula de `variable_name`, se va retine numele si tipul variabilei in structura si se va incerca gasirea urmatorului nume de variabila
    - daca se va intra pe regula de sfarsit de intructiune (;), se trece la urmatorul tip de date(daca mai exista)
