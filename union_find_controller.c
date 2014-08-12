#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>
#include <ctype.h>

// cc -Wall -std=c99 union_find_controller.c -o union_find_controller
// cat tinyUF.txt | ./union_find_controller

typedef struct UF {
  char name[50];
  int size;
  int *array;
} UF;

//int *uf;
UF uf;
int N;

void print_int_ary(UF* _uf) {
  //, const char* name, int size) {
  //char name[] = "uf";
  printf("%s:\n", _uf->name);
  for (int i = 0; i < _uf->size; i++) {
    printf("\t%s[%d]: %d\n", _uf->name, i, _uf->array[i]);
  }
  puts("");
}

UF* UFConstructor(const char* name, int size) {
  // "uf", N, uf.array) {
  //int* UFConstructor(int *_uf, int n) {
  uf.size = size;
  strcpy(uf.name, name);
  printf("creating %d objects...", size);
  uf.array = (int *)malloc(size * sizeof(int));
  for(int i = 0; i< size; i++) {
    uf.array[i] = i;
  }
  puts("\n");
  print_int_ary(&uf);
  return &uf;
}

int connected(int p, int q) {
  char connected[] = "%d is connected to %d\n";
  char disconnected[] = "%d is not connected to %d\n";
  int ret_val = (uf.array[p] == uf.array[q]) ? 1 : 0; //rand() % 2;

  print_int_ary(&uf);

  if (ret_val) {
    printf(connected, p, q);
  } else {
    printf(disconnected, p, q);
  }

  return ret_val;
}


// union:
void connect(int p, int q) {
  //int *ufp_p = &uf[p];
  //int *ufq_p = &uf[q];

  printf("connecting uf[%d] = %d => uf[%d] = %d...", p, uf.array[p], q, uf.array[q]);
  //ufp_p = ufq_p;  //contents of q into p
  uf.array[p] = uf.array[q]; // maybe put q's value in p, so the two match!
  printf("\nconnected uf[%d] = %d => uf[%d] = %d\n", p, uf.array[p], q, uf.array[q]);
  //print_uf(N);
  print_int_ary(&uf);
}

void prompt_for_int(const char* message, int* int_address) {
  char c = '0';
  int awaiting_input = 1;
  while (awaiting_input) {
    printf("%s", message);
    if (scanf("%d", int_address) == 0) {
      printf("Invalid char: %c\n", c);
      do {
        c = getchar(); // is this blocking &/ reading input !?
      } while (!isdigit(c)); // repeat until the character you read is not a digit
      ungetc(c, stdin); // put the character you read back in stdin

      //consume non-numeric chars from buffer
      //?? try again
    } else {
      awaiting_input = 0;
    }
  }
  puts("");
}

int main(int ac, char** av) {
  int p, q;
  UF *_uf;

  prompt_for_int("How many objects? ", &N);
  //uf.name = "uf";
  //uf.size = N;
  //uf = UFConstructor("uf", N, uf.array);
  _uf = UFConstructor("uf", N);

  while (!feof(stdin)) {
    prompt_for_int("\np: ", &p);
    prompt_for_int("q: ", &q);
    assert(p < N); // just ignore when p < 0 or N < p
    assert(q < N); // just ignore when q < 0 or N < q
    if (!connected(p, q)) {
      connect(p,q);
    }
  }

  free(_uf->array);
  return 0;
}
