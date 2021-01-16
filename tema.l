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

        int line_num = 1;
        int comment_caller;
        
%}

letter [A-Za-z]
number [0-9]
inner_letter [A-Za-z0-9_-]
first_letter [A-Za-z_ ]
special_chars [^;<>="']

singleline_comment "//".* 
multiline_comment [/][*][^*]*[*]+([^*/][^*]*[*]+)*[/]

function_header ^[A-Za-z_ ][A-Za-z0-9_ "\n"]*\([^;><="]*\)[ "\n"]*{1}

%X comment start_comment

%%

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

    /* afisarea antetelor functiilor */


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