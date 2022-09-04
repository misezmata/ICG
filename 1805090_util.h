#include <string>
using namespace std;
string str_replace(string s, char p='.', char n='_'){
    int len = s.size();
    for(int i=0; i<len; i++){
        if(s[i] == p) s[i] = n;
    }
    return s;
}
string getFirstToken(string s, char c){
    string ss = "";
    int l = s.size();
    for(int i=0; i<l; i++){
        if(s[i] == c)return ss;
        ss += s[i];
    }
    return ss;
}
uint32_t hash_sdbm(string s){
    uint32_t hash = 0;
    int l = s.length();
    for(int i=0; i<l; i++){
        int c = s[i];
        hash = c + (hash << 6) + (hash << 16) - hash;
    }
    return hash;
}