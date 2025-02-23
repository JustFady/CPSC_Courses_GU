#include <stdio.h>
#include <stdlib.h>

int get_num_grades();
double* get_array(int num_grades);
void fill_array(double* grades_array, int num_grades);
double get_average(double* const grades_array, int num_grades);
display_avg(int avg);

int main()
{
    int num_grades = get_num_grades();
    double* grades_array = get_array(num_grades);
    double avg = get_average(grades_array, num_grades);
    display_avg(avg);
    free(grades_array);

    printf("\nPress [Enter] to end program");
    getchar();
    return EXIT_SUCCESS;
}

int get_num_grades()
{
    int num;
        while (scanf("%d", &num) != 1 || num <1)
        {
            while(getchar() != '\n');
    printf("How many grades do you want to enter?");
        }
    return num;

}

double* get_array(int num_grades)
{
    double * arr = calloc(num_grades, sizeof(double));
    return arr;
}

void fill_array(double* grades_array, int num_grades)
{
    for(int i= 0; i< num_grades; i++)
    {
        while (scanf("%lf", grades_array[i])!=1 ||
                grades_array[i] > 4.0 ||
                grades_array[i]<0.0);
        printf("Enter grade #%d: ", i+1);
        {

            while (getchar() != '\n')
                printf("Enter grade #%d: ", i+1);
        }
    }
}

double get_average(double* const grades_array, int num_grades)
{
    double avg = 0;
    for(int i =0; i<num_grades; i++)
        avg += grades_array[i];
    return avg;
}

display_avg(int avg)
{
    printf("Your grade point average is %lf.\n", avg);

}
