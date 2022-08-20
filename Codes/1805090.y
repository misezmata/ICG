%{
#include<iostream>
#include<cstdlib>
#include<cstring>
#include<cmath>
#include "1805090_SymbolTable.h"

using namespace std;

int yyparse(void);
int yylex(void);
extern FILE *yyin;
extern int yylineno;
SymbolTable *table;
vector<pair<string, string> > paramList;
ofstream errout;
ofstream logout;
ofstream asmout;
stringstream dseg;
stringstream cseg;
stringstream pseg;
int errorno = 0;

int funcOffset = 0;
int isLastIdArray = false;

void yyerror(char *s)
{
	//write your code
}

void errorr(const char *s, bool flag = true){
	errorno++;
	errout<<"Error at line "<<yylineno<<": "<<s<<"\n"<<endl;
	logout<<"Error at line "<<yylineno<<": "<<s<<"\n"<<endl;
	asmout<<";Error at line "<<yylineno<<": "<<s<<"\n"<<endl;
	if(flag) exit(0);
	// printf("\033[1;31mError at line: %d:  %s \033[0m\n",yylineno, s);
}

void warning(const char *s){
	// printf("\033[1;33mWARNING(at line: %d):  %s \033[0m\n",yylineno, s);
}

void print(string s){
	// cout<<"Line "<<yylineno<<": "<<s<<endl;
	logout<<"Line "<<yylineno<<": "<<s<<endl<<endl;
}
void log(const char *s){
	logout<<s<<endl<<endl;
}

pair<string*, string*>* createPSS(string a, string b){
	return new pair<string*, string*> ({new string(a), new string(b)});
}

vector<SymbolInfo*>* addDeclaration(vector<SymbolInfo*>* prev, SymbolInfo* id, string size){
	id->setSpec(1);
	id->setSize(stoi(size));
	prev->push_back(id);
	return prev;}

void addParamsToScopeTable(){
	int sz = paramList.size();
	// cout<<"\t\tSIZE: "<<sz<<endl;
	for(int i=0; i<sz; i++){
		SymbolInfo* si = new SymbolInfo(paramList[i].first, "ID");
		si->setVarType(paramList[i].second);
		si->setSpec(1);
		si->setSize(0);
		if(table->insert(si)){
			si->setOffset(funcOffset++);
		}else{
			// errorr(("Multiple declaration of "+si->getName()+" in parameter").c_str());
		}
	}
	paramList.clear();
}

vector<SymbolInfo*>* addParameter(vector<SymbolInfo*>* prev, SymbolInfo* id, string specifier, bool flag = true){
	id->setSpec(1);
	// id->setSize(stoi(size));
	id->setVarType(specifier);
	int sz = prev->size();
	for(int i=0; i<sz; i++){
		if((*prev)[i]->getName() == id->getName()){
			errorr(("Multiple declaration of "+id->getName()+" in parameter").c_str());
			// return prev;
		}
	}
	prev->push_back(id);
	paramList.push_back({id->getName(), specifier});
	// printVVector(*prev);
	return prev;}

string getParamList(vector<SymbolInfo*> v){
	string builder = "";
	int sz = v.size();
	for(int i=0; i<sz; i++){
		builder += v[i]->getVarType() + " " + v[i]->getName();
		if(i != sz - 1) builder += ",";
	}
	return builder;
}
string* createFunctionDeclaration(string specifier, string funName, vector<SymbolInfo*> v){
	string builder = specifier + " " + funName + "(";
	int sz = v.size();
	for(int i=0; i<sz; i++){
		builder += v[i]->getVarType() + " " + v[i]->getName();
		if(i != sz - 1) builder += ",";
	}
	builder += ");\n";
	return new string(builder);
}

void normalize(string &a, string &b){
	if(a == "CONST_INT") a = "int";
	if(b == "CONST_INT") b = "int";
	if(a == "CONST_FLOAT") a = "float";
	if(b == "CONST_FLOAT") b = "float";
	if(a == "VOID") a = "void";
	if(b == "VOID") b = "void";
}

string getHigherType(string a, string b){
	normalize(a, b);
	if(a == b) return a;
	if(a == "null" || b == "null") return "null";
	if(a == "void" || b == "void") {
		// errorr("Void function used in expression");
		return "void";
	}
	return "float";
}

void printPSS(pair<string*, string*> pss){
	// cout<<*(pss.first)<<" ("<<*(pss.second)<<")"<<endl;
	// log((*(pss.first)).c_str());
}

string getStringFromDeclarationList(vector<SymbolInfo*> v){
	string builder;
	int sz = v.size();
	for(int i=0; i<sz; i++){
		builder+=v[i]->getName();
		if(v[i]->getSize() != 0) builder+= "["+to_string(v[i]->getSize())+"]";
		if(i != sz - 1) builder += ",";
	}
	return builder;
}


string* createVarDeclaration(string t, vector<SymbolInfo*> v){
	string builder = t+" ";
	builder += getStringFromDeclarationList(v);
	builder+=";";
	return new string(builder);
}


void printVPSS(vector<pair<string*, string*>*> vpss){
	int sz = vpss.size();
	for(int i=0; i<sz; i++){
		printPSS(*vpss[i]);
	}
}

string getStringFromArguments(vector<pair<string*, string*>*> vpss){
	int sz = vpss.size();
	string s = "";
	for(int i=0; i<sz; i++){
		s += *(vpss[i]->first);
		if(i != sz - 1) s+=",";
	}
	return s;
}

vector<pair<string*, string*>*>* addLogicalExpression(vector<pair<string*, string*>*>* vpss, pair<string*, string*>* pss){
	vpss->push_back(pss);
	return vpss;
}

string getStringFromArgumentList(vector<pair<string*, string*>*> vpss){
	string builder = "";
	int sz = vpss.size();
	for(int i=0; i<sz; i++){
		builder += *(vpss[i]->first);
		if(i != sz-1) builder += ",";
	}
	for(int i=sz-1; i>=0; i--){

	}
	return builder;
}
int levelCount = 0;
string getNextLevel(){
	return "L_"+to_string(levelCount++);
}

void insertToSymbolTable(string type, vector<SymbolInfo*> v){
	if(type == "void" || type == "VOID"){
		errorr("Variable type cannot be void");
	}
	int sz = v.size();
	for(int i=0; i<sz; i++){
		v[i]->setVarType(type);
		if(table->insert(v[i])){
			if(table->getCurrentScope() == "1"){
				dseg<<"\t"<<v[i]->getName()<<"\tDW\t"<<v[i]->getSize()<<(v[i]->getSize() == 0 ? "" : "\tDUP(0)")<<endl;
			}
			else {
				if(v[i]->getSize() == 0) cseg<<"PUSH 0 ; var declared: "<<v[i]->getName()<<" offset: "<<v[i]->getOffset()<<endl;
				else{
					string l1 = getNextLevel();
					string l2 = getNextLevel();
					cseg<<"; var declared: "<<v[i]->getName()<<"["<<v[i]->getSize()<<"]; offset: "<<v[i]->getOffset()<<endl;
					cseg<<"MOV CX, "<<v[i]->getSize()<<endl;
					cseg<<"@"<<l1<<":"<<endl;
					cseg<<"JCXZ @"<<l2<<endl;
					cseg<<"PUSH 0"<<endl;
					cseg<<"DEC CX"<<endl;
					cseg<<"JMP @"<<l1<<endl;
					cseg<<"@"<<l2<<":"<<endl<<endl;
				}
			}
			v[i]->setOffset(funcOffset);
			funcOffset+=max(1, v[i]->getSize());
		}else{
			errorr(("Multiple declaration of "+v[i]->getName()).c_str());
		}
	}
}

bool matchParameterSignature(vector<SymbolInfo*>* v1, vector<SymbolInfo*>* v2, string funcName){
	if(v1 == nullptr && v2 == nullptr) {
		return true;
	}
	if(v1 == nullptr) return false;
	if(v2 == nullptr) return false;
	if(v1->size() != v2->size()) {
		errorr(("Total number of arguments mismatch with declaration in function "+funcName).c_str());
		return false;
	}
	int sz = v1->size();
	for(int i=0; i<sz; i++){
		if((*v1)[i]->getVarType() != (*v2)[i]->getVarType()) {
			errout<<"Error at line "<<yylineno<<": ";
			errout<<(i+1)<<"th parameter's type specifier mismatched in function defintion of "<<funcName<<endl;
			return false;
		}
	}
	return true;
}

string getIdVarType(string name){
	SymbolInfo* si = table->lookUp(name);
	if(si == nullptr) return "null";
	return si->getVarType();
}

void insertFunctionIdToSymbolTable(SymbolInfo* si, string specifier, bool isDefined, vector<SymbolInfo*>* v){
	SymbolInfo* found = table->lookUp(si->getName());
	si->setSpec(2);
	si->setSize(isDefined);
	si->setVarType(specifier);
	si->setParams(v);
	if(found == nullptr){
		table->insert(si);
		return;
	}
	if(found->getSpec() != 2){
		errorr(("Multiple declaration of "+si->getName()).c_str());
		return;
	}
	if(found->getSize()){
		errorr(("Multiple definition of "+si->getName()).c_str());
		return;
	}
	if(!isDefined){
		errorr(("Multiple declaration of "+si->getName()).c_str());
	}else {
		if(found->getVarType() != si->getVarType()){
			errorr(("Return type mismatch with function declaration in function "+si->getName()).c_str());
			return;
		}
		if(!matchParameterSignature(si->getParams(), found->getParams(), si->getName())){
			// errorr("Declaration and Definition parameter signature mismatched!");
			// errorr((si->getName()).c_str());
			return;
		}
		table->remove(si->getName());
		table->insert(si);
		return;
	}
	table->insert(si);
	return;
}

void validateAndCreateFactor(SymbolInfo* si, vector<pair<string*, string*>*> v){
	SymbolInfo* found = table->lookUp(si->getName());
	if(found == nullptr){
		errorr(("Undeclared function "+si->getName()).c_str());
	}else if(found->getSpec() != 2){
		errorr((found->getName() + " is not a function").c_str());
	}else if(found->getParams()->size() != v.size()){
		// cout<<found->getParams()->size()<<endl;
		// cout<<v.size()<<endl;
		errorr(("Total number of arguments mismatch in function "+found->getName()).c_str());
	}else if(found->getVarType() == "void" || found->getVarType() == "VOID"){
		// errorr("Void function used in expression");
	}else{
		int sz = v.size();
		vector<SymbolInfo*> v2= *( found->getParams());
		for(int i=0; i<sz; i++){
			string t1 = *(v[i]->second);
			string t2 = v2[i]->getVarType();
			normalize(t1, t2);
			if(t1 != t2) {
				if(t1 == "int" && t2 == "float") continue;
				string er = to_string(i+1)+"th argument mismatch in function "+found->getName();
				errorr(er.c_str());
			}
		}
	}
}

string checkAndValidateID(string idName, string exp, string expType){
	SymbolInfo* found = table->lookUp(idName);
	if(found == nullptr){
		errorr(("Undeclared variable "+idName).c_str());
		return "VOID";
	}
	string scope = found->getScope();
	if(found->getSpec() == 2){
		errorr("NOT A VARIABLE!");
		return found->getVarType();
	}
	if(found->getSize() == 0){
		if(expType == "NOT_ARRAY") {
			cout<<"NOT ARRAY"<<endl;
			if(scope != "1") cseg<<"MOV BX, [BP - "<<(10+found->getOffset()*2)<<"] ; loaded "<<found->getName()<<endl;
			else cseg<<"MOV BX, ["<<found->getName()<<"] ; loaded "<<found->getName()<<endl; 
			cseg<<"PUSH BX ;stored in stack"<<endl;
			isLastIdArray = false;
			return found->getVarType();
		}
		errorr((idName+" not an array").c_str());
		return found->getVarType();
	}
	if(expType == "NOT_ARRAY"){
		errorr(("Type mismatch, "+idName+" is an array").c_str());
		return found->getVarType();
	}
	if(expType != "CONST_INT" && expType != "int") {
		errorr("Expression inside third brackets not an integer");
		return found->getVarType();
	}
	if(expType == "int") {
		cout<<"int"<<endl;
		cseg<<"MOV BX, [BP - "<<(10+found->getOffset()*2)<<"] ; loaded "<<found->getName()<<endl;
		cseg<<"PUSH BX ;stored in stack"<<endl;
		return found->getVarType();
	}
	int index;
	sscanf(exp.c_str(), "%d", &index);
	if(index < 0) errorr("Expression inside third brackets cannot be negative");
	if(index >= found->getSize()) errorr("array index out of bound");
	cout<<"Baire"<<endl;
	cseg<<"POP BX; index loaded"<<endl;
	cseg<<"SHL BX, 1; index *= 2"<<endl;
	if(scope != "1"){
		cseg<<"NEG BX   ; index = -index"<<endl;
		cseg<<"ADD BX, -"<<(found->getOffset()*2+10)<<endl;
		cseg<<"ADD BX, BP"<<endl;
		cseg<<"PUSH [BX]"<<endl;
	}else {
		cseg<<"PUSH "<<found->getName()<<"[BX]"<<endl;
	}
	isLastIdArray = true;
	cseg<<"PUSH BX"<<endl;
	return found->getVarType();
}

void checkAndValidAssign(string a, string b){
	normalize(a, b);
	// warning((a+", "+b).c_str());
	warning((a+' '+b).c_str());
	if(a == "void") {
		// errorr("CANNOT ASSIGN TO VOID!");
		return;
	}
	if(b == "void"){
		errorr("Void function used in expression");
		return;
	}
	if(a != b){
		// warning(("Trying to assign "+b+" in "+a+" (potential precision loss)").c_str());
		if(a == "float" && b == "int") return;
		if(b == "null") return;
		errorr("Type Mismatch");
	}
}

string getReturnType(string a, string b){
	warning((a+' '+b).c_str());
	normalize(a, b);
	if(a == b) return a;
	if(a == "null" && b != "null") return b;
	if(a != "null" && b == "null") return a;
	warning("MULTIPLE RETURN STATEMENT WITH DIFFERENT RETURN TYPE!");
	return a;
}

void chekAndValidateFunctionSignature(string a, string b){
	if(b == "null") b = "void";
	normalize(a, b);
	if(a != "void" && b == "void"){
		errorr("Type mismatch, function is not void", false);
		return;
	} 
	if(a == "void" && b!= "void"){
		errorr("Type mismatch, function is void"), false;
		return;
	}
	if(a != b){
		if(a == "float" && b == "int") return;
		errorr("Type mismatch, int function is returning float", false);
	}
}

void checkMulOp(string t1, string op, string t2, string s2){
	// if(op != "%") return;
	normalize(t1, t2);
	if(op == "%"){
		if(t1 != "int" || t2 != "int") errorr("Non-Integer operand on modulus operator");
		if(s2 == "0") errorr("Modulus by Zero");
	}else if(op == "/"){
		if(s2 == "0" || s2 == "0.0") errorr("Divided by zero");
	}
}

void checkLogicAndRelExpression(string a, string b){
	normalize(a, b);
	if(a == "void") errorr("void expression in logical or relational operation");
	else if(b == "void") errorr("void expression in logical or relational operation");
}

// string getStringFromDeclarationList(vector<SymbolInfo*> vs){
// 	int sz = vs.size();
// 	string s = "";
// 	for(int i=0; i<sz; i++){

// 	}
// }
void deleteMe(string* s){
	if(s != nullptr) delete s;
}
void deleteMe(pair<string*, string*>* pss){
	if(pss == nullptr) return;
	if(pss->first != nullptr) delete pss->first;
	if(pss->second != nullptr) delete pss->second;
	delete pss;
}
void deleteMe(vector<pair<string*, string*>*>* vss){
	if(vss == nullptr) return;
	int sz = vss->size();
	for(int i=0; i<sz; i++){
		deleteMe((*(vss))[i]);
	}
	delete vss;
}
void deleteMe(vector<SymbolInfo*>* vsi){
	if(vsi == nullptr) return;
	int sz = vsi->size();
	for(int i=0; i<sz; i++){
		delete ((*(vsi))[i]);
	}
	delete vsi;
}
void deleteMe(SymbolInfo* si){
	if(si != nullptr)delete si;
}

void initProc(string functionName){
	funcOffset = 0;
	cseg<<functionName<<" PROC"<<endl<<endl;
	if(functionName == "main") {
		cseg<<"MOV AX, @DATA"<<endl;
		cseg<<"MOV DS, AX"<<endl;
		cseg<<"; data segment loaded"<<endl<<endl;
		return;
	}
	cseg<<"; preserving sp(in BP), ax, bx, cx, flags"<<endl;
	cseg<<"PUSH BP"<<endl;
	cseg<<"MOV BP, SP"<<endl<<endl;
	cseg<<"PUSH AX"<<endl;
	cseg<<"PUSH BX"<<endl;
	cseg<<"PUSH CX"<<endl;
	cseg<<"PUSHF"<<endl;
	cseg<<"; function definition here"<<endl<<endl;
}

string functionReturnLabel;
void terminateProc(string functionName){
	if(functionName == "main") {
		cseg<<endl;
		cseg<<"@"<<functionReturnLabel<<":"<<endl;
		cseg<<"MOV AH, 4CH"<<endl;
		cseg<<"INT 21H"<<endl;
		cseg<<functionName<<" ENDP"<<endl<<endl;
		return;
	}
	cseg<<";terminating function"<<endl;
	cseg<<"@"<<functionReturnLabel<<":"<<endl;
	cseg<<"MOV SP, BP"<<endl;
	cseg<<"SUB SP, 8"<<endl;
	cseg<<"POPF"<<endl;
	cseg<<"POP CX"<<endl;
	cseg<<"POP BX"<<endl;
	cseg<<"POP AX"<<endl;
	cseg<<"POP BP"<<endl<<endl;
	cseg<<functionName<<" ENDP"<<endl<<endl;
}

void incDecOp(string s1, string s2, string incOrDec){
	cout<<s1<<" : "<<s2<<endl;
	SymbolInfo* si = table->lookUp(s1);
	if(si != nullptr){
		// cout<<"ID: "<<endl;
		cseg<<"POP AX"<<endl;
		cseg<<"PUSH AX"<<endl;
		cseg<<incOrDec<<"AX"<<endl;
		cseg<<"MOV [BP + -"<<(si->getOffset()*2+10)<<"], AX"<<endl;
	}else {
		// cout<<"ARA"<<endl;
		cseg<<"POP BX"<<endl;
		cseg<<"POP AX"<<endl;
		cseg<<"PUSH AX"<<endl;
		cseg<<incOrDec<<"AX"<<endl;
		cseg<<"MOV [BX], AX"<<endl;
	}
}

void addPreDefinedFunctions(){
	ifstream funcs("1805090_util.asm");
	for(string line; getline(funcs, line);){
        pseg<<line<<endl;
    }
}

void multiply(){
	cseg<<"; MULTIPLICATION STARTS"<<endl;
	cseg<<"POP BX"<<endl;
	cseg<<"MOV CX, BX"<<endl;
	cseg<<"POP AX"<<endl;
	cseg<<"IMUL CX"<<endl;
	cseg<<"MOV BX, AX"<<endl;
	cseg<<"PUSH BX"<<endl;
	cseg<<"; MULTIPLICATION ENDS"<<endl;
}

void divide(){
	cseg<<"; DIVISION STARTS"<<endl;
	cseg<<"POP BX"<<endl;
	cseg<<"MOV CX, BX"<<endl;
	cseg<<"XOR DX, DX"<<endl;
	cseg<<"POP AX"<<endl;
	cseg<<"IDIV CX"<<endl;
	cseg<<"MOV BX, AX"<<endl;
	cseg<<"PUSH BX"<<endl;
	cseg<<"; DIVISION ENDS"<<endl;
}

void mod(){
	cseg<<"; MOD STARTS"<<endl;
	cseg<<"POP BX"<<endl;
	cseg<<"MOV CX, BX"<<endl;
	cseg<<"XOR DX, DX"<<endl;
	cseg<<"POP AX"<<endl;
	cseg<<"IDIV CX"<<endl;
	cseg<<"MOV BX, DX"<<endl;
	cseg<<"PUSH BX"<<endl;
	cseg<<"; MOD ENDS"<<endl;
}
void checkArray(){
	if(isLastIdArray){
		cseg<<"POP BX; eita kokhon kora lagbe janina!"<<endl;
	}
	isLastIdArray = false;
}

//UTILS



%}

