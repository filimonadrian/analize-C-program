#include <stdio.h>
#include <string.h>

void simple_func(int arg1, int arg2) {
    int i, n = 1;
	for (i = 0; i < n; i++) {
	printf("Am mere");
	}

}

int func_on_multiple_lines(int arg1, int arg2) {
    int multiple1 = 0, /* comentariu */multiple2, multiple3;
    float multiple4, multiple5, multiple6;

    return multiple1; 
}

double test_vars_case(int arg1, int arg2) {
    
    char var;
    int a, b, c; 
    float d, e, f;
    double g;

    return 0.0; 
}


int main() {

    /* skip this comment */

    double n1 = 1, n2 = 2, n3 = 3;
    printf("Skip this function ");
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