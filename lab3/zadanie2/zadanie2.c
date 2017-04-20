#include <stdio.h>

void euklides(){

int a,b;
printf("Podaj a: \n");
scanf("%d", &a);
printf("Podaj b: \n");
scanf("%d", &b);

while (a != b)
{
if (a < b)
b -= a;
else
a -= b;
}
printf("NWD= %d", a);



}