%union {
	SymbolInfo* si;
	vector<SymbolInfo*>* vvector;	
	string* sstring;
	pair<string*, string*>* pss;
	vector<pair<string*, string*>*>* vss;}
%token INCOP DECOP PRINTLN IF ELSE FOR WHILE DO BREAK INT CHAR FLOAT DOUBLE VOID RETURN SWITCH CASE DEFAULT CONTINUE NOT LPAREN RPAREN LCURL RCURL LTHIRD RTHIRD COMMA SEMICOLON
%token <si> CONST_INT CONST_FLOAT CONST_CHAR ID ADDOP MULOP RELOP ASSIGNOP LOGICOP STRING UNCHAR
%type <vvector> declaration_list parameter_list
%type <sstring> type_specifier var_declaration func_declaration
%type <pss> expression_statement factor variable expression logic_expression rel_expression simple_expression term unary_expression
%type <vss> arguments argument_list
%type <pss> statement compound_statement statements func_definition unit program start
// %left 
// %right

%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE

%%

start : program {
		print("start : program");
		$$ = $1;
		table->printAll(logout);
		logout<<"Total lines: "<<yylineno<<endl;
		logout<<"Total errors: "<<errorno<<endl<<endl;
		deleteMe($$);
		// cout<<*($$->first)<<endl;
		// log((*($$->first) ).c_str());
		// cout<<"eikhane ken ashe?"<<endl;
		//write your code in this block in all the similar blocks below
	}
	;

