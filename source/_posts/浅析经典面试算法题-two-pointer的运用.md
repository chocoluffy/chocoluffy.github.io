title: 浅析经典面试算法题-two pointer的运用
date: 2016-12-04 12:59:47
tags: [算法, 面试总结, java]
categories: 原创
---

前几天和朋友讨论 Google 电面的一道题， 由此启发， 总结了下 two pointer 的使用场景， 在大部分情况下， 恰当地使用 two pointer 可以使时间复杂度保持在 O(n)， 像 online judge 里部分 medium 题经常提及的子数列类型问题， two pointer 也可以提供不错的切入角度。

<!-- more -->

## 前记

前几天和朋友讨论 Google 电面的一道题， 由此启发， 总结了下 two pointer 的使用场景， 在大部分情况下， 恰当地使用 two pointer 可以使时间复杂度保持在 O(n)， 像 online judge 里部分 medium 题经常提及的子数列类型问题， two pointer 也可以提供不错的切入角度。

## Two Sum

### Original

**Question** [EASY] 找到两个数， 其和为指定数量。 Given an array of integers, find two numbers such that they add up to a specific target number.

The function twoSum should return indices of the two numbers such that they add up to the target, where index1 must be less than index2. Please note that your returned answers (both index1 and index2) are not zero-based.

很典型的two sum问题。除去brute force的n方时间复杂度的算法，还有n的方法。简单来说， 用hashmap找另一个值是否存在， 典型的用空间换时间， 这里空间复杂度也是n。

```java
/**
 * Hashmap implementation. O(n) runtime, O(n) space.
**/
public int[] twoSum(int[] numbers, int target) {
  Map<Integer, Integer> map = new HashMap<>();
  for (int i = 0; i < numbers.length; i++){
    if (map.containsKey(target - numbers[i])) {
      return new int[] { i + 1, map.get(target - numbers[i]) + 1};
    }
    else{
      if (!map.containsKey(numbers[i])){ // edge case: duplicate items.
        map.put(numbers[i], i);
      }
    }
  }
  throw new IllegalArgumentException("No two sum solution");
}
```

Hashmap特别要注意的地方就是对于duplicates的考虑， 题目究竟是返回true or false就可以了， 还是需要返回所有符合的index， 还是只是最小（或最大）的index， 都会有不同的实现方案。

### Sorted

如果integer array已经排序过了的话，可以用两个pointer来实现n时间1空间复杂度的方案； 不难理解， 两个pointer从两头往中间移动， 其sum只有三种可能， 和比要求的target小， 那么起始点的pointer右移， 和比要求大， 末尾pointer左移， 直到得到和或者return没有结果为止。

```java
/**
 * Two pointer implementation. Given that array is sorted. O(n) runtime, O(1) space.
**/
public int[] twoSum(int[] numbers, int target) {
  int p1 = 0;
  int p2 = size - 1;
  while (p1 < p2){
    if (numbers[p1] + numbers[p2] < target) {
      p1 += 1;
    }
    else if (numbers[p1] + numbers[p2] > target) {
      p2 -= 1;
    }
    else {
      return new int[] {p1, p2};    
    }
  }
  throw new IllegalArgumentException("No two sum solution");
}
```

留意一下two pointer适合哪些情景? 基础的变式是通过两个移动不同步长的pointer来完成一些事情， 也在暗指， 本身iterate through的这个array必须存在一些特性使得pointer可以有不同的移动。

### Tricks

借此稍微总结一下， 运用到two pointer的场景和技巧。

**Question** [EASY]合并两个sorted array变成一个sorted array。 Given two sorted arrays A and B, each having length N and M respectively. Form a new sorted merged array having values of both the arrays in sorted format.

利用设置在两个sorted array开头的指针， 来达到m+n时间复杂度的效果。 比较简单。

**Question** [EASY]一次循环找到链表的中间元素。How to find middle element of linked list in one pass?

