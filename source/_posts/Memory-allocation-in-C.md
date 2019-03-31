title: Memory allocation in C
date: 2016-01-26 17:36:34
tags: C
categories: 技术
---

Learning memory allocation in C for beginners will be totally a pain. This post, distilled from course materials, will provide you a practice guide and example coding snippets to help you learning more and fast in C programming language. It is cherishable, at least to me :)

<!-- more -->

## Introduction to malloc

- Variable defined in function will be stored in stack, so how to use that part of memory after function returns? we use `void * malloc(size_t size)` will allocate memory in heap. This function will remain the memory for the variables until the function explicitly deallocate them. The argument for this function indicates how many bytes of memory should it allocate.
- In general, `size_t` is unsigned_int. Notice the `void *` type of the pointer, we know that in C, add 1 to a pointer will go to the next legal address, for `int*`, it is the next integer, for `char*`, it is next character.
- A void pointer is a pointer that represent a generic type. It just points to the memory specified, so it do not need to specify right now what type of that memory is, instead, we will declare the type when use pointer:

```
int * pt = malloc(sizeof(int));
```

the above code indicates that we will the allocated memory for integer. 

## Example code


```
#include <stdio.h>
#include <stdlib.h>

/* 
 * Return an array of the squares from 1 to max_val.
 */
int *squares(int max_val) {
    int *result = malloc(sizeof(int) * max_val);
    int i;
    for (i = 1; i <= max_val; i++) {
        result[i - 1] = i * i ;
    }
    return result;
}


int main() {

    int *squares_to_10 = squares(10);
    
    // let's print them out 
    int i;
    for (i = 0; i < 10; i++) {
        printf("%d\t", squares_to_10[i]);
    }
    printf("\n");

    return 0;
}
```

Note that in the above code, there are several variables that are located in heap. They are, the address store inside the variable result, since it points to a integer that lies in heap, while **the addresss of the variable result is not in the heap, it is in the stack**. One quick trick is that those value in heap, their address is valid. 

## Explicitly deallocate the memory


```
#include <stdio.h>
#include <stdlib.h>

int play_with_memory() {
    int i;
    int *pt = malloc(sizeof(int));

    i = 15;
    *pt = 49;
    
    // What happens if you comment out this call to free?
    free(pt);

    // What happens if you uncomment these statements?
    printf("%d\n", *pt); // output 49
    *pt = 7;

    printf("%d\n", *pt); // output 7

    return 0;
}

int main() {
    play_with_memory();
    play_with_memory();
    play_with_memory();
    return 0;
}
    
    
```

> Important issue here: when returned from the function, all variables will be freed from stack, which means that the `i` and `result` in the above code will be removed. It will cause a memory leak if we forget to link the memory from `malloc` to other heap variables. Since there will be no way from elsewhere to access that part of memory.

- The danger of memory leak is that if it accumulates, it will finally cause a `out of memory` issue.
- what happens if we print out the value stored in that memory location after we free up that pointer? **Address is still valid and the value can still be accessed, but this time, we are using the part of memory that does not belong to us**. Note that using unallocated memory is OK in some cases, but it will be dangerous when that part of memory being reallocated. So, always use allocated memory!

 
## Passing values


```
#include <stdio.h>
#include <stdlib.h>

void helper(int **arr_matey) {
   // let's make an array of 3 integers on the heap
   *arr_matey = malloc(sizeof(int) * 3);

   int *arr = *arr_matey;
   arr[0] = 18;
   arr[1] = 21;
   arr[2] = 23;
}

int main() {
    int *data;
    helper(&data);

    // let's just access one of them for demonstration
    printf("the middle value: %d\n", data[1]);

    free(data);
    return 0;
}
```

- there are basically two ways to help to avoid memory leak, a) **return value**, if we define that function type to be a pointer type, so that we can return the pointer in order to assign the values in main function. b) **argument**, we pass the one we want to assign values to the function and do the assigning part inside that function, and this time, the function type can be void but still finish the task.
- However, it is much harder to use `argument` one since in C, the changes inside the function will not be preserved if we return nothing. Therefore, we need to the "address-value" relation in such scenario -- That is **we pass in pointer, we change value pointed at pointer, without returning anything, and we're done.** While problem comes when we want to change the pointer, say this line `*arr_matey = malloc(sizeof(int) * 3);`, we want to change the pointer now, but such change will not be preserved after function. Therefore, we will need to pass in a **"poiter of pointer" to deal with pointer assignment!** 