program : program unit {
		print("program : program unit");
		string fst = (*($1->first)+*($2->first));
		$$ = createPSS(fst, "null");
		log((*($$->first)).c_str());
		// cout<<*$$<<endl;
		deleteMe($1);
		deleteMe($2);
	}
	| unit {
		print("program : unit");
		$$ = $1;
		log((*($$->first)).c_str());
		// cout<<*$$<<endl;
	}
	;
	
unit : var_declaration {
		print("unit : var_declaration");
		$$ = createPSS(*($1) + "\n", "null");
		log((*($$->first) ).c_str());
		deleteMe($1);
	}
	| func_declaration {
		print("unit : func_declaration");
		$$ = createPSS(*($1), "null");
		paramList.clear();
		log((*($$->first)).c_str());
		deleteMe($1);
	} 
	| func_definition {
		print("unit : func_definition");
		$$ = createPSS((*($1)->first+"\n"), "null");
		log((*($$->first)).c_str());
		deleteMe($1);
	}
	;

func_declaration : type_specifier ID LPAREN parameter_list RPAREN SEMICOLON {
		print("func_declaration : type_specifier ID LPAREN parameter_list RPAREN SEMICOLON");
		insertFunctionIdToSymbolTable($2, *$1, false, $4);
		$$ = createFunctionDeclaration(*$1, $2->getName(), *$4);
		// cout<<(*$$)<<endl;
		table->enterScope(); table->exitScope();
		log((*$$).c_str());
		deleteMe($1);
	}
	| type_specifier ID LPAREN RPAREN SEMICOLON {
		print("func_declaration : type_specifier ID LPAREN RPAREN SEMICOLON");
		insertFunctionIdToSymbolTable($2, *$1, false, new vector<SymbolInfo*>);
		$$ = new string((*$1) + " " + ($2->getName()) + "();\n");
		// cout<<(*$$)<<endl;
		table->enterScope(); table->exitScope();
		log((*$$ ).c_str());
		deleteMe($1);
	}
	;

