#include <stdio.h>

void potega(){
float a;
int b;
float w=1;
int i=0;
printf("Podaj liczbe\n");
scanf("%f", &a);
printf("Podaj potege\n");
scanf("%d", &b);



    if( b != 0 )
   
    {
        for(i; i < b; i++ )
        {
            w = w * a;
           
        }
    } else if(b==0){
	w=1;
}


printf("Wynik wynosi %f", w);

}

int main(){

potega();


}
