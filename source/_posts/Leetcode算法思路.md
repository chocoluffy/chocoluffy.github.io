title: Leetcode算法思路
date: 2018-06-30 10:32:06
tags: [算法, leetcode, interview, C++]
categories: 技术
---

My Leetcode solution analysis. 

<!-- more -->


## todo

- summarize common modular operations and helpful util functions, with their time complexity, such as "longest common substring\subsequence", "check if integer overflow".

- also recording each solution's time & space complexity. 

- check "Discussion" tab for smart tricks.

## milestone

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

## summary

### median

A position that the number of elements at two sides is the same.

Problems: NO.4


### two pointer

Essentially a way of searching. find the direction of keeping the sub-structure optimality. keep the optimality and explore\compare.

Problems: NO.11