func_definition : type_specifier ID LPAREN parameter_list RPAREN {
			initProc(($2->getName()));
			insertFunctionIdToSymbolTable($2, *$1, true, $4);
			functionReturnLabel = getNextLevel();
		} compound_statement {
		print("func_definition : type_specifier ID LPAREN parameter_list RPAREN compound_statement");
		// insertFunctionIdToSymbolTable($2, *$1, true, $4);
		warning((*($7->second)+", " + *($1)).c_str());
		chekAndValidateFunctionSignature(*($1), *($7->second));
		$$ = createPSS((*$1 + " " + $2->getName() + "(" + getParamList(*$4) +")" + *($7->first)), *($7->second));
		string s = *($$->first); 
		warning(s.c_str());
		log((*($$->first) ).c_str());
		deleteMe($1);
		terminateProc(($2->getName()));
	}
	|  type_specifier ID LPAREN error RPAREN {
			// initProc(($2->getName()));
			insertFunctionIdToSymbolTable($2, *$1, true, new vector<SymbolInfo*>);
		} compound_statement {
		print("func_definition : type_specifier ID LPAREN error RPAREN compound_statement");
		// insertFunctionIdToSymbolTable($2, *$1, true, $4);
		warning((*($7->second)+", " + *($1)).c_str());
		chekAndValidateFunctionSignature(*($1), *($7->second));
		$$ = createPSS((*$1 + " " + $2->getName() + "(" + getParamList(*(new vector<SymbolInfo*>)) +")" + *($7->first)), *($7->second));
		string s = *($$->first); 
		warning(s.c_str());
		log((*($$->first) ).c_str());
		deleteMe($1);
		terminateProc(($2->getName()));
	}	
	| type_specifier ID LPAREN RPAREN {
			initProc(($2->getName()));
			insertFunctionIdToSymbolTable($2, *$1, true, new vector<SymbolInfo*>);
			functionReturnLabel = getNextLevel();
		} compound_statement {
		// errorr("eikhane ekhane!");
		print("func_definition : type_specifier ID LPAREN RPAREN compound_statement");
		string fst = *$1 + " " + $2->getName() + "()" + *($6->first);
		chekAndValidateFunctionSignature(*($1), *($6->second));
		$$ = createPSS(fst, *($6->second));
		warning((*($6->second)+", " + *($1)).c_str());
		// log((*($$->first)).c_str());
		log((*($$->first) ).c_str());
		deleteMe($1);
		terminateProc(($2->getName()));
		// cout<<*$$<<endl;
	}
	;				

