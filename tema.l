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
            char signature[100];
            char name[30];
            char type[10];
            char args[100];
            variables vars[100];

        } function;

        function func;
        int vars_NO = 0;
        
%}

letter [A-Za-z]
number [0-9]
inner_letter [A-Za-z0-9_-]
first_letter [A-Za-z_ ]
special_chars [^;<>="']

singleline_comment "//".* 
multiline_comment [/][*][^*]*[*]+([^*/][^*]*[*]+)*[/]

function_header ^[A-Za-z_ ][A-Za-z0-9_ "\n"]*\([^;><="]*\)[ "\n"]*{1}

data_type void|int|float|double|char
function_parameters \([.|\n]*\)
function_content \([.|\n]*\)

function_name [A-Za-z_]+[A-Za-z0-9_-]*
        /* first ch */  /* inner chrs*/  /* if the var if vector */
variable_name [A-Za-z_]+[A-Za-z0-9_-]*(\[\])*
end_declaring_vars ;
end_function \}\n

%X func_name func_params func_content func_end local_vars 

%%

    /* extract type of function */
<INITIAL>{data_type} {
    // printf("\tTip intors: %s\n", yytext); 
    strcpy(func.type, yytext);
    BEGIN(func_name);
    
}

<INITIAL>"/*[."\n"]**/" {} /* daca este comentariu il ignor */ 

<func_name>{function_name} {
    // printf("\nNume: %s\n", yytext); 
    strcpy(func.name, yytext);
    BEGIN(func_content);
}

<func_params>{function_parameters} {
    strcpy(func.args, yytext);
    BEGIN(func_content);
}

    /* skip comments */
<func_content>\/\*[^*]*\*\/ { 
    BEGIN(func_content);
}
    /* skip functions calls(for exec. printf) */ 
<func_content>{function_name}\([^*]*\) { 
    BEGIN(func_content);
}
 
    /* extract type of variable */
<func_content>{data_type} { 
    strcpy(func.vars[vars_NO].type, yytext);
    BEGIN(local_vars);
}

    /* */
<local_vars>{variable_name} {
    strcpy(func.vars[vars_NO].name, yytext);
    vars_NO++;
}

<local_vars>{end_declaring_vars} {
    BEGIN(func_content);
}


<func_content>{end_function} {
    printf("%s %s %s\n", func.type, func.name, func.args);
    printf("\ttip intors: %s\n", func.type);
    printf("\tnume: %s\n", func.name);
    printf("\tvariabile locale: %d(", vars_NO);

    for (int i = 0; i < vars_NO; i++) {
        if (i == vars_NO - 2) {
            printf("%s)\n", func.vars[i].name);

        } else {
            printf("%s, ", func.vars[i].name);
        }
    }
    BEGIN(INITIAL);
}

<func_end>"\}\n" {
    BEGIN(INITIAL);
}

.|\n { }

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