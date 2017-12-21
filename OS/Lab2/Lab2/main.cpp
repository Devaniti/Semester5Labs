#include "Utils.h"
#include <stdlib.h>

int main(void) {
	unsigned int CPUs, jobs;
	printf("Enter number of CPUs: ");
	scanf("%d", &CPUs);
	printf("Enter number of jobs: ");
	scanf("%d", &jobs);

	printf("Total penalty sum- %f MHz\n", enumulateSchedulerWork(jobs, CPUs));
	system("pause");
}
