%option yylineno

%{
	#include<stdio.h>
	#include<string.h>
	#include"y.tab.h"
	#include<math.h>
	extern int var_count;
%}

%%
"include" {return INCLUDE;}
([a-z]+|[A-Z]+)+["."][h] {return HEADER_FILE;}
"if"	{return IF;}
"else"	{return ELSE;}
"for"	{return FOR;}
"do"	{return DO;}
"while"	{return WHILE;}
"int"	{yylval.data_type=0;return INT;}
"char" {yylval.data_type=1; return CHAR;}
"float" {yylval.data_type=2; return FLOAT;}
"double" {yylval.data_type=3; return DOUBLE;}
"main" {return MAIN;}
"#" {return HASH;}
"("	{return LB;}
")"	{return RB;}
"{"	{return LCB;}
"}"	{return RCB;}
"[" {return LSQRB;}
"]" {return RSQRB;}
","	{return COMA;}
";"	{return SC;}
":"	{return COLON;}
"?"	{return QMARK;}
"++" {return UPLUS;}
"--" {return UMINUS;}
"^" {return EXP;}
[+] {return PLUS;}
[-] {return MINUS;}
[*] {return MUL;}
[/] {return DIV;}
[%] {return MOD;}
"==" {return ET;}
"="	{return EQ;}
">" {return GT;}
"<" {return LT;}
">=" {return GTE;}
"<=" {return LTE;}
"!=" {return NE;}
"&" {return AMPER;}
"||" {return OR;}
"!" {return NOT;}
[\"] {return DQUOTE;}
\/\/(.*) {/*Single line comment*/};	
[a-z]+ {strcpy(yylval.var_name,yytext);return VAR;}
[0-9]+ {yylval.integer_val = atoi(yytext); return INT_NUMBER;}
[0-9]+(\.[0-9]+) {yylval.float_val = atof(yytext); return FLOAT_NUMBER;}
[\n\t ]+  {/*new line or space*/}
. {printf("invalid character sequence %s\n",yytext); exit(0);}
%%


int yywrap(void)
{
    return 1;
}
