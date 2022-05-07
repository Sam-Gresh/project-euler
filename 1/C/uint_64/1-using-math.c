#include <stdio.h>
#include <mpir.h>
#include <time.h>

void mpz_sum_multiples(mpz_t rop, unsigned long long max, int divisor){
    mpz_t a;
    mpz_t b;
    mpz_init(a);
    mpz_init(b);

    mpq_t aq;
    mpq_t bq;
    mpq_t dq;
    mpq_init(aq);
    mpq_init(bq);
    mpq_init(dq);


    mpz_set_ux(a, ((max / divisor) + 1));
    mpz_set_ux(b, (max / divisor));

    mpq_set_z(aq, a);
    mpq_set_z(bq, b);
    mpq_set_ui(dq, 2, 1);

    mpq_div(aq, aq, dq);

    mpq_mul(aq, aq, bq);

    mpz_set_q(rop, aq);
    mpz_mul_ui(rop, rop, divisor);
}

int main(int argc, char* argv[]){
    double time_spent = 0.0;
    

    long max;
    if(argc == 1){
        printf("Enter Maximum:\n");
        scanf("%ld", &max);
        
    }
    else{
        max = atoi(argv[1]);
    }

    clock_t begin = clock();

    max -= 1;
    mpz_t sum1;
    mpz_init(sum1);
    mpz_sum_multiples(sum1, max, 3);
    
    mpz_t sum2;
    mpz_init(sum2);
    mpz_sum_multiples(sum2, max, 5);



    mpz_t intersection;
    mpz_init(intersection);
    mpz_sum_multiples(intersection, max, 15);
    

    mpz_t sum;
    mpz_init(sum);
    mpz_add(sum, sum1, sum2);
    mpz_sub(sum, sum, intersection);
    

    printf("The answer is: ");
    mpz_out_str(stdout, 10, sum);
    printf("\n");



    clock_t end = clock();
    time_spent = (double)(end - begin) / CLOCKS_PER_SEC;
    printf("The elapsed time is %f seconds", time_spent);
    return 0;
}