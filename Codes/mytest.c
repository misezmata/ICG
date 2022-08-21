int fib(int a){
    if(a == 1 || a == 2) return 1;
    return fib(a-1) + fib(a-2);
}

int main(){
    int a;
    for(a = 1; a < 10; a++){
        int c;
        c = fib(a);
        printf(c);
    }
}