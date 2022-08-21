int fac(int a){
    if(a == 0) return 1;
    return a * fac(a - 1);
}

int main(){
    int a, c;
    a = 5;
    while(a){
        c = fac(a);
        printf(c);
        a--;
    }
}