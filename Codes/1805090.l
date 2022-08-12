%option noyywrap yylineno
%x STRING
%x SINGLE_COMMENT
%x MULTI_COMMENT
%{
#include<iostream>
#include<fstream>
#include<stdlib.h>
#include"1805090_SymbolInfo.h"
#include "y.tab.h"
using namespace std;

int error_count=0;

ofstream lout;
ofstream tout;

// SymbolTable* st;
string string_builder;
string string_yytext;
int startedAt;

extern YYSTYPE yylval;
// extern SymbolTable *table;
// void yyerror(char *);
extern void errorr(const char *s);

void insertIntoSymbolTable(string name, string type){
	// cout<<"type: <"<<type<<">\tname: <"<<name<<">"<<endl;
	// if(st->insert(name, type)){
	// 	st->printAll(lout);
	// }
}

void onlyToken(string token){
	lout<<"\nLine no "<<yylineno<<": TOKEN <"<<token<<"> Lexeme "<<yytext<<" found\n";
	tout<<"<"<<token<<"> ";
}
void tokenWithSymbol(string type, string symbol){
	lout<<"\nLine no "<<yylineno<<": TOKEN <"<<type<<"> Lexeme "<<yytext<<" found\n";
	tout<<"<"<<type<<", "<<symbol<<"> ";
}
void handleString(string type, string symbol){
	// lout<<"\nLine no "<<startedAt<<": TOKEN <"<<type<<"> Lexeme "<<string_yytext<<" found --> <"<<type<<", \""<<string_builder<<"\">"<<endl;
	// tout<<"<"<<type<<", \""<<symbol<<"\"> ";
	//TODO EITA THEKE STRING RETURN KORBO
	SymbolInfo* si = new SymbolInfo(string_builder, "STRING");
	return STRING;
}
void printKeywords(){
	//TODO NO KAJ, DELETE KORA LAGBE MONE HOY
	string token;
	int len = strlen(yytext);
	for(int i=0; i<len; i++){
		if(yytext[i] >= 'a' && yytext[i] <= 'z'){
			token += yytext[i] - 'a' + 'A';
		}else token += yytext[i];
	}
	onlyToken(token);
}

void errorAtLine(int lineNo = yylineno){
	lout<<"\nError at line no "<<lineNo<<": ";
	error_count++;
}

void const_int_float_char(string type, string symbol){
	tokenWithSymbol(type, symbol);
	insertIntoSymbolTable(symbol, type);
}
void const_char(string type, string charText, char c){
	SymbolInfo* si = new SymbolInfo(yytext, "CONST_CHAR");
	yylval.si = si;
	return CONST_CHAR;
}

void operatorAndPunc(string type){
	// tokenWithSymbol(type, yytext);
	SymbolInfo* si = new SymbolInfo(yytext, type);
	yylval.si = si;
}
char getSpecialChar(string text){
	if(!text.compare("'\\n'")) {
		return '\n';
	}
	if(!text.compare("'\\t'")){
		return '\t';
	} 
	if(!text.compare("'\\\\'")){
		return '\\';
	} 
	if(!text.compare("'\\''")) {
		return '\'';
	}
	if(!text.compare("'\\a'")) {
		return '\a';
	}
	if(!text.compare("'\\f'")) {
		return '\f';
	}
	if(!text.compare("'\\r'")) {
		return '\r';
	}
	if(!text.compare("'\\b'")) {
		return '\b';
	}
	if(!text.compare("'\\v'")) {
		return '\v';
	}
	if(!text.compare("'\\0'")) {
		return '\0';
	}
	cout<<"Matched nothing!"<<endl;
	return '\0';
}

%}

WHITESPACE [ \t\f\r\v]+
LETTER [a-zA-Z]
DIGIT [0-9]
NEWLINE \n

%%

\r?\n 		{}
{WHITESPACE}+ {}	