parameter_list  : parameter_list COMMA type_specifier ID {
		print("parameter_list : parameter_list COMMA type_specifier ID");
		$$ = addParameter($1, $4, *$3);
		log(getParamList(*$$).c_str());
		deleteMe($3);
	}
	| parameter_list COMMA type_specifier {
		print("parameter_list : parameter_list COMMA type_specifier");
		$$ = addParameter($1, new SymbolInfo("", *$3), *$3);
		log(getParamList(*$$).c_str());
		deleteMe($3);
	}
	| type_specifier ID {
		print("parameter_list : type_specifier ID");
		$$ = addParameter(new vector<SymbolInfo*>, $2, *$1);
		log(getParamList(*$$).c_str());
		deleteMe($1);
	}
	| type_specifier error {
		errorr("Syntax error");
		print("parameter_list : type_specifier error");
		$$ = addParameter(new vector<SymbolInfo*>, new SymbolInfo("XX", (*$1)), *$1);
		// log((*($$->first)).c_str());
		log(getParamList(*$$).c_str());
	}
	| type_specifier {
		print("parameter_list : type_specifier");
		$$ = addParameter(new vector<SymbolInfo*>, new SymbolInfo("", (*$1)), *$1);
		// log((*($$->first)).c_str());
		log(getParamList(*$$).c_str());
		deleteMe($1);
	}
	;

compound_statement : LCURL {table->enterScope(); addParamsToScopeTable();} statements RCURL {
		print("compound_statement : LCURL statements RCURL");
		// $$ = new string("{\n"+*($3)+"\n}");
		// cout<<*$$<<endl;
		$$ = createPSS(("{\n"+*($3->first)+"}\n").c_str(), *($3->second));
		log((*($$->first)).c_str());
		table->printAll(logout);
		table->exitScope();
		deleteMe($3);
		// log((*($$->first)).c_str());
	}
	| LCURL RCURL {
		print("compound_statement : LCURL RCURL");
		$$ = createPSS("{}\n", "void");
		table->enterScope(); 
		log((*($$->first)).c_str());
		table->printAll(logout);
		table->exitScope();
		// log((*($$->first)).c_str());
	}
	;

var_declaration : type_specifier declaration_list SEMICOLON {
		print("var_declaration : type_specifier declaration_list SEMICOLON");
		$$ = createVarDeclaration(*$1, *$2);
		insertToSymbolTable(*$1, *$2);
		// cout<<(*$$)<<endl;
		log((*$$).c_str());
		deleteMe($1);
	}
	| error declaration_list SEMICOLON {
		print("var_declaration : type_specifier declaration_list SEMICOLON");
		$$ = createVarDeclaration("null", *$2);
		insertToSymbolTable("null", *$2);
		errorr("type_specifier not specified");
		// cout<<(*$$)<<endl;
		log((*$$).c_str());
	}
	| error declaration_list error {
		print("var_declaration : type_specifier declaration_list SEMICOLON");
		$$ = createVarDeclaration("void", *$2);
		insertToSymbolTable("void", *$2);
		errorr("type_specifier not specified, missing semicolon");
		// cout<<(*$$)<<endl;
		log((*$$).c_str());
	}
	| type_specifier declaration_list error {
		print("var_declaration : type_specifier declaration_list SEMICOLON");
		$$ = createVarDeclaration(*$1, *$2);
		insertToSymbolTable(*$1, *$2);
		errorr("missing semicolon");
		log((*$$).c_str());
		deleteMe($1);
		// cout<<(*$$)<<endl;
	} 
	;

