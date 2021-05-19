%option yylineno

%{
	#include<stdio.h>
	#include<string.h>
	#include"y.tab.h"
	#include<math.h>
	extern int var_count;

%}

%%
"#include<stdio.h>" {return HEADER;}
"if"	{printf("usage of keyword \"%s\" is prohibited\n",yytext);exit(0);}
"int"	{yylval.data_type=0;return INT;}
"char" {yylval.data_type=1; return CHAR;}
"ints"	{yylval.data_type=0;return INTS;}
"chars" {yylval.data_type=1; return CHARS;}
"is" {return IS;}
"are" {return ARE;}
"main"	{return MAIN;}
"("	{return LB;}
")"	{return RB;}
"{"	{return LCB;}
"}"	{return RCB;}
","	{return COMA;}
";"	{return SC;}
[\+\-\*\/] {return OP;}
"="	{return EQ;}
([ok]{1})(([067gokul])*([gokul]+))* {strcpy(yylval.var_name,yytext);return VAR;}
[\n\t ]+  {/*new line or space*/}	
. {printf("invalid character sequence %s\n",yytext); exit(0);}
%%


int yywrap(void)
{
    return 1;
}
