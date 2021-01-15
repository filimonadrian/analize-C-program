%{
    #include <stdio.h>
    int count = 0;
%}

letters [a-zA-Z0-9]

%X DONE

%%

<INITIAL>{letters}+ {
    //code in c
    printf("%s\n", yytext);
    BEGIN(DONE);
}

<DONE>"}" {
    printf("\n");
    BEGIN(INITIAL);
}

<INITIAL>.|\n {}
<DONE>.|\n {}
%%

int main(int argc, char **argv) {
    yyin = fopen(argv[1], "r");
    if (!yyin) {
        printf("Eroare la deschiderea fisierului! \n");
        exit(1);
    }

    yylex(); 
    return 0;
}
