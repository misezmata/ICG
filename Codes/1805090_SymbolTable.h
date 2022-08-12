#include "1805090_ScopeTable.h"
class SymbolTable{
    int tableSize;
    ScopeTable* currentTable;
public:
    SymbolTable(int size){
        currentTable = new ScopeTable(size, 1);
        tableSize = size;
        currentTable->uniqueId = "1"; 
    }
    ~SymbolTable(){
        ScopeTable* cur = currentTable;
        while(cur != nullptr){
            ScopeTable* parent = cur->parent;
            delete cur;
            cur = parent;
        }
    }
    void enterScope(){
        ScopeTable* newTable;
        if(currentTable == nullptr){
            newTable = new ScopeTable(tableSize, 1);
        }
        else{ 
            newTable = new ScopeTable(tableSize, currentTable);
        }
        currentTable = newTable;
        // cout<<"New ScopeTable with id "<<currentTable->uniqueId<<" created"<<endl;
    }
    void exitScope(){
        if(currentTable == nullptr){
            cout<<"Not in a scope"<<endl;
            return;
        }
        // cout<<"ScopeTable with id "<<currentTable->uniqueId<<" removed"<<endl;
        ScopeTable* temp = currentTable;
        
        currentTable = currentTable->parent;
        delete temp;
        if(currentTable == nullptr){
            currentTable = new ScopeTable(tableSize, 1);
        }
    }
    bool insert(SymbolInfo* si){
        if(currentTable->insert(si)){
            return true;
        }else{
            return false;
        }
    }
    bool insert(string name, string type){
        if(currentTable == nullptr) return false;
        SymbolInfo* si = new SymbolInfo(name, type);
        if(insert(si)) return true;
        delete si;
        return false;
    }
    SymbolInfo* lookUp(string name){
        if(currentTable == nullptr) return nullptr;
        ScopeTable* cur = currentTable;
        while(true){
            SymbolInfo* si = cur->lookUpTable(name);
            if(si != nullptr) return si;
            cur = cur->parent;
            if(cur == nullptr) {
                // cout<<"Not found"<<endl;
                return nullptr;
            }
        }
    }
    bool remove(string name){
        return currentTable->deleteNode(name);
    }
    void printCurrentScope(){
        if(currentTable == nullptr) return;
        currentTable->print();
    }
    void printAll(){
        ScopeTable* cur = currentTable;
        // printf("\033[1;46m\n");
        while(cur != nullptr){
            cur->print();
            cur = cur->parent;
            if(cur != nullptr)cout<<endl;
        }
        // printf("\033[0m\n");
    }
    void printAll(ofstream &lout){
        ScopeTable* cur = currentTable;
        while(cur != nullptr){
            lout<<endl;
            cur->print(lout);
            cur = cur->parent;
            lout<<endl;
            // if(cur != nullptr)lout<<endl;
        }
        lout<<endl;
    }
};
