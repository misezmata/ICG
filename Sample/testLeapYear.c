int isLeapYear(int a){
    printf(a);
    if(a % 100 == 0) {
        int c;
        c = a / 100;
        a = c;
    }
    return a%4==0;
}
int main(){
    int a;
    a = isLeapYear(2020);
    printf(a);
    a = isLeapYear(2022);
    printf(a);
    a = isLeapYear(2100);
    printf(a);
    a = isLeapYear(2400);
    printf(a);
}