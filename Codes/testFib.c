int fib(int a){
    if(a == 1 || a == 2) return 1;
    return fib(a-1) + fib(a-2);
}
int main(){
    int a, c;
    for(a = 1; a<6; a++){
        c = fib(a);
        printf(c);
    }
}