type_specifier	: INT {print("type_specifier : INT"); $$ = new string("int"); log("int");}
	| FLOAT {print("type_specifier : FLOAT"); $$ = new string("float"); log("float");}
	| VOID {print("type_specifier : VOID"); $$ = new string("void"); log("void");}
	;

declaration_list : declaration_list COMMA ID {
		print("declaration_list : declaration_list COMMA ID");
		$$ = addDeclaration($1, $3, "0");
		log(getStringFromDeclarationList(*$$).c_str());
	}
	| declaration_list ADDOP ID {
		errorr("Syntax error, ADDOP used instead of semicolon");
		print("declaration_list : declaration_list COMMA ID");
		$$ = addDeclaration($1, $3, "0");
		log(getStringFromDeclarationList(*$$).c_str());
	}
	| declaration_list COMMA ID LTHIRD CONST_INT RTHIRD {
		print("declaration_list : declaration_list COMMA ID LTHIRD CONST_INT RTHIRD");
		$$ = addDeclaration($1, $3, $5->getName());	
		log(getStringFromDeclarationList(*$$).c_str());
		deleteMe($5);
	}
	| declaration_list COMMA ID LTHIRD RTHIRD {
		print("declaration_list : declaration_list COMMA ID LTHIRD RTHIRD");
		errorr("Syntax error, no expresison inside third third brackets");
		$$ = addDeclaration($1, $3, "1");	
		log(getStringFromDeclarationList(*$$).c_str());
	}
	| ID {	
		print("declaration_list : ID");
		$$ = addDeclaration(new vector<SymbolInfo*>, $1, "0");
		log(getStringFromDeclarationList(*$$).c_str());
	}
	| ID LTHIRD CONST_INT RTHIRD {	
		print("declaration_list : ID LTHIRD CONST_INT RTHIRD");
		$$ = addDeclaration(new vector<SymbolInfo*>, $1, $3->getName());
		log(getStringFromDeclarationList(*$$).c_str());
		deleteMe($3);
	} 
	| ID LTHIRD RTHIRD {	
		print("declaration_list : ID LTHIRD RTHIRD");
		errorr("Syntax error, no expresison inside third third brackets");
		$$ = addDeclaration(new vector<SymbolInfo*>, $1, "1");
		log(getStringFromDeclarationList(*$$).c_str());
	} 
	;

statements : statement {
		print("statements : statement");
		$$ = createPSS(*($1->first), *($1->second));
		// cout<<'\t'<<(*$$)<<endl;
		// log((*($$->first)).c_str());
		log((*($$->first)).c_str());
		deleteMe($1);
	}
	| statements statement {
		print("statements : statements statement");
		string type = getReturnType(*($1->second), *($2->second));
		$$ = createPSS(*($1->first)+*($2->first), type);
		// cout<<(*$$)<<endl;
		// log((*($$->first)).c_str());
		log((*($$->first)).c_str());
		deleteMe($1);
		deleteMe($2);
	}
	;

statement : var_declaration {
		print("statement : var_declaration");
		$$ = createPSS(*$1+"\n", "null");
		log((*($$->first)).c_str());
		deleteMe($1);
	}
	| expression_statement {
		print("statement : expression_statement");
		$$ = createPSS(*($1->first) + "\n", "null");
		log((*($$->first)).c_str());
		deleteMe($1);
	}
	| compound_statement {
		print("statement : compound_statement");
		// $$ = createPSS(*$1, *($1-.second));
		// $$ = createPSS(*($1->first), *($1->second));
		$$ = $1;
		log((*($$->first)).c_str());
	}
	| FOR LPAREN expression_statement expression_statement expression RPAREN statement {
		print("statement : FOR LPAREN expression_statement expression_statement expression RPAREN statement");
		string s = "for(" + *($3->first) + *($4->first)  + *($5->first) + ")" + *($7->first) ; 
		$$ = createPSS(s, *($7->second));
		log((*($$->first)).c_str());
		deleteMe($3);
		deleteMe($4);
		deleteMe($5);
		deleteMe($7);
	}
	| IF LPAREN expression RPAREN statement %prec LOWER_THAN_ELSE {
		print("statement : IF LPAREN expression RPAREN statement");
		string s = "if (" + *($3->first) +")" + *($5->first);
		$$ = createPSS(s, *($5->second));
		log((*($$->first)).c_str());
		deleteMe($3);
		deleteMe($5);
	}
	| IF LPAREN expression RPAREN statement ELSE statement {
		print("statement : IF LPAREN expression RPAREN statement ELSE statement");
		string s = "if ("+*($3->first)+")"+*($5->first) + "else\n"+ *($7->first) ;
		string t1 = *($5->second);
		string t2 = *($7->second);
		normalize(t1, t2);
		string type = t1;
		if(t1 != t2){
			errorr("Return type mismatched in if statement else statement");
			if(t1 == "void") type = t2;
			if(t2 == "void") type = t1;
		}
		$$ = createPSS(s, type);
		log((*($$->first)).c_str());
		deleteMe($3);
		deleteMe($5);
		deleteMe($7);
	}
	| WHILE LPAREN expression RPAREN statement {
		print("statement : WHILE LPAREN expression RPAREN statement");
		$$ = createPSS("while ("+*($3->first)+")"+*($5->first), "null");
		log((*($$->first)).c_str());
		deleteMe($3);
		deleteMe($5);
	}
	| PRINTLN LPAREN ID RPAREN SEMICOLON {
		print("statement : PRINTLN LPAREN ID RPAREN SEMICOLON");
		SymbolInfo *si = table->lookUp($3->getName());
		if(si == nullptr){
			string s = "Undeclared variable "+$3->getName();
			errorr(s.c_str());
		}
		$$ = createPSS("printf("+$3->getName()+");\n", "null");
		log((*($$->first)).c_str());
		cseg<<"MOV BX, [BP - "<<(si->getOffset()*2+10)<<"]"<<endl;
		cseg<<"PUSH BX"<<endl;
		cseg<<"CALL PRINT_DECIMAL_INTEGER"<<endl;
		deleteMe($3);
	}
	| RETURN expression SEMICOLON {
		print("statement : RETURN expression SEMICOLON");
		$$ = createPSS("return "+*($2->first)+";\n", *($2->second));
		log((*($$->first)).c_str());
		cseg<<"POP BX"<<endl;
		cseg<<"MOV DX, BX"<<endl;
		cseg<<"JMP @"<<functionReturnLabel<<endl;
		deleteMe($2);
	}
