/*
It’s required to write a c Program that accepts a 2D array and returns the sum of the numbers formed by concatenating the elements(non negative) of each column. E.g. the given matrix returns 51362
	Explanation: ‘1052 + 20104 + 30206 = 51362’
*/

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
/*
void concatenating_sum(int rows, int cols, unsigned int mat[rows][cols]) {
 long long unsigned int SUM=0;
    for (int i = 0; i < cols; i++) {
        int *arr = (int *)malloc(cols * sizeof(int));
        for (int j = 0; j < rows; j++) {
            arr[j] = mat[j][i];
        }
        int power=0;
        int sum=0;
        for (int x = rows-1; x >= 0; x--) {
            sum= sum + arr[x]*(int)pow(10, power);
            power++;
        }
        SUM=SUM+sum;
        free(arr);
    }
    printf("%llu\n", SUM);
}

int main()
{
    unsigned int mat[2][3] = {{1, 2, 3}, {4, 5, 6}};
    concatenating_sum(2, 3, mat);
    return 0;
}
*/
void concatenating_sum(int rows, int cols, unsigned int mat[rows][cols]) {
 long long unsigned int SUM=0;
    for (int i = 0; i < cols; i++) {
        int *arr = (int *)malloc(cols * sizeof(int));
        for (int j = 0; j < rows; j++) {
            arr[j] = mat[j][i];
        }
        int power=0;
        int sum=0;
        for (int x = rows-1; x >= 0; x--) {
            int temp=0;
            temp=arr[x]%10;
            while(temp!=arr[x]){
                    if(temp == 0){
                        power++;
                    }
                    else{
                       sum= sum + temp*(int)pow(10, power);
                       power++;
                    }
                arr[x]=arr[x]/10;
                if(arr[x]==0)break;
                else temp= arr[x]%10;
            }
            sum= sum + arr[x]*(int)pow(10, power);
            power++;
        }
        SUM=SUM+sum;
        free(arr);
    }
    printf("%llu\n", SUM);
}

int main()
{
    unsigned int mat[3][3] = {{10, 20, 30}, {5, 10, 20}, {2, 4, 6}};
    concatenating_sum(3, 3, mat);
    return 0;

}
