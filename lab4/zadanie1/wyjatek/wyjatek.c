#include <stdio.h>


extern int wyjatek();

int main(void){
int wyjatekk,j;
wyjatekk = wyjatek();

int i=0,tab[15];
 
  while(wyjatekk) 
  {
    tab[i++]=wyjatekk%2;
    wyjatekk/=2;
  }
 
  for(j=i-1;j>=0;j--)
    printf("%d",tab[j]);
    printf("\n");

}
