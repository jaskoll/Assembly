#include <stdio.h>
 

extern int sprawdz();
extern int ustaw(int z);
extern double liczba(double l);

int main(void)
{
    int wybor=1, z=1;
    double l, ll;
    do
    {
        
        printf("1 - Sprawdz tryb zaokraglania\n");
        printf("2 - Zmien tryb zaokraglania:\n");
        printf("0 - Zakoncz program\n");
        scanf("%d", &wybor);
 
        switch(wybor)
        {
        case 1:
            printf("\nAktualny tryb zaokraglania: ");
            switch(sprawdz())
            {
                case 0: printf("Zaokraglenie do najblizszej\n\n"); 
		break;
                case 1024: printf("Zaokraglenie w dol\n\n"); 
		break;
                case 2048: printf("Zaokraglenie w gore\n\n"); 
		break;
                case 3072: printf("Obciecie\n\n"); 
		break;
            }
            break;
 
        case 2:
            printf("\n0 - Zaokraglenie do najblizszej\n");
            printf("1 - Zaokraglenie w dol\n");
            printf("2 - Zaokraglenie w gore\n");
            printf("3 - Obciecie\n");
            scanf("%d", &z);
            ustaw(z);
            printf("Podaj liczbe\n");
            scanf("%lf", &l);
	    ll = liczba(l);
            printf("\n");
            printf("%lf", ll);
            printf("\n");
            break;
        }
    } while(wybor!=0);
 
    return 0;
}