"if" {return IF;}
"else" {return ELSE;}
"for" {return FOR;}
"while" {return WHILE;}
"do" {return DO;}
"break" {return BREAK;}
"int" {return INT;}
"char" {return CHAR;}
"float" {return FLOAT;}
"double" {return DOUBLE;}
"void" {return VOID;}
"return" {return RETURN;}
"switch" {return SWITCH;}
"case" {return CASE;}
"default" {return DEFAULT;}
"continue" {return CONTINUE;}
"printf" {return PRINTLN;}

{DIGIT}+ {
	SymbolInfo* si = new SymbolInfo(yytext, "CONST_INT");
	yylval.si = si;
	// cout<<"eikhan theke return kore! "<<yytext<<endl;
	return CONST_INT;}

{DIGIT}*[\.]?{DIGIT}+([Ee](-)?{DIGIT}+)? {
	SymbolInfo* si = new SymbolInfo(yytext, "CONST_FLOAT");
	yylval.si = si;
	return CONST_FLOAT;}

'[^\\]' {
	char c[2] = "x";
	c[0] = yytext[1];
	const_char("CONST_CHAR", yytext, c[0]);}

'\\[nt\\'afrbv0]' {
	char c[3] = "\\x";
	c[1] = yytext[2];
	string s = "";
	s += getSpecialChar(yytext);
	const_char("CONST_CHAR", yytext, getSpecialChar(yytext));}

"+" |
"-" {
		operatorAndPunc("ADDOP");
		return ADDOP;}
"*" |
"/" |
"%" {
		operatorAndPunc("MULOP");
		return MULOP;}
"++" {return INCOP;}
"--" {return DECOP;}
"<" |
"<=" |
">" |
">=" |
"==" |
"!=" {operatorAndPunc("RELOP");
		return RELOP;}
"=" {operatorAndPunc("ASSIGNOP");
		return ASSIGNOP;}
"&&" |
"||" {operatorAndPunc("LOGICOP"); return LOGICOP;}
"!" {return NOT;}
"(" {return LPAREN;}
")" {return RPAREN;}
"{" {return LCURL;}
"}" {return RCURL;}
"]" {return RTHIRD;}
"[" {return LTHIRD;}
"," {return COMMA;}
";" {return SEMICOLON;}

[A-Za-z_][A-Za-z_0-9]* {
	// tokenWithSymbol("ID", yytext);
	// insertIntoSymbolTable(yytext, "ID");
	SymbolInfo* si = new SymbolInfo(yytext, "ID");
	yylval.si = si;
	return ID;
}

