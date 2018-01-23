title: Online messege sending后端C实现版
date: 2016-02-18 17:51:30
tags: C
categories: 技术
---

原型是最近一门课的作业， 这是我在过程中记下的一些手记心得， 都是我认为是值得关注的地方。 未来会把这些后端函数加入TCP协议， 更贴近实战使用吧。基础的数据结构主要是链表， 算是用C自己再复习一遍链表实现。算法嘛？没有算法😂不需要考虑性能也就没有考虑算法优化咯。

<!-- more -->

![screenshot](http://ww3.sinaimg.cn/large/c5ee78b5gw1f149fxx25oj21360w6n5z.jpg)
![profileshot](http://ww4.sinaimg.cn/large/c5ee78b5gw1f149r4zqkaj213e0zgajd.jpg)

## Ongoing notes

- how to enter the interactive mode? the main function for interactive mode is process_args. Like the code snippet below, it keep reading inputs from stdin(then using `fgets` to feed it into a input buffer), then using tokenize function(making use of `strtok` to tokenize the input commands), then the input command is stored in `char ** cmdargv`, which just like `argv` we often use. `cmdargv[0]` stores the first command, like `profile` and so on. What is left is just to depend on the return value from each core functions to display a proper information back to the screen.  

```
    printf("Welcome to FriendMe! (Local version)\nPlease type a command:\n> ");
    
    while (fgets(input, INPUT_BUFFER_SIZE, input_stream) != NULL) {
        // only echo the line in batch mode since in interactive mode the user
        // just typed the line
        if (batch_mode) {
            printf("%s", input);
        }

        char *cmd_argv[INPUT_ARG_MAX_NUM];
        int cmd_argc = tokenize(input, cmd_argv);

        if (cmd_argc > 0 && process_args(cmd_argc, cmd_argv, &user_list) == -1) {
            break; // can only reach if quit command was entered
        }

        printf("> ");
    }
```



- cast type when allocating memory for **_Fixed length character array_**

```
typedef struct user {
    char name[MAX_NAME];
    char profile_pic[MAX_NAME];  // This is a *filename*, not the file contents.
    struct post *first_post;
    struct user *friends[MAX_FRIENDS];
    struct user *next;
} User;
```

we need to do this:

```
	char* username = malloc(MAX_NAME*sizeof(char));
	strcpy(newuser->name, username);
```

to be able to allocate the memory for that character array. 

- how to handle structs of linked list when only the head of the list is given like `int create_user(const char *name, User **user_ptr_add)`. Note that since we will modify the linked list itself, we will have to pass in a pointer of pointer. Now if we only want to iterate through this linked list, we don't need the ptr of ptr. Resolved by referring to [this post ](http://geeksquiz.com/linked-list-set-2-inserting-a-node/), and refer to [this post](https://www.cs.bu.edu/teaching/c/linked-list/delete/) and [this post from Geeksquiz](http://geeksquiz.com/linked-list-set-3-deleting-node/) for deleting a node from a post. 
  > one key thing of dealing with ptr of ptr in linked list is that we need make clear the use of `curr` pointer and `*user_ptr` since we are suppore to change it in function `int create_user(const char *name, User **user_ptr_add)`. 

```
// add the newuser to the end of linked list.
// int create_user(const char *name, User **user_ptr_add) 

	// now append this node to the end of linked list.
	User* last = *user_ptr_add;
	if(*user_ptr_add == NULL){ // if linked list is empty
		*user_ptr_add = newuser;
	}
	else{ // otherwise
		if(strcmp(last->name, name) == 0){ // if the first node is the same user.
			return 1;
		}
		while(last->next!=NULL){
			if(strcmp(last->name, name) == 0){ // if same user exists
				return 1;
			}
			last = last->next;
		}
		last->next = newuser;
	}
```

```
// delete the user with name from the linked list.
// int delete_user(const char *name, User **user_ptr_del)

		User* curr = *user_ptr_del;
		User* prev; // store previous node.

		// if head node itself holds the user to be deleted.
		if(curr != NULL && strcmp(curr->name, name)== 0){
			*user_ptr_del = curr->next;
			free(curr);
			return 0;
		}

		while(curr != NULL && strcmp(curr->name, name) != 0){
			prev = curr;
			curr = curr->next;
		}

		delete_user_from_friends(name, *user_ptr_del);
		prev->next = curr->next;
		free(curr);
```

- type is not assignable during `malloc`: `struct user *friends[MAX_FRIENDS];`

- segmentation fault!!! **_Usually in practice, if we want to access the memory location where we don't have access to, meaning that when we want to set some attributes, we need to first make sure that that part of memory has been malloc!!_**
  > One trick on this is to make sure that whenever we see a struct like this: first is to malloc memory for the all struct, then for each array, like here `name`, `profile_pic` and `friends` array. Especially the `friends` array, the haunting time when debugging for the final function `delete_user`, I always get a segmentation fault, which results from that I did not malloc the memory for the friend array at the very first beginning inside `create_user` function, thus when I try to change one element's value, I will access to unallocated memory, a segmentation fault.

```
typedef struct user {
    char name[MAX_NAME];
    char profile_pic[MAX_NAME];  // This is a *filename*, not the file contents.
    struct post *first_post;
    struct user *friends[MAX_FRIENDS];
    struct user *next;
} User;
```

- Difference between `memcpy` and `strcpy`. `strcpy` will stop when meeting a '\0' line terminator, while `memcpy` will not do that, it can do the content copy without looking to the value of the contents.

## Bugs remaining to fix

- time.h. I finally do a trick to cover up the failure of using time.h. we are supposed to record the time when a post is created, and store the address of that `time_t`, which is actually a long int, to the struct attribute `post->date`, while it fails to display the right time when doing `ctime` in `print_user` function. I finally insert a time update right into the `print_user` function to let them next to each other and it display right result?!.