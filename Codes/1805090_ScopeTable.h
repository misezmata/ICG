#include "1805090_SymbolInfo.h"
#include "1805090_util.h"
class ScopeTable{
    int noOfChildren;
    int size;
    void printList(SymbolInfo* s){
        SymbolInfo* cur = s;
        while(cur != nullptr){
            cur->print();
            cur = cur->next;
        }
    }
    void printList(SymbolInfo* s, ofstream &lout){
        SymbolInfo* cur = s;
        while(cur != nullptr){
            cur->print(lout);
            cur = cur->next;
        }
    }
    bool insertTo(int hash, SymbolInfo* s){
        if(hash_table[hash] == nullptr){
            hash_table[hash] = s;
            // cout<<s->name<<" inserted in: "<<uniqueId<<endl;
            // cout<<"Inserted in ScopeTable# "<<uniqueId<<" at position "<<hash<<", "<<0<<endl;
            return true;
        }
        int count = 1;
        SymbolInfo* current = hash_table[hash];
        while(true){
            if(current->isSameName(s)) {
                // cout<<"<"<<current->getName()<<","<<current->getType()<<"> already exists in current ScopeTable"<<endl;
                return false;
            }
            if(current->next == nullptr) break; 
            current = current->next;
            count++;
        }
        current->next = s;
        // cout<<"Inserted in ScopeTable# "<<uniqueId<<" at position "<<hash<<", "<<count<<endl;
        return true;
    }
    bool deleteNode(SymbolInfo *s){
        int hash = hashFun(s->getName());
        // cout<<endl;
        if(hash_table[hash] == s){
            hash_table[hash] = s->next;
            // cout<<"Deleted Entry "<<hash<<", "<<0<<" from current ScopeTable"<<endl;
            delete s;
            //hash_table[hash] = nullptr;
            return true;
        }
        SymbolInfo* parent = hash_table[hash];
        SymbolInfo* child = parent->next;
        int count = 1;
        while(child != nullptr){
            if(child == s){
                parent->next = child->next;
                // cout<<"Deleted Entry "<<hash<<", "<<count<<" from current ScopeTable"<<endl;
                delete child;
                return true;
            }
            parent = child;
            child=child->next;
            count++;
        }
        return false;
    }
public:
    ScopeTable *parent;
    SymbolInfo **hash_table;
    string uniqueId;
    ScopeTable(int size, int n){
        hash_table = new SymbolInfo*[size];
        for(int i=0; i<size; i++) hash_table[i] = nullptr;
        parent = nullptr;
        this->size = size;
        uniqueId = to_string(n);
        noOfChildren = 0;
    }
    ScopeTable(int size, ScopeTable* parent){
        hash_table = new SymbolInfo*[size];
        for(int i=0; i<size; i++) hash_table[i] = nullptr;
        this->size = size;
        this->parent = parent;
        parent->noOfChildren += 1;
        uniqueId = parent->uniqueId + '.';
        uniqueId += to_string(parent->noOfChildren);
        noOfChildren = 0;
    }
    ~ScopeTable(){
        parent = nullptr;
        for(int i=0; i<size; i++){
            SymbolInfo* cur = hash_table[i];
            while(cur != nullptr){
                SymbolInfo* next = cur->next;
                delete cur; //sets cur->next = nullptr
                cur = next;
            }
        }
        delete []hash_table;
    }
    int hashFun(string s){
        unsigned long hash_value = hash_sdbm(s);
        hash_value %= size;
        return hash_value;
    }
    bool insert(SymbolInfo *s){
        int hash = hashFun(s->getName());
        return insertTo(hash, s);
    }    
    SymbolInfo* lookUpTable(string s, bool flag = true){
        int hash = hashFun(s);
        SymbolInfo* cur = hash_table[hash];
        int count = 0;
        while(cur != nullptr){
            if(cur->getName() == s) {
                // if(flag) cout<<"Found in ScopeTable# "<<uniqueId<<" at position "<<hash<<", "<<count<<endl;
                return cur;
            }
            cur = cur->next;
            count++;
        }
        // if(flag)cout<<"Not found"<<endl;
        return nullptr;
    }

    bool deleteNode(string name){
        SymbolInfo* si = lookUpTable(name, true);
        if(si == nullptr){
            // cout<<"Not found"<<endl<<endl;
            // cout<<name<<" not found"<<endl;
            return false;
        }
        return deleteNode(si);
    }
    
    void print(){
        cout<<endl<<"ScopeTable# "<<uniqueId<<endl;
        for(int i=0; i<size; i++){
            cout<<' '<<i<<" --> ";
            printList(hash_table[i]);
            cout<<endl;
        }
    }
     void print(ofstream &lout){
        lout<<endl<<"ScopeTable # "<<uniqueId<<endl;
        for(int i=0; i<size; i++){
            if(hash_table[i] == nullptr) continue;
            lout<<' '<<i<<" --> ";
            printList(hash_table[i], lout);
            lout<<endl;
        }
    }
};
