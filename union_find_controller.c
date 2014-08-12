#include <stdio.h>
#include <stdlib.h>
#include <time.h>

// cc -Wall -std=c99 union_find_controller.c -o union_find_controller

void UFConstructor(int n) {
  printf("creating %d objects\n\n", n);
}

int connected(int p, int q) {
  char connected[] = "%d is connected to %d\n";
  char disconnected[] = "%d is not connected to %d\n";
  int ret_val = rand() % 2;

  if (ret_val) {
    printf(connected, p, q);
  } else {
    printf(disconnected, p, q);
  }

  return ret_val;
}

// union:
void connect(int p, int q) {
  printf("connecting %d to %d\n", p, q);
}

void prompt_for_int(const char* message, int* int_address) {
  printf(message);
  scanf("%d", int_address);
  puts("");
}

int main(int ac, char** av) {
  int N, p, q;

  srand(time(0));

  prompt_for_int("How many objects? ", &N);
  //printf("N is: %d\n", N);
  UFConstructor(N);

  while (!feof(stdin)) {
    prompt_for_int("\np: ", &p);
    //printf("p is: %d\n", p);
    prompt_for_int("q: ", &q);
    //printf("q is: %d\n", q);
    if (!connected(p, q)) {
      connect(p,q);
    }
  }

  return 0;
}
