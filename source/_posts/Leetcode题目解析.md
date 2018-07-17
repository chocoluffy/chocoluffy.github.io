title: Leetcode题目解析
date: 2018-07-01 10:32:06
tags: [算法, leetcode, interview, C++]
categories: 技术
---

My Leetcode solution collection. 

<!-- more -->

# milestone

| Title | Description | Solution | Speed & Percentile |
| ----- | ----- | -------- | ---------- |
|1. Two Sum | find a pair summing to target value. | hashmap with early stop. | 7ms, 98% |
|2. Add Two Numbers in Linked List | doing addition and curry. | dummy node for linked list. | 41ms, 98% | 
|3. Longest Substring Without Repeating Characters | as title. | bitmap in replace of <char, int> hashmap recording most recent position. if there is a collision then found a repeated character. | 19ms, 98% |
|4. Median of Two Sorted Arrays | find median number from two sorted arrays. | do binary search on the shorter array between nums1 and nums2, compare the max\min number of left\right hand side. Median is a position that the number of elements at two sides are equal. | 42 ms. 98% | 
|5. Longest Palindromic Substring | as title. | straightforward: for loop each element and expand at both side; best: only expand at right and jump through repeated elements as repeated one no matter how long it is will definitely be a valid palindrome string | 4ms, 100% |
|6. ZigZag Conversion | given a string, and place it in a zigzag way, then collect them row by row to form a new string. | create zigzag moving iterator that follows the pattern of the normal for loop iterator. Essentially, to have a direction indicator that will change the zigzag iterator's moving direction. | 21 ms, 98.44%|
|7. Reverse Integer | as title. |  check integer overflow before potential operations, trick is to check if applying reverse operation can yield original result. | 16 ms, 99.17%|
|8. String to Integer (atoi) | as title, with some edge cases. | convert each character to integer, check if overflow before any further operations. | 4ms, 100%|
|11. Container With Most Water | an array of integer, as vertical lines on coordinates, together with x-axis forms a container, find the one holds most water. | two pointer at two ends moving inwards. we can prove that moving the longer line inward is always worse than the current result. Thus we move the shorter line inward.  | 4ms, 100%|

## todo

- summarize common modular operations and helpful algorithm functions, with their time complexity, such as "longest common substring\subsequence", "check if integer overflow". 

- summarize common data structure implementation, such as trie tree. put the above two section on [Leetcode算法思路](http://chocoluffy.com/2018/06/30/Leetcode%E7%AE%97%E6%B3%95%E6%80%9D%E8%B7%AF/).

- also recording each solution's time & space complexity. 

- check "Discussion" tab for smart tricks.


# 1 two sum

- 最快的算法里对std::sort的使用。

虽然理论上sort是nlogn，但是在实用中sort可以在某些情况下提高速度。尤其当c++的library function对其添加的优化。

# 2 add two numbers

- 想清楚什么时候需要引入dummy node。

常见的原因是为了更简便地处理while loop里面的edge case，比如这里的第一个node的初始化。我们创建新node是依赖while loop的逻辑的，如果为NULL，在loop使用node->next会seg fault。所以通过创建dummy node使得可以直接在loop里使用node->next。然后最后用dummy->next返回整个链的head。

# 3 longest substring without repeating characters

- map<char, int>

优化这个结构的时候，可以考虑bitmap的使用。类似bucketsort的原理。如果是字符则是默认256长度的bitmap，然后对应的位置放置其value。


# 14 longest common prefix

problem: as title.

## ideas

- [me] vertical scanning. time complexity: O(S), where S is the sum of all characters in all string. space complexity: O(1).
- divide and conquer. because LCP satisfies the associative property, that LCP(1,..., n) = LCP(LCP(1,..., n/2), LCP(n/2+1,..., n)). as like in finding min or max. time complexity is O(S), space complexity is O(mlogn), n is the number of string, m is the average length, since divide and conquer requires to store intermediate results.
- binary search. an improvement on the vertical scanning. apply the binary search on the shortest string and do the vertical scanning to validate if it's LCP. time complexity is O(S * log(min string length)), space complexity is O(1).


# 866 prime palindrome

problem: find a prime number that is also a palindromd over N.

## ideas

- find palindrome then check if prime. 

the set of palindrome is smaller, and for each palindrome, we can test whether it is prime in O(N^1/2).

-> find the set of palindrome number over N.

-> how to find the next palindrome number.

from the center move outward, find the critical digit to add 1.

## summary
 
define the palindrome root. say 121 is 12. thus we can use palindrome root to construct palindrome number by increase it by 1 at a time. 

- https://leetcode.com/articles/prime-palindrome/