## Nested structure


if we want to use a nested struture to represent an array, say in that array, each element points to another array, since we don't know that array size at compilation time, we would use `malloc` to allocate memory for those int array. The code is like

```
int ** pt = malloc(sizeof(int*)*2);
```

Say, now, I want the pt[0] to hold up an array of one integer, the way to do that is to use:

```
pt[0] = malloc(sizeof(int));
```

Similarly, if we want pt[1] to hold up 3 integers, we would use:

```
pt[1] = malloc(sizeof(int)*3);
```

> Note that when we free those pointers, we need to free the innermost pointer first then outer one. 

An complete code example:

```
#include <stdio.h>
#include <stdlib.h>

int main() {

    // this allocates space for the 2 pointers
    int **pointers = malloc(sizeof(int *) * 2); 
    // the first pointer points to a single integer
    pointers[0] = malloc(sizeof(int));
    // the second pointer pointes to an array of 3 integers
    pointers[1] = malloc(sizeof(int) * 3);

    // let's set their values
    *pointers[0] = 55;

    pointers[1][0] = 100;
    pointers[1][1] = 200;
    pointers[1][2] = 300;

    
    // do other stuff with this memory

    // now time to free the memory as we are finished with the data-structure
    // first we need to free the inner pieces
    free(pointers[0]);
    free(pointers[1]);
    // now we can free the space to hold the array of pointers themselves
    free(pointers);
    
    return 0;
}
```

## Memory model


- note that th variable in main function does not belong to global variable, indicating it should still go to the stack part. The "global data" part contains mainly three stuff: **a) global variables, b) string literals ** Note that for the string literals, the code like this: `char* str = "Hello world!";` can lie in a local function, it just means that the pointer str can be in the stack, while the string literal "Hello world!" is in global data part. 
- And dynamic memory allocation lie in heap.

## String


- difference between a string and a character is that at the end of string, there is a `\0` as an ending signal. Once the character array declared, the size is fixed. Note that the difference between these similar version of declaring character array:
  - `char string[20] = "cool shit"`, it is defining a **string variable**, with a `\0` at the end of the array, note that there will be a lot of `\0` following the valid words. It can be changed afterwards.
  - `char string[] = "cool shit"`, defining a **string variable** the size will be fixed according to the first assignment. It can be changed afterwards.
  - `char* string = "cool shit"`, defining a **string constant**. it is a string literal! cannot be changed!! If you change the string, it will give a "bus error". Main point here: _ **it makes string point to a read-only memory where string literal is stored, while the above two way are indeed allocating memory and copy string to them.**_

- difference between `strlen` and `sizeof`. `strlen` will return the valid number of characters before null character, while `sizeof` will just give you the size of whole char array including null characters.

- use `strncpy` as a stable counterpart of `strcpy`, the usage is like: `strncpy(s1, s2, sizeof(s1));` see the complete code below, s2 is a string literal. 

```
#include <stdio.h>
#include <string.h>

int main() {
    char s1[5];
    char s2[32] = "University of";

    // This is unsafe because s1 may not have enough space
    // to hold all the characters copied from s2.
    //strcpy(s1, s2);

    // This doesn't necessarily null-terminate s1 if there isn't space.
    strncpy(s1, s2, sizeof(s1));
    // So we explicitly terminate s1 by setting a null-terminator.
    s1[4] = '\0';

    printf("%s\n", s1);
    printf("%s\n", s2);
    return 0;
}
```

> Note that s1 is a character array, which means that there is no null characters at the end. if we want to do this way, we want to add null character at the end.

- Similarly, `strncat(s1, s3, sizeof(s1)-strlen(s1)-1);` is the stable version of using strcpy.
- `char * strchr(const char s, int c);` return the index at the first occurence of the character
- `char * strstr(const char* s1, const char* s2);` find sub string. see the code example below:

```
#include <stdio.h>
#include <string.h>

int main() {
    char s1[30] = "University of C Programming";
    char *p;

    // find the index of the first 'v'
    p = strchr(s1, 'v');
    if (p == NULL) {
        printf("Character not found\n");
    } else {
        printf("Character found at index %ld\n", p - s1);
    }

    // find the first token (up to the first space)
    p = strchr(s1, ' ');
    if (p != NULL) {
        *p = '\0';
    }
    printf("%s\n", s1);

    return 0;
}
```

if the character specified in the second argument cannot find the right place, then it will assign NULL to p in this case. We can use pointer subtraction to get the index. 
























