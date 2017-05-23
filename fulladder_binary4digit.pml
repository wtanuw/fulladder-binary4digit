
#define NUM_MAX_DIGIT 4

#define p (finish == true)
#define q ((numberA+numberB) == (sum+(carryOut << 4)))
#define r ((sum) < (1<<4))


// struct for store result of adder function
typedef AdderResult
{
bit sum;
bit carryOut;
};

// input variable
int numberA = 0;
int numberB = 0;
bit binaryA[NUM_MAX_DIGIT];
bit binaryB[NUM_MAX_DIGIT];

// output variable
bit binarySum[NUM_MAX_DIGIT];
int sum = 0;
bit carryOut = 0;
bool finish = false

// result from adder function
AdderResult fullAdderResult;
AdderResult halfAdderResult;

// transfrom decimal to array of binary
inline fillNumA(num){
    int i = 0;
    for( i : i .. NUM_MAX_DIGIT-1 ){
        binaryA[i] = ( num >> i ) & 1;
    }
};
inline fillNumB(num){
    int i = 0;
    for( i : i .. NUM_MAX_DIGIT-1 ){
        binaryB[i] = ( num >> i ) & 1;
    }
};

// half adder from xor gate and and gate
inline halfAdder( a, b ){
   halfAdderResult.sum = a ^ b;
   halfAdderResult.carryOut = a & b;

	printf(">>> half adder sum  %d, carryOut %d \n", halfAdderResult.sum, halfAdderResult.carryOut);
};

// full adder by two half adder and or gate
inline fullAdder( a, b, carryIn ){
    AdderResult tmpHalfAdderResult;
    bit tmpCarryOut;
    
    halfAdder( a, b );
    tmpHalfAdderResult.sum = halfAdderResult.sum;
    tmpHalfAdderResult.carryOut = halfAdderResult.carryOut;
    
    halfAdder( tmpHalfAdderResult.sum,  carryIn );
    tmpCarryOut = tmpHalfAdderResult.carryOut | halfAdderResult.carryOut;
    
    fullAdderResult.sum = halfAdderResult.sum;
    fullAdderResult.carryOut = tmpCarryOut;

	printf(">>> full adder sum  %d carryOut %d \n", fullAdderResult.sum, fullAdderResult.carryOut);
};

// four bit full adder
inline fourDigitFullAdder( a, b ){
    
    finish = false;

    numberA = a;
    numberB = b;

    fillNumA( numberA );
    fillNumB( numberB );
    
    bit c = 0;
    
    int i = 0;
    fullAdder( binaryA[i], binaryB[i], c );
    binarySum[i] = fullAdderResult.sum;
    sum = fullAdderResult.sum;
    c =  fullAdderResult.carryOut;
    
    i = 1;
    fullAdder( binaryA[i], binaryB[i], c );
    binarySum[i] = fullAdderResult.sum;
    sum = sum + (fullAdderResult.sum << i);
    c =  fullAdderResult.carryOut;
    
    i = 2;
    fullAdder( binaryA[i], binaryB[i], c );
    binarySum[i] = fullAdderResult.sum;
    sum = sum + (fullAdderResult.sum << i);
    c =  fullAdderResult.carryOut;
    
    i = 3;
    fullAdder( binaryA[i], binaryB[i], c );
    binarySum[i] = fullAdderResult.sum;
    sum = sum + (fullAdderResult.sum << i);
    c =  fullAdderResult.carryOut;

    carryOut = c;
    
    finish = true;
    
    printf(">>> 4bit adder sum %d, carryOut %d \n", sum,carryOut);
}

// main function
init 
{ 
    int numA = 0;
    do
    :: (numA < 15) -> numA = numA +1
    :: (numA < 15) -> numA = numA +1
    :: (numA < 15) -> numA = numA +1
    :: break
    od;
    int numB = 0;
    do
    :: (numB < 15) -> numB = numB +1
    :: (numB < 15) -> numB = numB +1
    :: (numB < 15) -> numB = numB +1
    :: break
    od;
    fourDigitFullAdder( numA, numB );
}

// ltl - linear temporal logic
ltl { []((p->q)&&r) }
ltl { [](r) }


