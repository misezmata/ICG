#include <string>
using namespace std;
uint32_t hash_sdbm(string s){
    uint32_t hash = 0;
    int l = s.length();
    for(int i=0; i<l; i++){
        int c = s[i];
        hash = c + (hash << 6) + (hash << 16) - hash;
    }
    return hash;
}