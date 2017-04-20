#include <stdio.h>


extern float calka(int n, float xp, float xk, float d, int b);


int main(void) {
        
        float xk, xp, wynik_calka,d,a,c;
        int n,b;
        printf("Funkcja: (a/c)*x^b\n");
        printf("Podaj a\n");
        scanf("%f", &a);
        printf("Podaj c\n");
        scanf("%f", &c);
 	printf("Podaj b\n");
        scanf("%d", &b);
        printf("Podaj n - ilosc prostokatow\n");
        scanf("%d", &n);
        printf("Podaj xp - poczatek przedzialu\n");
        scanf("%f", &xp);
        printf("Podaj xk - koniec przedzialu\n");
        scanf("%f", &xk);
        d=a/c;
        wynik_calka = calka(n,xp,xk,d,b);
        

        printf("calka =  %f", wynik_calka);
    

        return 0;
}