;

expression_statement : SEMICOLON	{
		print("expression_statement : SEMICOLON");
		$$ = createPSS(";", "VOID");
		log((*($$->first)).c_str());
	}		
	| expression SEMICOLON {
		print("expression_statement : expression SEMICOLON");
		$$ = createPSS (*($1->first) + ";", *($1->second));
		log((*($$->first)).c_str());
		cseg<<"POP BX; ";
		cseg<<(*($$->first)).c_str()<<endl<<endl;
		deleteMe($1);
	}
	| expression error{
		errorr("Syntax error, semicolon missing.");
		print("expression_statement : expression");
		$$ = createPSS (*($1->first) + ";", *($1->second));
		log((*($$->first)).c_str());
		deleteMe($1);
	}
;

variable : ID 	{
		print("variable : ID");
		string type = checkAndValidateID($1->getName(), "0", "NOT_ARRAY");
		$$ = createPSS ($1->getName(), type);
		log((*($$->first)).c_str());
	}
	| ID LTHIRD expression RTHIRD {
		print("variable : ID LTHIRD expression RTHIRD");
		string type = checkAndValidateID($1->getName(), *($3->first), *($3->second));
		$$ = createPSS ($1->getName() + "[" + *($3->first) + "]", type);
		log((*($$->first)).c_str());
		deleteMe($1);deleteMe($3);
	}
	| ID LTHIRD RTHIRD {
		print("variable : ID LTHIRD RTHIRD");
		errorr("Syntax error, no expression inside third bracekts");
		string type = checkAndValidateID($1->getName(), "0", "CONST_INT");
		$$ = createPSS ($1->getName() + "[]", type);
		log((*($$->first)).c_str());
		deleteMe($1);
	}
;

expression : logic_expression {
		print("expression : logic_expression");
		$$ = createPSS(*($1->first) , *($1->second));
		log((*($$->first)).c_str());
	}
	| variable ASSIGNOP {
		//assignRight = true;
		}
		logic_expression {
		// cout<<"\t\t\t\teikhane keno ashe?"<<endl;
		//TODO eikhane onek kahini kora lagbe 
		print("expression : variable ASSIGNOP logic_expression");
		checkAndValidAssign(*($1->second), *($4->second));
		$$ = createPSS (*($1->first) + "=" + *($4->first), *($1->second));
		log((*($$->first)).c_str());
		cseg<<endl;
		cseg<<"POP AX"<<endl;
		SymbolInfo *si = table->lookUp(*($1->first));
		if(si != nullptr){
			// cseg<<";var a assign!"<<endl;
			cseg<<"MOV [BP + -"<<(si->getOffset()*2+10)<<"], AX"<<endl;
		}else{
			// cseg<<";array te assign!"<<endl;
			cseg<<"POP BX"<<endl;
			cseg<<"POP DX; eita keno korbe janina"<<endl;
			cseg<<"MOV [BX], AX"<<endl;
		}
		cseg<<"MOV BX, AX"<<endl;
		cseg<<"PUSH BX"<<endl;
		cseg<<endl;
		deleteMe($1);deleteMe($4);
	} 
	| error ASSIGNOP logic_expression {
		errorr("Syntax error");
		$$ = createPSS("", "null");
	}
;

logic_expression : rel_expression {
		print("logic_expression : rel_expression");
		$$ = $1;
		log((*($$->first)).c_str());
	}
	| rel_expression LOGICOP rel_expression {
		print("logic_expression : rel_expression LOGICOP rel_expression");
		checkLogicAndRelExpression(*($1->second), *($3->second));
		$$ = createPSS (*($1->first) + $2->getName() + *($3->first), "int");
		log((*($$->first)).c_str());
		deleteMe($1);deleteMe($2);deleteMe($3);
	} 	
;

rel_expression	: simple_expression {
		print("rel_expression : simple_expression");
		$$ = $1;
		log((*($$->first)).c_str());
	}
	| simple_expression RELOP simple_expression	{
		print("rel_expression : simple_expression RELOP simple_expression");
		checkLogicAndRelExpression(*($1->second), *($3->second));
		$$ = createPSS (*($1->first) + $2->getName() + *($3->first), "int");
		log((*($$->first)).c_str());
		string nextLabel = getNextLevel();
		string op = $2->getName();
		
		cseg<<"POP BX"<<endl;
		cseg<<"POP AX"<<endl;
		cseg<<"CMP AX, BX"<<endl;
		cseg<<"MOV BX, 1"<<endl;
		if(op == "<") cseg<<"JL";
		if(op == ">") cseg<<"JG";
		if(op == "==") cseg<<"JE";
		if(op == "!=") cseg<<"JNE";
		if(op == ">=") cseg<<"JGE";
		if(op == "<=") cseg<<"JLE";
		cseg<<" @"<<nextLabel<<endl;
		cseg<<"MOV BX, 0"<<endl;
		cseg<<"@"<<nextLabel<<": "<<endl;
		cseg<<"PUSH BX"<<endl<<endl;
		deleteMe($1);deleteMe($3);
	}
;

simple_expression : term {
		print("simple_expression : term");
		$$ = $1;
		log((*($$->first)).c_str());
	}
	| simple_expression ADDOP term {
		print("simple_expression : simple_expression ADDOP term");
		$$ = createPSS(*($1->first) + $2->getName() + *($3->first), getHigherType(*($1->second), *($3->second)));
		log((*($$->first)).c_str());
		cseg<<endl;
		
		cseg<<"POP BX"<<endl;
		cseg<<"POP AX"<<endl;
		if($2->getName() == "+"){
			cseg<<"ADD BX, AX"<<endl;
		}else {
			cseg<<"SUB AX, BX"<<endl;
			cseg<<"MOV BX, AX"<<endl;
		}
		cseg<<"PUSH BX"<<endl;
		cseg<<endl;
		deleteMe($1);deleteMe($2);deleteMe($3);
	}
