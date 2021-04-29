%{
	#include<stdio.h>
	#include<stdlib.h>
	#include<string.h>
	int yylex(void);
	int yyerror(const char *s);
	int success = 1;
	int current_data_type;
	int expn_type=-1;
	int is_modulus = 0;
	int temp;
	struct symbol_table{char var_name[30]; int type;}var_list[20];
	int var_count=-1;
	extern int lookup_in_table(char var[30]);
	extern void insert_to_table(char var[30], int type);
	void check_EXPNtype_rhs(char var[30]);
%}

%union{
int data_type;
char var_name[30];
}
%token HEADER MAIN LB RB LCB RCB SC COLON QMARK COMA IF ELSE FOR DO WHILE VAR NUMBER ET EQ GT LT GTE LTE NE AND OR NOT PLUS MINUS MUL DIV MOD EXP UPLUS UMINUS

%left PLUS MINUS
%left MUL DIV MOD
%right EXP
%token<data_type>INT
%token<data_type>CHAR
%token<data_type>FLOAT
%token<data_type>DOUBLE

%type<data_type>DATA_TYPE
%type<var_name>VAR
%start prm

%%
prm	: HEADER MAIN_TYPE MAIN LB RB LCB BODY RCB {
							printf("\n parsing successful\n");
						   }
BODY	: DECLARATION_STATEMENTS PROGRAM_STATEMENTS BODY2
BODY2	: /*Epsilon*/ | DECLARATION_STATEMENTS BODY2 | PROGRAM_STATEMENTS BODY2
DECLARATION_STATEMENTS : DECLARATION_STATEMENT DECLARATION_STATEMENTS 
						  {
							printf("\n Declaration section successfully parsed\n");
						  }
			| DECLARATION_STATEMENT
DECLARATION_STATEMENT: DATA_TYPE VAR_LIST SC {}
VAR_LIST : VAR COMA VAR_LIST {
				insert_to_table($1,current_data_type);
			     }
	| VAR {
		insert_to_table($1,current_data_type);
	      }

MAIN_TYPE : INT
DATA_TYPE : INT {
			$$=$1;
			current_data_type=$1;
		} 
	| CHAR  {
			$$=$1;
			current_data_type=$1;
		}
	| FLOAT {
			$$=$1;
			current_data_type=$1;
		}
	| DOUBLE {
			$$=$1;
			current_data_type=$1;
		}


PROGRAM_STATEMENTS : PROGRAM_STATEMENT PROGRAM_STATEMENTS 
						  {
							printf("\n program statements successfully parsed\n");
						  }
			| LB LOGICAL_EXPN RB QMARK LCB BODY2 RCB COLON LCB BODY2 RCB 
			| IF LB LOGICAL_EXPN RB LCB BODY2 RCB
			| IF LB LOGICAL_EXPN RB LCB BODY2 RCB ELSE LCB BODY2 RCB
			| WHILE LB LOGICAL_EXPN RB LCB BODY2 RCB
			| DO LCB BODY2 RCB WHILE LB LOGICAL_EXPN RB SC
			| FOR LB VAR EQ A_EXPN SC LOGICAL_EXPN SC A_EXPN RB LCB BODY2 RCB
			| PROGRAM_STATEMENT

LOGICAL_EXPN	: NOT LB LOGICAL_EXPN1 RB | LOGICAL_EXPN1
LOGICAL_EXPN1	: LOGICAL_EXPN1 LOGICAL_OPERATOR LOGICAL_EXPN1 | LOGICAL_EXPN2 | NOT LB LOGICAL_EXPN1 RB 
				| LB LOGICAL_EXPN1 RB
LOGICAL_EXPN2	: A_EXPN COMP_OPERATOR A_EXPN
COMP_OPERATOR	: ET | GT | LT | GTE | LTE | NE
LOGICAL_OPERATOR	: AND | OR
 
PROGRAM_STATEMENT : VAR EQ A_EXPN SC {	
					if((temp=lookup_in_table($1))!=-1)
					{
						if (is_modulus){
							if(expn_type!=0 && temp!=0){
								yyerror("Modulus operator reserved for integers."); exit(0);
							}
							is_modulus = 0;
						}
						if(expn_type==-1)
						{
							expn_type=temp;
						}else if(expn_type!=temp)
						{
							printf("\ntype mismatch in the expression\n");
							exit(0);
						}
					}else
					{
						printf("\n variable \"%s\" undeclared\n",$1);exit(0);
					}
					expn_type=-1;	
				}
				| SC
				| VAR UPLUS SC
				| VAR UMINUS SC
A_EXPN		:A_EXPN PLUS A_EXPN
		|A_EXPN MINUS A_EXPN
		|A_EXPN MUL A_EXPN
		|A_EXPN DIV A_EXPN
		|A_EXPN MOD A_EXPN {
			is_modulus = 1;
		}
		| A_EXPN EXP A_EXPN 
		| LB A_EXPN RB
		| VAR UPLUS {
			check_EXPNtype_rhs($1);
		}
		| VAR UMINUS {
			check_EXPNtype_rhs($1);
		}
		| VAR {
			check_EXPNtype_rhs($1);
		}
		| NUMBER

%%

void check_EXPNtype_rhs(char var[30])
{
	if((temp=lookup_in_table(var))!=-1)
	{				
		if(expn_type==-1)
		{
			expn_type=temp;
		}else if(expn_type!=temp)
		{
			printf("\ntype mismatch in the expression\n");
			exit(0);
		}
	}else
	{
		printf("\n variable \"%s\" undeclared\n",var);exit(0);
	}	
}

int lookup_in_table(char var[30])
{
	for(int i=0; i<=var_count; i++)
	{
		if(strcmp(var_list[i].var_name, var)==0)
		{
			return var_list[i].type;
		}
	}
	return -1;
}
void insert_to_table(char var[30], int type)
{
	if (lookup_in_table(var) == -1)
	{
		var_count++;
		strcpy(var_list[var_count].var_name, var);
    	var_list[var_count].type = type;
    }
    else
    {
		char error_message[50];
		strcpy(error_message, "multiple declaration of variable: ");
    	yyerror(strcat(error_message, var));
    	exit(0);
    }
}
int main()
{
    yyparse();
/*    if(success)
    	printf("Parsing Successful\n");*/
    return 0;
}

int yyerror(const char *msg)
{
	extern int yylineno;
	printf("Parsing Failed\nLine Number: %d %s\n",yylineno,msg);
	success = 0;
	return 0;
}