**Question** [EASY]判断一个链表是否存在环。 How to find if linked list has a loop ?

**Question** [EASY]找到链表中倒数第三个元素。How to find 3rd element from end in a linked list in one pass?

以上都是关于单向链类似的问题， 利用two pointer都可以得到快速的解答。

### Example1 - continuous maximum subarray

**Question** [MEDIUM]找到不大于M的连续最大和子数列。 Given an array having N positive integers, find the contiguous subarray having sum as great as possible,, but not greater than M. 

其实第二题还涉及到了另一个技巧， 就是在对于部分求和问题里， 使用cumulative sum array是一个可能的切入口。 在将原数列生成对应的cumulative sum array之后， 这个题目也就相应转换为找到两个index， 使得对于这个递增的和数列， 满足：`cum[endIndex] - cum[startIndex-1] <= M and cum[endIndex+1] - cum[startIndex-1] > M`的条件， 而`endIndex`和`startIndex`在原数列里对应的子数列， 就是满足要求的最大和子数列。

转换了题意之后， 对于这个递增数列， 可以接着用two pointer的思想来处理， 设置start和end两个pointer从头开始， 右移end指针只到不能满足需求为止，然后右移start指针来减少sum使得end指针可以继续右移。 记录下每次start指针右移是的sum， 最大的那个sum所对应的指针位置， 对应回原数列， 就是我们想要找到的连续最大和子数列。**可以说， 这道题的突破口是利用cumulative sum来创造一个递增的数列， 从而使two pointer的实现方式更为简洁。**

```java
public int[] main(int[] numbers, int ceiling) {
  int[] cumSum = new int[numbers.length() + 1]; // obtain cumulative sum.
  int sum = 0;
  cumSum[0] = 0;
  for (int i = 0; i < numbers.length(); i++) {
    sum += numbers[i+1];
    cumSum[i+1] = sum;
  }
  int l = 0, r = 0; // two pointers start at tip of the array.
  int max = 0;
  int[] ids = new int[2];
  while (l < cumSum.length()) {
    while (r < cumSum.length() && cumSum[r] - cumSum[l] <= M) {
      r++;
    }
    if (cumSum[r-1] - cumSum[l] > max) { // since cumSum[0] = 0, thus r always > 0.
      max = cumSum[r-1] - cumSum[l];
      ids[0] = l; ids[1] = r;
    }
    l++;
  }
  return ids;
}
```

### Example2 - continuous minimum distinct subarray

**Question** [MEDIUM]找到至少含有K个不同数字的连续最小和子数列。 Given an array containing N integers, you need to find the length of the smallest contiguous subarray that contains atleast K distinct elements in it. Output "−1−1" if no such subarray exists.

从题意上和上一问求连续最大和子数列很像， 其实处理方式也有共同之处， 利用cumulative sum来负责和的部分， 利用set的实现来负责distince element的部分， 和之前相比end指针移动的条件， 更换为使得set中元素至少有K个， 记录此时sum和对应得`end - start`得长度， 然后移动start指针， 更新set元素， 由此往复。n的时间复杂度。

### Example3 - minimum hustle subsequence

**Question** [MEDIUM] 找到K个给出最小hustle值的子数列， 不要求连续。 Given an array having N integers, you need to find out a subsequence of K integers such that these K integers have the minimum hustle. Hustle of a sequence is defined as sum of pair-wise absolute differences divided by the number of pairs. 

明确了hustle值， 也就是pair的差绝对值之和之后， 对于不要求连续的子数列找最小值， 可以利用sorting来排序， 转换为类似寻找连续最小和子数列的类型。可以稍微改变上题的方法来处理这道题。nlogn + n的时间复杂度。

### Example4 - Google phone interview

前几天看到朋友发的Google的其中一道电面的题， 和上面讨论的题型很像， 不过稍加改动之后还更简单了。

