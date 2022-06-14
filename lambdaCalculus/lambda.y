%{
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
// global variables
int ptr = 0;

// array to store existance of given variable
int regs[26];
char res[1000];

// yacc lunctions to return error, lexical token,
void yyerror(char*);
int yywrap();
int yylex();
// custom fn.
void createFUN(int*, char*);
%}

%start start

%union {
  int a;
  char b;
}

%left '|'
%token VARIABLE LAMBDA DOT PREPAR POSTPAR
%type <a> VARIABLE

%%                   /* beginning of rules section */
start : |
        start lambda_expr '\n' {
            createFUN(regs,res);
            memset(regs,0,sizeof(regs)/sizeof(regs[0]));
            memset(res,'\0',sizeof(res)/sizeof(regs[0]));
            ptr = 0;
            exit(0);
        } |
        start error '\n' {
          yyerrok;
        };

lambda_expr :     |
                  VARIABLE lambda_expr {
                    res[ptr] = $1 + 'a';
                    ptr++;
                  } |
                  LAMBDA VARIABLE DOT lambda_expr {
                    regs[$2] = 1;
                  } |
                  PREPAR lambda_expr POSTPAR lambda_expr;

%%
int main(){
 return (yyparse());
}
void createFUN(int active_regs[26],char final_res[1000]){
  // Initailize file
  FILE* fp = fopen("main.c","w");
  if( fp == NULL ){
    printf("Unable to create file\n");
    return;
  }
  fprintf(fp,"#include <stdio.h>\n");
  fprintf(fp,"#include <stdlib.h>\n");
  fprintf(fp,"#include <string.h>\n");
  fprintf(fp,"#define limit 1000 \n");
  // driver code
  int n = 26, m = 1000;
  for(int i=0; i<m; i++){
    if(final_res[i]>='a' && final_res[i]<='z' && active_regs[final_res[i]-'a']==0){
      active_regs[final_res[i]-'a'] = 2;
    }
  }
  // global variables for c code
  for(int i=0; i<n; i++){
    if(active_regs[i]==2){
      fprintf(fp,"char %c[limit]; \n",i+'a');
    }
  }
  // lambda function for c code
  fprintf(fp,"char* fun(");
  int count = 0;
  for(int i=0; i<n; i++){
    if(active_regs[i]==1){
      count++;
    }
  }
  int temp = count;
  for(int i=0; i<n && count!=0; i++){
    if(active_regs[i]==1){
      count--;
      if(!count){
        fprintf(fp,"char* %c",i+'a');
      }
      else{
        fprintf(fp,"char* %c, ",i+'a');
      }
    }
  }
  count = temp;
  fprintf(fp,"){\n\tchar* res=(char*)malloc(sizeof(char)*limit);\n\tres[0]=%s%c0%s;\n","'",92,"'");
  while(final_res[m-1]=='\0'){
    m--;
  }
  for(int i=m-1; i>=0; i--){
    fprintf(fp,"\tstrcat(res,%c);\n",final_res[i]);
  }
  fprintf(fp,"\treturn res;\n");
  fprintf(fp,"}\n");
  // main function for c code
  fprintf(fp,"int main(){\n");
  for(int  i=0; i<n && count !=0; i++){
    if(active_regs[i]==1){
      if(count==temp){
        fprintf(fp,"\tchar ");
      }
      count--;
      if(!count){
        fprintf(fp,"%c[limit];\n",i+'a');
      }
      else{
        fprintf(fp,"%c[limit], ",i+'a');
      }
    }
  }
  count = temp;
  for(int i=0; i<n; i++){
    if(active_regs[i]!=0){
      fprintf(fp,"\tprintf(%cEnter Value of %c : %c );\n",'"',i+'a','"');
      fprintf(fp,"\tscanf(%c %cs%c, %c);\n",'"','%','"',i+'a');
    }
  }
  fprintf(fp,"\tchar* res = fun(");
  for(int i=0;i<n;i++){
    if(active_regs[i]==1){
      count--;
      if(!count){
        fprintf(fp,"%c",i+'a');
      }
      else{
        fprintf(fp,"%c, ",i+'a');
      }
    }
  }
  fprintf(fp,");\n");
  fprintf(fp,"\tprintf(%cResult : %cs %cn%c, res);\n",'"','%',92,'"');
  fprintf(fp,"\treturn 0;\n");
  fprintf(fp,"}\n");
  //close file
  fclose(fp);
}
void yyerror(char* s){
  fprintf(stderr, "%s\n",s);
}

int yywrap(){
  return(1);
}
