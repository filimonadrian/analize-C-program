/* FILIMON ADRIAN, 334CC */
/* http://crasseux.com/books/ctutorial/Function-names.html */

%{
        #include <stdio.h>
        #include <string.h>
        #include <stdlib.h>

        typedef struct variables {
            char name[100];
            char type[10];
        } variables;

        typedef struct function {
            char function_name[100];
            char type[10]; 
            int nr_local_vars;
            variables vars[100];

        } function;

        function func[100];
        int functions_NO = 0;
        
%}

%{
int indentation = 0;
%}
letter [A-Za-z]
number [0-9]
inner_letter [A-Za-z0-9_-]
first_letter [A-Za-z_ ]
special_chars [^;<>="']

singleline_comment "//".* 
multiline_comment [/][*][^*]*[*]+([^*/][^*]*[*]+)*[/]

function_header (^[A-Za-z_ ][A-Za-z0-9_ "\n"]*\([^;><="]*\)[ ]*{)

start_ignore "<!"|"<?"
stop_ignore ">"
opening_tag "<"[ ]* 
closing_tag "</"[^<>]*">"|"/>"
between_tags ">"[^<]*"<"
    /* numele atributelor pot fi formate din litere si ":" */
atribut [A-Za-z:]
    /* valoare atribut */
value "\""[^<>\"]*"\""

%x IGNORE ELEM ATTRIBUTE SEMICOLON

%%
    /* ignorarea tagurilor care incep cu <! si <? */
<INITIAL>{start_ignore}             {BEGIN(IGNORE);}
<IGNORE>[^>]*                       {}
<IGNORE>{stop_ignore}               {BEGIN(0);}

    /* element */
<INITIAL>{opening_tag}              {printf("\n"); indentation++; BEGIN(ELEM);}
<ELEM,INITIAL>{closing_tag}         {indentation--; BEGIN(0);}
<ELEM>{opening_tag}                 {indentation++;}
<ELEM>">"                           {}
    /* afisarea elementelor cu indentarea corespunzatoare */
<ELEM>[^>< ]*                       {int i = indentation; 
                                     while(i > 1) {
                                         printf(" ");                 
                                         i--;
                                     }
                                    printf("%s", yytext);
                                    }
<ELEM>" "+{letter}                  {printf(" :"); BEGIN(ATTRIBUTE); REJECT;}


    /* atribute */
<ATTRIBUTE>" "                      {}
<ATTRIBUTE>{atribut}+               {printf(" %s", yytext);}
<ATTRIBUTE>"="                      {printf(" %s", yytext);}
    /* inlocuirea "" cu spatii si afisarea valorii atributului */
<ATTRIBUTE>{value}                  {yytext[0] = ' ';
                                     yytext[yyleng - 1] = ' ';
                                     printf("%s", yytext);
                                     BEGIN(SEMICOLON);}
<ATTRIBUTE>">"                      {yyless(yyleng-1); BEGIN(0);}
<ATTRIBUTE>"<"                      {yyless(yyleng-1); BEGIN(0);}
    /* separarea atributelor */
<SEMICOLON>" "+[^>]                 {printf(";"); BEGIN(ATTRIBUTE); REJECT;}
<SEMICOLON>">"                      {yyless(yyleng-1); BEGIN(0);}

    /* ignorarea caracterelor dintre taguri si a celor pt care nu exista reguli */
<INITIAL,IGNORE,ELEM,ATTRIBUTE>{between_tags} {yyless(yyleng-1); BEGIN(0);}
.|\n  {}
%%

int main(int argc, char **argv) {
    yyin = fopen(argv[1], "r");
    if (!yyin) {
        printf("Can't open the input file\n");
        exit(1);
    }

    yylex();
    return 0;
}