**Question** [EASY] 找到number X满足最大cover。Given a set S of 10^6 doubles. Find a number X so that the [X, X+1) half-open real interval contains as many elements of S as possible.For example, given this subset:[2.7, 0.23, 8.32, 9.65, -6.55, 1.55, 1.98, 7.11, 0.49, 2.75, 2.95, -96.023, 0.14, 8.60], the value X desired is 1.98 because there are 4 values in the range 1.98 to 2.97999 (1.98, 2.7, 2.75, 2.95)

首先还是将数字sort一遍， 之后可以将题目转换为two pointer的类型。`array[end] - array[start] < 1`， 同时使得collection的size最大。 每次end指针右移， 添加element到collection里面， 在start指针右移的时候记录下对应的`array[start]`的值和collection的size， 最后拿到当collection的size最大的时候的那个元素值就可以满足在`[X, X+1)`的区间中数列的元素最多了。 由于不需要考虑distinct element， 所以采用collection而不是set。 达到O(n)的时间复杂度， 较优的解法。

### Example5 - three pointers

**Question** [MEDIUM] 找到最长只含有两个不同字母的子数列长度。 Given a string S, find the length of the longest substring T that contains at most two distinct characters. For example, Given S = “eceba”, T is "ece" which its length is 3.

仍然是two pointer的变式， 在维持two pointer的移动规则， 以及保持map的元素一直为两个的同时， 利用第三个pointer来从map中移除元素。在这种情况下不是简单的每次直接移除一个， 而是利用第三个pointer来移除移除元素到map里只剩两个元素。之所以用map而不用set的原因是， 移除一个字符并不代表后面就没有该元素重复， 而是采用`map<char, int>`来计数， 当int为0时才从map的key中移除该字符。

```java
/**
 * find longest substring with at most two distinct elements.
 */
public int longestSubstringTwoDistinctElement(String s) {
	int l = 0, m = 0, r = 0;
   int maxLen = 0;
   Map<char, int> map = new HashMap<char, int>();
   while (r < s.length()) {
      while (map.size() < 3) { // keep the set fixed.
         maxLen = max(maxLen, r - l);
         r++;
         if (map.containsKey(s[r])) {
            map.put(s[r], map.get(s[r]) + 1);
         } else {
            map.put(s[r], 1);
         };
      }

      m = l; // pointer m moves the from left till map becomes two.
      while (map.size() > 2) {
         if (map.get(s[m]) > 1) {
            map.put(s[m], map.get(s[m]) - 1);
         } else { // remove that char from map.
            map.remove(s[m]);
         }
         m++;
      }
      l = m;
   }
}

/*
   Method2: Compare with using map, if we know string only contains ASCII characters, then we can use int[256] to replace with a map<char, int>, since ASCII contains 127 characters, while use 8 bits leave one space for signed or unsigned.
 */
public int lengthOfLongestSubstringTwoDistinct(String s) {
   int[] count = new int[256];
   int i = 0, numDistinct = 0, maxLen = 0;
   for (int j = 0; j < s.length(); j++) {
      if (count[s.charAt(j)] == 0) numDistinct++;
      count[s.charAt(j)]++;
      while (numDistinct > 2) {
         count[s.charAt(i)]--;
         if (count[s.charAt(i)] == 0) numDistinct--;
         i++;
      }
      maxLen = Math.max(j - i + 1, maxLen);
   }
   return maxLen;
}
```

## Substring

**Question** [EASY] 查找是否存在子字符串。Implement strstr(). Returns the index of the first occurrence of word1 in word2, or -1 if word1 is not part of word2.

其实典型做法就是科班的KMP算法， mn的时间复杂度， 注意的点还是在于对部分edge cases的考虑。

```java
public int strstr(String raw, String template) {
	for (int i = 0; i < raw.length(); i++) {
		for (int j = 0; j < template.length(); j++) {
			if (i > raw.length() - template.length()) return -1;
			if (template.charAt(j) != raw.charAt(i + j)) break;
		}
		if (j == template.length()) return i;
	}
}
```



## Reverse Words in String