{DIGIT}*\.{DIGIT}*(\.{DIGIT}*)+ {
	// errorAtLine();
	// lout<<"Too many decimal points "<<yytext<<endl;
	string s = string("Too many decimal points ") + yytext;
	errorr(s.c_str());
	SymbolInfo* si = new SymbolInfo(yytext, "CONST_FLOAT");
	yylval.si = si;
	return CONST_FLOAT;
}
{DIGIT}*(\.)?[Ee]-?{DIGIT}*(\.{DIGIT}*)+ {
	// lout<<"Ill formed number "<<yytext<<endl;
	string s = string("Ill formed numeber ")+yytext;
	errorr(s.c_str());
	SymbolInfo* si = new SymbolInfo(yytext, "CONST_FLOAT");
	yylval.si = si;
	return CONST_FLOAT;
}
{DIGIT}*[\.]?{DIGIT}+([Ee](-)?{DIGIT}+)?[A-Za-z_][A-Za-z_0-9]* {
	// errorAtLine();
	// lout<<"Invalid prefix on ID or invalid suffix on Number "<<yytext<<endl;
	string s = string("Invalid prefix on ID or invalid suffix on Number ")+yytext;
	errorr(s.c_str());
	SymbolInfo* si = new SymbolInfo(yytext, "CONST_FLOAT");
	yylval.si = si;
	return CONST_FLOAT;
}
{DIGIT}*[\.][A-Za-z_][A-Za-z_0-9]* {
	errorAtLine();
	// lout<<"Invalid prefix on ID or invalid suffix on Number "<<yytext<<endl;
	string s = string("Invalid prefix on ID or invalid suffix on Number ")+yytext;
	errorr(s.c_str());
	SymbolInfo* si = new SymbolInfo(yytext, "CONST_FLOAT");
	yylval.si = si;
	return CONST_FLOAT;
}
"''" {
	// errorAtLine();
	// lout<<"Empty character constant error ''"<<endl;
	// string s = "Empty character constant error ''";
	// errorr(s.c_str());
}
'\\?..+' {
	// errorAtLine();
	// lout<<"Multi character constant error "<<yytext<<endl;
}
'\r?\n {
	// errorAtLine(yylineno - 1);
	// lout<<"Unterminated character "<<yytext;
}
'.[^'\n]+ {
	// errorAtLine();
	// lout<<"Unterminated character "<<yytext<<endl;
}
\" {
	BEGIN STRING;
	string_builder = "";
	// printLineNum();
	startedAt = yylineno;
	string_yytext = yytext;
}
<STRING>\\[nt\\'afrbv0] {
	string s = "\'";
	s += yytext;
	s += "\'";
	string_builder += getSpecialChar(s);
	string_yytext += yytext;
}
<STRING>\\\" {
	string_builder += "\"";
	string_yytext += yytext;
}
<STRING>[\\][\r]?[\n] {
	string_yytext += yytext;
}

<STRING>\r?\n {
	// errorAtLine(startedAt);
	// lout<<"Unterminated String "<<string_yytext<<endl;
	BEGIN INITIAL;
}
<STRING>\\ {
	// errorAtLine(startedAt);
	// lout<<"Unterminated String "<<string_yytext<<endl;
	BEGIN INITIAL;
}
<STRING>\" {
	string_yytext += yytext;
	handleString("STRING", string_builder);
	BEGIN INITIAL;
}
<STRING>. {
	string_builder += yytext;
	string_yytext += yytext;
}
<STRING><<EOF>> {
	// errorAtLine(startedAt);
	// lout<<"Unterminated String "<<string_yytext<<endl;
	return 0;
}

"//" {
	startedAt = yylineno;
	BEGIN SINGLE_COMMENT;
	string_builder = yytext;
}
<SINGLE_COMMENT>[\\][\r]?[\n] {
}
<SINGLE_COMMENT>. {
	string_builder += yytext;
}
<SINGLE_COMMENT>\r?\n {
	// cout<<"built comment: "<<string_builder<<endl;
	// lout<<"\nLINE no "<<startedAt<<": Token <COMMENT> Lexeme "<<string_builder<<" found"<<endl;
	BEGIN INITIAL;
}

"/*" {
	BEGIN MULTI_COMMENT;
	startedAt = yylineno;
	string_builder = yytext; 
}
<MULTI_COMMENT>"*/" {
	string_builder += yytext;
	// cout<<"built comment: "<<string_builder<<endl;
	// lout<<"\nLINE no "<<startedAt<<": Token <COMMENT> Lexeme "<<string_builder<<" found"<<endl;
	BEGIN INITIAL;
}
<MULTI_COMMENT>. {
	string_builder += yytext;
}
<MULTI_COMMENT><<EOF>> {
	// errorAtLine(startedAt);
	// lout<<"Unterminated Comment "<<string_yytext<<endl;
	return 0;
}

<<EOF>> {
	// cout<<"end of file"<<endl;
	return 0;
}
[.] {
	// cout<<"eikhane: "<<yytext<<endl;
	// lout<<"Error at line no "<<yylineno<<": Unrecognized character "<<yytext<<endl<<endl;
	// error_count++;
	errorr("Unrecognized character");
}
%%