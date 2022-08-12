#include <bits/stdc++.h>
using namespace std;
class SymbolInfo{
    string name, type, varType;
    int spec; // 1 ID, 2 FUNCTION
    int size; // if id, array or not! size of parameterlist
    vector<SymbolInfo*>* params;
public:
    SymbolInfo* next;
    SymbolInfo(string name, string type){
        this->name = name;
        this->type = type;
        spec = 0;
        size = 0;
        next = nullptr;
        params = nullptr;
    }
    SymbolInfo(string name, string type, int spec, int size){
        this->name = name;
        this->type = type;
        this->spec = spec;
        this->size = size;
        params = nullptr;
    }
    ~SymbolInfo(){
        next = nullptr;
        if(params == nullptr) return;
        int sz = params->size();
        for(int i=0; i<sz; i++){
            delete ((*(params))[i]);
        }
        delete params;
    }
    void print(){
        cout<<" < "<<name<<", "<<spec<<", "<<size<<" : "<<type<<" "<<varType<<"> ";
    }
    void print(ofstream &lout){
        lout<<"< "<<name<<" , "<<type<<" > ";
    }
    void print2(){
        cout<<"{"<<endl;
        cout<<"\tthis: "<<this<<endl;
        cout<<"\tname: "<<name<<endl;
        cout<<"\ttype: "<<type<<endl;
        cout<<"\tspec: "<<spec<<endl;
        cout<<"\tsize: "<<size<<endl;
        cout<<"\tnext: ";
        if(next == nullptr) cout<<"null"<<endl;
        else cout<<next<<endl;
    }
    string getName(){return name;}
    string getType(){return type;}
    bool isSameName(SymbolInfo* si){return si->name == this->name;}
    int getSpec() {return spec;}
    int getSize() {return size;}
    vector<SymbolInfo*>* getParams(){return params;}
    void setSpec(int t){spec = t;}
    void setSize(int s){size = s;}
    void setParams(vector<SymbolInfo*>* p){params = p;}
    void setType(string type){this->type = type;}
    string getVarType(){return varType;}
    void setVarType(string vt){this->varType = vt;}
};