#include <stdio.h>


extern int sprawdz();
extern int ustaw(int p);
extern double liczba(double l);
 
int main(void)
{   int wybor=1, p=1;
    double l, ll;
    	
    
    do
    {
       
        printf("1 - Sprawdz precyzje obliczen\n");
        printf("2 - Zmien precyzje obliczen:\n");
        printf("0 - Zakoncz program\n");
        scanf("%d", &wybor);
 
        switch(wybor)
        {
        case 1:
            printf("\nAktualna precyzja: ");
            switch(sprawdz())
            {
                case 0: printf("Pojedyncza precyzja\n\n"); 
		break;
                case 512: printf("Podwójna precyzja\n\n"); 
		break;
                case 768: printf("Podwójna precyzja rozszerzona\n\n"); 
		break;
            }
            break;
 
        case 2:
            printf("\n1 - Pojedyncza precyzja\n");
            printf("2 - Podwójna precyzja\n");
            printf("3 - Podwójna precyzja rozszerzona\n");
            scanf("%d", &p);
	    ustaw(p);
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