**Question** [EASY] 将字符串中的单词们首位调换位置。Reverse words in string. Given an input string s, reverse the string word by word. For example, given s = "the sky is blue", return "blue is sky the".

注意的点在于使用StringBuilder而不是String concatenation， 因为StringBuilder不需要每次在赋值的时候再创建一个新的对象。 同时和这类题型特别相似的还有将某个integer array向某个方向rotate的， 存在类似的技巧。

### Original

基础的做法：

```java
// parse token, reverse them. n time, n space.
public String reverse(String s) {
	String[] tokens = s.split("\\s+");
	String result = "";
	for(int i = 0; i < tokens.length(); i++) {
		result += tokens[tokens.length() - 1 - i];
	}
	return result;
}
```

如果不允许使用`split()`来parse token的话， 可以尝试two pointer的方式， 一个负责track单词的起始位置， 一个负责track结束位置， 然后跳过空格继续执行。

```java
// do better with only one pass, without using split util function. By using two pointers, one tracks the word's beginning, one tracks the end. n time n space.
public String reverse(String s) {
	int start = s.length() - 1;
	int end = s.length() - 1;
	StringBuilder result = new StringBuilder();
	while (start > 0) {
		while (!s.charAt(end)) { // start with a non-space word.
			start--;
			end--;
		}
		while(s.charAt(start)) start--;
		if (result.length() != 0) {
			result.append(' ');
		}
		result.append(s.substring(start + 1, end));
		end = start;
	}
	return result;
}
```

### Tricks

以上提到的两种方法都是n时间n空间， 也就是我们都创建了一个新的array返回， 也有直接在原数列做交换的方式， 正是上文提到的关于rotate类型的技巧。由于我们观察到：如果给每一个单词都reverse一遍， 最后再整个字符串reverse一遍， 可以得到相同的结果， 比如：
- raw： “ab bc cd”
- target： “cd bc ab”
  - reverse each word from raw： “ba cb dc”
  - reverse whole string：“cd bc ab”， same as target string.

```java
/*
	Reverse words in string, but do it with n time, 1 space.
	- one brilliant idea is, by reversing words first, then reverse the whole string. It has the same effect as reverse words in string.
 */
public void reverse(char[] s) {
	rotate(s);
	for(int i = 0, j = 0; j <= s.length(); j++) {
		if(s[j] == ' ' || j == s.length()){
			rotate(s, i, j);
			i = j + 1;
		}
	}
}

public void rotate(char[] s, int start, int end) {
	for(int i = 0; i < (end - start) / 2; i++) {
		char temp = s[start + i];
		s[start + i] = s[end - i - 1];
		s[end - i - 1] = temp;
	}
}
```

### More

类似的还有刚刚提及的将某数列向某方向rotate的题型， Rotate an array to the right by k steps in-place without allocating extra space. For instance, with k = 3, the array [0, 1, 2, 3, 4, 5, 6] is rotated to [4, 5, 6, 0, 1, 2, 3]. 

同样可以用到reverse的技巧。

```java
public void rotateRight(int[] numbers, int step) {
	rotate(numbers, 0, numbers.length() - step);
	rotate(numbers, numbers.length() - step + 1, numbers.length());
	rotate(numbers, 0, numbers.length());
}

public void rotate(int[] numbers, int start, int end) {
	for(int i = 0; i < (end - start) / 2; i++) {
		int temp = numbers[start + i];
		numbers[start + i] = numbers[end - i - 1];
		numbers[end - i - 1] = temp;
	}
}
```

## Reading

- [quora-two pointer algorithm](https://tp-iiita.quora.com/The-Two-Pointer-Algorithm)
- [leetcode](https://leetcode.com/)

## 后记

刚开始用Java， 其实主要还是平时写Spring Boot的时候用的比较多， 如果上述的算法有错误或者忽略了edge cases的考虑， 欢迎在评论区指出。 同时大部分问题都存在其他或许更优的解法， 欢迎一起讨论~