#include <stdio.h>
#include <string.h>

void calc_medie(int arg1, int arg2) {
    int i, n = 1;
	for (i = 0; i < n; i++) {
	printf("Am mere");
	}
}

int 
calc_medie2
        (int 
        arg1, int arg2) {

    int a = 0, /* comentariu */b, c;
    float d, e, f;

    return a; 
}

int test_vars_case(int arg1, int arg2) {
    
    unsigned long long int var;
    int a, b, c; 
    float d, e, f;
    double g;

    return a; 
}

unsigned 
long 
long
int multi_line_funct
(long long int var1) {

    unsigned long long int a;
    float b;

    return a;
}

int main() {

    /* $calc_medie2(1, 2); */

    double n1 = 1, n2 = 2, n3 = 3;
    printf("Enter three numbers: ");
    /* scanf("%lf %lf %lf", &n1, &n2, &n3); */

    /* if n1 is greater than both n2 and n3, n1 is the largest */
    if (n1 >= n2 && n1 >= n3)
        printf("%.2lf is the largest number.\n", n1);

    else if (n2 >= n1 && n2 >= n3)
        printf("%.2lf is the largest number.\n", n2);

    else
        printf("%.2lf is the largest number.\n", n3);

    return 0;
}