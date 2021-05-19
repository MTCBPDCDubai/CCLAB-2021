%{
	#include<stdio.h>
	#include<stdlib.h>
	#include<string.h>
	int yylex(void);
	int yyerror(const char *s);
	int success = 1;
	int current_data_type;
	int expn_type=-1;
	int temp;
	struct symbol_table{char var_name[30]; int type;}var_list[20];// you may associate an integer with a datatype (say var_list[i].type=1 may imply that variable var_list[i].var_name is of type int) and store that integer against the variable whenever you deal with a declaration statement
	int var_count=-1;//number of entries in the symbol table
	extern int lookup_in_table(char var[30]);//returns the data type associated with the variable name being passed to, returns -1 if in case the variable is undeclared
	extern void insert_to_table(char var[30], int type);//adds a new variable along with its data type to the table and terminates with a "multiple declaration error message", if in case the variable is already being defined
%}

%union{
int data_type;
char var_name[30];
}
%token HEADER MAIN LB RB LCB RCB SC COMA 
%token EQ OP DEC_NUM

%token<data_type>INT
%token<data_type>CHAR
%token<data_type>FLOAT
%token<data_type>DOUBLE

%type<data_type>DATA_TYPE
%token<var_name>VAR
%start prm

%%
prm	: HEADER MAIN_TYPE MAIN LB RB LCB BODY RCB {
							printf("\n parsing successful\n");
						   }
BODY	: DECLARATION_STATEMENTS PROGRAM_STATEMENTS | DECLARATION_STATEMENTS
DECLARATION_STATEMENTS : DECLARATION_STATEMENT DECLARATION_STATEMENTS 
						  {
							printf("\n Declaration section successfully parsed\n");
						  }
			| DECLARATION_STATEMENT
PROGRAM_STATEMENTS : PROGRAM_STATEMENT PROGRAM_STATEMENTS 
						  {
							printf("\n program statements successfully parsed\n");
						  }
			| PROGRAM_STATEMENT
//Modifications:
DECLARATION_STATEMENT: 	VAR_LIST SC {} | VAR EQ DEC_NUM SC
VAR_LIST : VAR LB DATA_TYPE RB COMA VAR_LIST {
				/*insert_to_table($1,$3);*/
			     }
		| VAR LB DATA_TYPE RB EQ DEC_NUM COMA VAR_LIST {
				if($3!=2){
					printf("\nType mismatch.\n");exit(0);}
				/*insert_to_table($1,$3);*/
		}
		| VAR LB DATA_TYPE RB EQ DEC_NUM {
			if($3!=2){
				printf("\nType mismatch.\n");exit(0);}
		}
		| VAR LB DATA_TYPE RB{
		/*insert_to_table($1,$3);*/
	    }
PROGRAM_STATEMENT : EQ LB A_EXPN RB SC

A_EXPN : OP LB A_EXPN RB
		| A_EXPN COMA A_EXPN
		| VAR

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
	| DOUBLE
%%

int lookup_in_table(char var[30])//returns the data type associated with 
{
	return -1;
}
void insert_to_table(char var[30], int type)
{
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

