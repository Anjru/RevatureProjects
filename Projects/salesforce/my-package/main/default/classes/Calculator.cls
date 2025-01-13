public with sharing class Calculator {
    public Calculator() {}

    public static Integer add(Integer a, Integer b) {
        return a + b;
    }

    public static Integer multiply(Integer a, Integer b) {
        Integer c = 0;
        for (Integer i = 0; i < b; i++) {
            c += a;
        }
        return c;
    }

    public static Integer divide(Integer a, Integer b) {
        Integer quotient = 0;
        Integer sum = 0;
        if (b == 0) {
            return 0;
        }
        if (a > b) {
            while (sum + b <= a) {
                sum += b;
                quotient++;
            }
            return quotient;
        } else {
            return 0;
        }
    }

    public static Integer mod(Integer a, Integer b) {
        Integer modVal = 0;
        Integer quotient = divide(a, b);
        modVal = a - multiply(quotient, b);
        return modVal;
    }


    /**
     * Elite Challenge
     * Calculates string passed in
     * Note: Didn't use math operation above... 
     */
    public static Decimal calculate(String a) {
        // Remove spaces for cleaner parsing
        a = a.replace(' ', '');

        // List to store numbers and operators separately
        List<Decimal> numbers = new List<Decimal>();
        List<String> operators = new List<String>();

        // Holds the current parsed number as a string
        String numString = '';

        // Parses the expression
        // Iterates each character withing string
        for (Integer i = 0; i < a.length(); i++) {
            String currentChar = a.substring(i, i + 1);

            // Checking if the character is a number
            // Appends char on numString if num or decimal
            if (isNumeric(currentChar) || currentChar == '.') {
                numString += currentChar;
            }
            // If an operator or parenthesis is found, process the number and store the operator
            else if (isOperator(currentChar) || currentChar == '(' || currentChar == ')') {
                if (numString != '') {
                    try {
                        numbers.add(Decimal.valueOf(numString));
                        numString = ''; // Reset after storing
                    } catch (Exception e) {
                        System.debug('Error parsing number: ' + numString);
                        return null;
                    }
                }
                operators.add(currentChar);
            } else {
                throw new IllegalArgumentException('Invalid character detected: ' + currentChar);
            }
        }

        // Store any remaining number
        if (numString != '') {
            try {
                numbers.add(Decimal.valueOf(numString));
            } catch (Exception e) {
                System.debug('Error parsing number: ' + numString);
                return null;
            }
        }

        // Process mathematical operations using a stack approach and handle parentheses
        return evaluateExpression(numbers, operators);
    }

    //Checks if string is a number
    private static Boolean isNumeric(String value) {
        try {
            Decimal.valueOf(value);
            return true;
        } catch (Exception e) {
            return false;
        }
    }

    //Checks if String is an operator 
    private static Boolean isOperator(String a) {
        return '+-*/'.contains(a);
    }

    //Evaluates expression
    //Store numbers and operators in stack to esablish order of operationss
    private static Decimal evaluateExpression(List<Decimal> numbers, List<String> operators) {
        // Stacks for numbers and operators
        List<Decimal> numStack = new List<Decimal>();
        List<String> opStack = new List<String>();

        Integer numIndex = 0;

        //Iterates operators to esablish precedence/order and add to stack
        for (String op : operators) {
            //Checks paranthesis
            //adds to stack
            if (op == '(') {
                opStack.add(op);
            } else if (op == ')') {
                while (opStack.size() > 0 && opStack[opStack.size() - 1] != '(') {
                    Decimal result = applyOperator(numStack, opStack);
                    numStack.add(result);
                }
                opStack.remove(opStack.size() - 1); // Remove the '('
            } else if (isOperator(op)) {
                while (opStack.size() > 0 && precedence(opStack[opStack.size() - 1]) >= precedence(op)) {
                    Decimal result = applyOperator(numStack, opStack);
                    numStack.add(result);
                }
                opStack.add(op);
            }

            // Add the current number from the numbers list (if available)
            if (numIndex < numbers.size()) {
                numStack.add(numbers[numIndex]);
                numIndex++;
            }
        }

        // Final operations for the remaining numbers and operators
        while (opStack.size() > 0) {
            Decimal result = applyOperator(numStack, opStack);
            numStack.add(result);
        }

        // The result should be the only item left in the stack
        if (numStack.size() == 1) {
            return numStack[0];
        } else {
            throw new IllegalArgumentException('Error in expression evaluation');
        }
    }

    //applies operator
    private static Decimal applyOperator(List<Decimal> values, List<String> operators) {
        //Grabs values from stack 
        Decimal b = values.remove(values.size() - 1);
        Decimal a = values.remove(values.size() - 1);
        String op = operators.remove(operators.size() - 1);

        if (op == '+') {
            return a + b;
        } else if (op == '-') {
            return a - b;
        } else if (op == '*') {
            return a * b;
        } else if (op == '/') {
            if (b == 0) {
                throw new IllegalArgumentException('Division by zero');
            }
            return a / b;
        } else {
            throw new IllegalArgumentException('Invalid operator: ' + op);
        }
    }

    //Determine which operator takes precedence over the other
    private static Integer precedence(String op) {
        if (op == '+' || op == '-') {
            return 1;
        } else if (op == '*' || op == '/') {
            return 2;
        } else {
            return 0;
        }
    }
}
