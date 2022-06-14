#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define limit 1000 
char a[limit]; 
char b[limit]; 
char* fun(char* x, char* y){
	char* res=(char*)malloc(sizeof(char)*limit);
	res[0]='\0';
	strcat(res,a);
	strcat(res,b);
	strcat(res,x);
	return res;
}
int main(){
	char x[limit], y[limit];
	printf("Enter Value of a : " );
	scanf(" %s", a);
	printf("Enter Value of b : " );
	scanf(" %s", b);
	printf("Enter Value of x : " );
	scanf(" %s", x);
	printf("Enter Value of y : " );
	scanf(" %s", y);
	char* res = fun(x, y);
	printf("Result : %s \n", res);
	return 0;
}
