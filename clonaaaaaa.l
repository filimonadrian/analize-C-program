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

function_header ^[A-Za-z_ ][A-Za-z0-9_ "\n"]*\([^;><="]*\)[ "\n"]*{1}

%X EXTRACT_ARGS PROC_FUNC DONE MULTILINE_COMMENT INITIALL

%%

<PROC_FUNC>" " {
    BEGIN(PROC_FUNC);
    // printf("\t%s", yytext);

}

<EXTRACT_ARGS>"(" {
    BEGIN(PROC_FUNC);
}


<INITIALL>{function_header} {
    /* identificarea antetului functiei */
    printf("%s\n", yytext);
    // BEGIN(EXTRACT_ARGS);
}

<DONE>"\n" {                 
    printf("\n");
    BEGIN(INITIAL);
}

<INITIAL>{multiline_comment} {
/* <MULTILINE_COMMENT>{multiline_comment} { */

    printf("%s\n", yytext);
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








<INITIAL>[/*] {
    BEGIN(IGNORE);
    printf("%s\n", yytext);
}
<IGNORE>[^/*]* {printf("%s\n", yytext);}

<IGNORE>[*/] {
    printf("%s\n", yytext);
    BEGIN(0);
}

<INITIAL>.* { }
.|\n {}




    /* ignorarea tuturor comentariilor din cod */
    /* https://www.cs.virginia.edu/~cr4bd/flex-manual/Start-Conditions.html */

"/*" {
    comment_caller = INITIAL;
    BEGIN(comment);
}

<start_comment>"/*" {
    comment_caller = start_comment;
    BEGIN(comment);
}

<comment>[^*\n]*        /* treci peste tot ce nu este * */
<comment>"*"+[^*/\n]*   /* treci * care nu sunt urmate de / */
<comment>\n             ++line_num; /* numara pe cate linii este comentariul */
<comment>"*"+"/"        BEGIN(comment_caller);


<INITIAL>"/*[."\n"]**/" {} /* daca este comentariu il ignor */ 



/* AFISEAZA TIPUL FUNCTIEI -- DEPINDE DE CODING STYLE */



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


    <INITIAL> .|\n {}
<func_name>.|\n {}
<func_params>.|\n {}
<func_content>.|\n {}
<func_end>.|\n {}
<vars>.|\n {}