%{

#include <stdio.h>
#include "y.tab.h"
#include <string.h>

int c;
char d;
%}
%%
" "       ;
[a-z]     {
            c = yytext[0];
            yylval.a = c - 'a';
            return(VARIABLE);
          }
[L]       {
            d = yytext[0];
            yylval.b = d;
            return(LAMBDA);
          }
[.]       {
            d = yytext[0];
            yylval.b = d;
            return(DOT);
          }
[(]       {
            d = yytext[0];
            yylval.b = d;
            return(PREPAR);
          }
[)]       {
            d = yytext[0];
            yylval.b = d;
            return(POSTPAR);
          }
[^a-zL.()\b]  {
                c = yytext[0];
                return(c);
              }
%%
