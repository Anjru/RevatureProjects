public with sharing class Calculator {
    public Calculator() {

    }

    public static Integer add(Integer a, Integer b){
        return a + b;
    }

    public static Integer multiply(Integer a, Integer b){
        Integer c = 0;
        for(Integer i = 0; i < b; i++){
            c += a;
        }
        return c; 
    }

    //Only divides when Dividend is larger than divisor
    public static Integer divide(Integer a, Integer b){
        Integer quotient = 0;
        Integer sum = 0;
        if(b == 0){
            return 0;
        }
        if(a > b) {
            while(sum + b <= a) {
                sum+=b;
                quotient++;
            }
            return quotient;
        } else {
            return 0; 
        }
    }

    public static Integer mod(Integer a, Integer b){ 
        Integer modVal = 0;

        Integer quotient = divide(a,b);
        modVal = a - multiply(quotient,b);
        return modVal; 

    }


    public static Integer calculate(String a) {
        return 0;
    }


}