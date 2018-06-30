title: Leetcode算法思路
date: 2018-06-30 10:32:06
tags: [算法, leetcode, interview, C++]
categories: 技术
---

My Leetcode solution analysis. 

<!-- more -->

## todo

- summarize common modular operations and their time complexity, such as "longest common substring\subsequence".

## milestone

| Title | Solution | Speed & Percentile |
| ----- | -------- | ---------- |
|1. Two Sum | hashmap with early stop. | 7ms, 98% |
|2. Add Two Numbers in Linked List | dummy node for linked list. | 41ms, 98% | 
|3. Longest Substring Without Repeating Characters | bitmap in replace of <char, int> hashmap recording most recent position. | 19ms, 98% |
|4. Median of Two Sorted Arrays | do binary search on the shorter array between nums1 and nums2, compare the max\min number of left\right hand side. | 42 ms. 98% | 
|5. Longest Palindromic Substring | straightforward: for loop each element and expand at both side; best: only expand at right and jump through repeated elements as repeated one no matter how long it is will definitely be a valid palindrome string | 4ms, 100% |
|6. ZigZag Conversion| create zigzag moving iterator that follows the pattern of the normal for loop iterator. Essentially, to have a direction indicator that will change the zigzag iterator's moving direction. | 21 ms, 98.44%|
