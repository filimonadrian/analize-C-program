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

letter [A-Za-z]
number [0-9]
inner_letter [A-Za-z0-9_-]
first_letter [A-Za-z_ ]
special_chars [^;<>="']

singleline_comment "//".* 
multiline_comment [/][*][^*]*[*]+([^*/][^*]*[*]+)*[/]

function_header (^[A-Za-z_ ][A-Za-z0-9_ "\n"]*\([^;><="]*\)[ ]*{)

%X DONE

%%
    /* identificarea antetului functiei */
<INITIAL> {function_header} {
    printf("%s\n\n", yytext);
    BEGIN(DONE);
}

<DONE>"}" {
    BEGIN(INITIAL);
}

<INITIAL>.|\n {}
<DONE>.|\n {}
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