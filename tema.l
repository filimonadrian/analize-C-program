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

data_type void|int|float|double|char
function_parameters \(.*\)
function_content \([.|\n]*\)

function_name [A-Za-z_]+[A-Za-z0-9_-]*
        /* first ch */  /* inner chrs*/  /* if the var if vector */
variable_name [A-Za-z_]+[A-Za-z0-9_-]*(\[\])*
variable_name_rule _*[a-zA-Z]*\**(\[\])*
end_declaring_vars ;
end_function \}\n

%X func_name func_params func_content func_end local_vars 

%%

    /* extract type of function */
<INITIAL>{data_type} {
    strcpy(func.type, yytext);
    strcat(func.type, "\0");
    BEGIN(func_name);
}


<func_name>{function_name} {
    strcpy(func.name, yytext);
    strcat(func.name, "\0");
    BEGIN(func_params);
}

<func_params>{function_parameters} {
    strcpy(func.args, yytext);
    strcat(func.args, "\0");

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
    strcat(func.vars[vars_NO].type, "\0");
    BEGIN(local_vars);
}

    /* extract name of local variables*/
<local_vars>{variable_name_rule} {

    strcpy(func.vars[vars_NO++].name, yytext);

    BEGIN(local_vars);
}

 
<local_vars>; { 
 
    BEGIN(func_content);
}

    /* if we are at the end of the function */
<func_content>\}\n {
    printf("%s %s%s\n", func.type, func.name, func.args);
    printf("\ttip returnat: %s\n", func.type);
    printf("\tnume: %s\n", func.name);

    printf("\tvariabile locale: %d(", vars_NO);

    /* check if function has variables */
    for (int i = 0; i < vars_NO; i++) {

        /* if it's the first variable, print it's type */
        if (i == 0) {
            printf("%s ", func.vars[i].type);
        }

        /* if the last printed type is not the same as the current type
         * print the type
        */
        if (i > 0 && strcmp(func.vars[i].type, func.vars[i - 1].type) != 0) {
            printf("%s ", func.vars[i].type);
        }

        if (i == vars_NO - 1) {
            printf("%s)\n", func.vars[i].name);

        } else {
            printf("%s, ", func.vars[i].name);
        }
    }

    memset(&func, 0, sizeof(function));
    vars_NO = 0;
    BEGIN(INITIAL);
}

<INITIAL>.|\n {}
<func_name>.|\n {}
<func_params>.|\n {}
<func_content>.|\n {}
<func_end>.|\n {}
<local_vars>.|\n {}

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