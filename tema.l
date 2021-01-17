/* FILIMON ADRIAN, 334CC */

%{
        #include <stdio.h>
        #include <string.h>
        #include <stdlib.h>

        typedef struct variables {
            char name[100];
            char type[10];
        } variables;

        typedef struct function {
            char name[30];
            char type[10];
            char args[100];
            variables vars[100];

        } function;

        function func;
        int vars_NO = 0;        
%}

data_type void|int|float|double|char
function_parameters \(.*"\n"*\)

function_name [A-Za-z_]+[A-Za-z0-9_-]*
        /* first ch */  /* inner chrs*/  /* if the var if vector */
variable_name [A-Za-z_]+[A-Za-z0-9_-]*(\[[0-9]*\])*
end_declaring_vars ;
end_function \}\n
comment \/\*[^*]*\*\/

%X func_name func_params func_content local_vars 

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

    /* skip comments in function */
<func_content>{comment} { 
    BEGIN(func_content);
}

<func_content>\/\/.* { 
    BEGIN(func_content);
}

    /* extract type of variable */
<func_content>{data_type} { 
    strcpy(func.vars[vars_NO].type, yytext);
    strcat(func.vars[vars_NO].type, "\0");
    BEGIN(local_vars);
}

    /* skip functions calls(example: printf or while, for..) */ 
<func_content>{function_name}\([^*]*\) { 
    BEGIN(func_content);
}

    /* extract name of local variables*/
<local_vars>{variable_name} {
    strcpy(func.vars[vars_NO++].name, yytext);
    BEGIN(local_vars);
}

<local_vars>{comment} {
    BEGIN(local_vars);
}
 
<local_vars>; { 
 
    BEGIN(func_content);
}

    /* if we are at the end of the function */
<func_content>{end_function} {
    printf("%s %s%s\n", func.type, func.name, func.args);
    printf("\ttip intors: %s\n", func.type);
    printf("\tnume: %s\n", func.name);

    printf("\tvariabile locale: %d(", vars_NO);

    /* check if function has variables */
    for (int i = 0; i < vars_NO; i++) {

        /* if it's the first variable, print it's type */
        if (i == 0) {
            // printf("%s ", func.vars[i].type);
        }

        /* just first var has it's type in the struct
         * if the type is null ==> this var has the same type like 
        */
        if (strcmp(func.vars[i].type, "") != 0) {
            printf("%s ", func.vars[i].type);

        }
        
        /* if is the last variable, close the parantheses */
        if (i == vars_NO - 1) {
            printf("%s)\n", func.vars[i].name);
        
        /* else print regular */
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