;

term :	unary_expression {
		print("term : unary_expression");
		$$ = $1;
		log((*($$->first)).c_str());
	}
	| term MULOP unary_expression {
		print("term : term MULOP unary_expression");
		checkMulOp(*($1->second), $2->getName(), *($3->second), *($3->first));
		string type = $2->getName() == "%" ? "int" : getHigherType(*($1->second), *($3->second));
		$$ = createPSS(*($1->first) + $2->getName() + *($3->first), type);
		log((*($$->first)).c_str());
		
		if($2->getName() == "*") multiply();
		else if($2->getName() == "/") divide();
		else if($2->getName() == "%") mod();
		deleteMe($1);deleteMe($2);deleteMe($3);
	}
;

unary_expression : ADDOP unary_expression {
		print("unary_expression : ADDOP unary_expression");
		$$ = createPSS ($1->getName() + "" +(*($2->first)), *($2->second));
		log((*($$->first)).c_str());
		cseg<<endl;
		
		cseg<<"POP BX"<<endl;
		cseg<<"NEG BX"<<endl;
		cseg<<"PUSH BX"<<endl;
		cseg<<endl;
		deleteMe($1);
		deleteMe($2);
	}
	| NOT unary_expression {
		print("unary_expression : NOT unary_expression");
		$$ = createPSS ("!"+(*($2->first)),"int");
		// log((*($$->first)).c_str());
		log((*($$->first)).c_str());
		string nextLabel = getNextLevel();
		cseg<<endl;
		
		cseg<<"POP BX"<<endl;
		cseg<<"CMP BX, 0"<<endl;
		cseg<<"MOV BX, 0"<<endl;
		cseg<<"JNE @"<<nextLabel<<endl;
		cseg<<"INC BX"<<endl;
		cseg<<"@"<<nextLabel<<":"<<endl;
		cseg<<"PUSH BX"<<endl;
		deleteMe($2);
	}
	| factor {
		print("unary_expression : factor");
		$$ = $1;
		log((*($$->first)).c_str());
	}
;

factor	: variable {
		print("factor : variable");
		$$ = $1;
		log((*($$->first)).c_str());
		checkArray();
		// cout<<"assignOP: "<<assignRight<<endl;
	}
	| ID LPAREN argument_list RPAREN { //TODO TODO
		print("factor : ID LPAREN argument_list RPAREN");
		validateAndCreateFactor($1, *$3);
		$$ = createPSS ($1->getName() + "(" + getStringFromArgumentList(*$3) + ")", getIdVarType($1->getName()));
		log((*($$->first)).c_str());
		deleteMe($1);
		deleteMe($3); 

	}
	| LPAREN expression RPAREN {
		print("factor : LPAREN expression RPAREN");
		$$ = createPSS ("("+*($2->first)+")",*($2->second));
		log((*($$->first)).c_str());
		deleteMe($2);
	}
	| CONST_INT {
		print("factor : CONST_INT");
		$$ = createPSS ($1->getName(),"CONST_INT");
		log((*($$->first)).c_str());
		cseg<<"PUSH "<<($1->getName())<<endl;

		deleteMe($1);
	}
	| CONST_FLOAT {
		print("factor : CONST_FLOAT");
		$$ = createPSS ($1->getName(), "CONST_FLOAT");
		log((*($$->first)).c_str());
		cseg<<"PUSH "<<($1->getName())<<endl;
		deleteMe($1);
	}
	| variable INCOP {
		print("factor : variable INCOP");
		$$ = createPSS (*($1->first) + "++", *($1->second));
		log((*($$->first)).c_str());

		incDecOp(*($1->first), *($1->second), "INC ");

		deleteMe($1);
	}
	| variable DECOP {
		print("factor : variable DECOP");
		$$ = createPSS (*($1->first) + "--", *($1->second));
		log((*($$->first)).c_str());
		incDecOp(*($1->first), *($1->second), "DEC ");
		deleteMe($1);
	}
;

argument_list : arguments {
		print("argument_list : arguments");
		$$ = $1;
		log(getStringFromArguments(*$$).c_str());
	}
	| {
		$$ = new vector<pair<string*, string*>*>;
		log(getStringFromArguments(*$$).c_str());
	}
;

arguments : arguments COMMA logic_expression {
		print("arguments : arguments COMMA logic_expression");
		$$ = addLogicalExpression($1, $3);
		log(getStringFromArguments(*$$).c_str());
	}
	| logic_expression {
		print("arguments : logic_expression");
		$$ = addLogicalExpression(new vector<pair<string*, string*>*>, $1);
		log(getStringFromArguments(*$$).c_str());
	}
;

%%
int main(int argc,char *argv[])
{
	if(argc < 2){
		cout<<"Input file name missing!"<<endl;
		return 0;
	}
	FILE* fp;
	if((fp = fopen(argv[1], "r")) == NULL){
		cout<<"Failed to open file: "<<argv[1]<<endl;
		return 0;
	}
	table = new SymbolTable(7);
	if(argc >= 3) asmout.open(argv[2]);
	else asmout.open("code.asm");
	if(argc == 5){
		errout.open(argv[4]);
		logout.open(argv[3]);
	}else {
		errout.open("error.txt");
		logout.open("log.txt");
	}
	yyin = fp;
	yyparse();

	asmout << ".MODEL SMALL"<<endl;
	asmout << ".STACK 400h"<<endl<<endl;
	asmout << ".DATA"<<endl;
	asmout << dseg.str()<<endl;
	asmout << ".CODE"<<endl;
	asmout << cseg.str()<<endl;
	addPreDefinedFunctions();
	asmout <<";Predefined Procedures"<<endl;
	asmout << pseg.str()<<endl;
	asmout << "END MAIN"<<endl;
	
	fclose(fp);
	logout.close();
	errout.close();
	delete table;
	return 0;
}