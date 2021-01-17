%{ 
    char returnType[50];
    char functionName[50];
    int localVariables;
    char variables[500][500];
    int currentVariableIdx;
    int isCurrentVariablesType = 0;
%} 
 
cDataTypeRule void|char|int|float|double
functionNameRule [a-zA-Z]+[0-9]*
variableNameRule _*[a-zA-Z]*\**(\[\])*
 
%s FUNCTION_NAME
%s FUNCTION_PARAMETERS
%s FUNCTION_CONTENT
%s FUNCTION_VARIABLES
%s FUNCTION_END
 
%% 
<INITIAL>#include.*\n { }
 
<INITIAL>{cDataTypeRule} {
    localVariables = 0;
    currentVariableIdx = 0;
    strcpy(variables, "");
    strcpy(returnType, yytext);
 
    BEGIN(FUNCTION_NAME);
}
 
<FUNCTION_NAME>{functionNameRule} {
    strcpy(functionName, yytext);
 
    BEGIN(FUNCTION_PARAMETERS);
}
 
<FUNCTION_PARAMETERS>\(.*\) {
    printf("%s %s%s\n", returnType, functionName, yytext);
    printf("\ttip returnat: %s\n", returnType);
    printf("\tnume: %s\n", functionName);
 
    BEGIN(FUNCTION_CONTENT);
}
 
<FUNCTION_CONTENT>\/\*[^*]*\*\/ { 
    BEGIN(FUNCTION_CONTENT);
}
 
<FUNCTION_CONTENT>{functionNameRule}\([^*]*\) { 
    BEGIN(FUNCTION_CONTENT);
}
 
<FUNCTION_CONTENT>{cDataTypeRule} { 
    isCurrentVariablesType = 1;
    strcpy(variables[currentVariableIdx++], yytext);
 
    BEGIN(FUNCTION_VARIABLES);
}
 
<FUNCTION_VARIABLES>{variableNameRule} { 
    strcpy(variables[currentVariableIdx++], yytext);
 
    localVariables++;
}
 
<FUNCTION_VARIABLES>; { 
    strcpy(variables[currentVariableIdx++], "#");
 
    BEGIN(FUNCTION_CONTENT);
}
 
<FUNCTION_CONTENT>\}\n { 
    strcpy(variables[currentVariableIdx++], "##");
    isCurrentVariablesType = 1;
    printf("\tvariabile locale: %d\n", localVariables);
 
    printf("\t\t");
 
    for (int i = 0; i < currentVariableIdx; i++) {
        if (strcmp(variables[i], "#") == 0) {
            isCurrentVariablesType = 1;
            printf("\n\t\t");
            continue;
        } else if (strcmp(variables[i], "##") == 0) {
            printf("\n");
            break;
        }
 
        if (isCurrentVariablesType == 1) {
            printf("%s ", variables[i]);
            isCurrentVariablesType = 0;
        } else {
            if (strcmp(variables[i + 1], "#") != 0) {
                printf("%s, ", variables[i]);
            } else {
                printf("%s", variables[i]);
            }
        }        
    }
 
    BEGIN(INITIAL);
}
 
.|\n { }
%% 
 
int yywrap(){} 
int main(){ 
 
FILE *fp; 
fp = fopen("test.c","r"); 
yyin = fp; 
 
yylex(); 
 
return 0; 
} 