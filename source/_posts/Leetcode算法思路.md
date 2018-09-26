title: Leetcode常用数据结构和算法总结(python实现)
date: 2018-06-30 10:32:06
tags: [算法, leetcode, interview, C++]
categories: 技术
description: My Leetcode solution analysis.
---

# Data Structure

### stack

单调栈的使用：
- 找到每个元素下一个更大的元素。

### palindrome

很多时候和prefix，suffix联系在一起。

### trie

和hash相比在存储string的时候的一些好处：
- 找到所有具有common prefix的keys
- 以字典顺序遍历所有string的时候
- 当hash不断增大的时候，会出现很多hash collitions，对于trie来说当大部分的字符串具有类似prefix的时候，效率比较高。
```python
# trie的具体python实现.
class Trie(object):
    def __init__(self):
        self.end = False # 需要这个属性来mark一下，是否到这个node为止组成的这个word存在！！比如insert('apple')之后，'app'最后'p'这个点的end应该是False的。
        self.c = {} # 利用recursion的想法，每个当前的children node都为一个Trie tree. key: char, val: new Trie().

    def insert(self, word):
        node = self
        for w in word:
            if w not in node.c:
                node.c[w] = Trie()
            node = node.c[w]
        node.end = True
            
    def prefixnode(self,word):
        node = self
        for w in word:
            if w not in node.c:
                return None
            node = node.c[w]
        return node
    
    def search(self, word):
        node = self.prefixnode(word)
        if not node:
            return False
        else:
            return True if node.end else False
            
    def startsWith(self, prefix):
        node = self.prefixnode(prefix)       
        return bool(node)
```

### sliding window

- two pointer sliding window

右指针先expand直到满足条件，然后左指针move直到break条件，常适用于找到最小区间。

- mono deque(double ended queue)

pop直到结构内元素单调然后push。

---

# Algorithm

### union find
```python
"""
最简单的版本
"""
# a parent array of N, record each position's root parent index. 
# if two points's root equals, then they are in same group.
def find(parent, idx):
	if parent[idx] == -1:
    	return idx
    return find(parent, parent[idx])

# 最简单的版本
# mark these two points as from same parent, by finding each one's and compare.
def union(parent, x, y):
	root_x = find(parent, x)
    root_y = find(parent, y)
    if root_x != root_y:
    	parent[x] = root_y
        
"""
优化后的版本
"""
class Node(object):
	def __init__(self):
    	self.parent = 0 # record parent node's index.
        self.rank = 0 # record current tree's rank, rooted at current node.

# 路径压缩版本：path-compression version.
# 每一次find的时候，都把自己的parent设为当前找到的parent。来避免worst case: O(n) 的 find time complexity。
# 设置parent[0] = 0 为总的根, 于是所有level为1的点，parent值都为0。
def find(parent, idx):
	while parent[idx] != idx:
    	parent[idx] = find(parent, parent[idx])
    return parent[idx]
    
# 最小树版本。
# 避免在随意合并的时候形成的worst case: O(n)的linked list形状，best case：balanced tree. 
# 让小rank的树append到大rank的树下，也就是设置小rank的parent
def union(parent, x, y):
	root_x = find(parent, x)
    root_y = find(parent, y)
    if root_x > root_y:
    	parent[y] = root_x
    elif root_x < root_y:
    	parent[x] = root_y
    else:
    	parent[x] = root_y
        root_y.rank += 1
```
在优化之后，查找find的first time worst case：O(logn)， 因为有path compression，之后所有的find操作都为常数，因此 amortized time complexity为O(1)。如果没有优化，worst case: O(n)。


### partition algorithm(in quicksort)
保持数组部分有序的方式，找到一个pivot，根据这个pivot对这个数组重新arrange之后保证pivot左边数字都比它小，而右边数字都比它大。T：O(n), S: O(1)。
```python
# two pointers, i and j, such that every elements at left of i are smaller than pivot, which gives that the elements between i and j are larger than the pivot. and finally swap the pivot with the index i position to yield the correct partition.
i = 0
j = 0
while j < len(s): # use j to iterate throught the array.
	if s[j] < pivot: # swap with index i, 
    	swap(i, j)
        i++
        j++
    elif s[j] > pivot:
    	j++
swap(i, pivot_index)

# Extension: 当存在和pivot值相同的元素的时候，如果需要将其置于中间，需要three pointers，多引入一个pointer k指向数组的最后，然后每当有元素大于pivot的时候，和k位置交换元素，同样利用j来遍历数组，保证小于i位置的都比pivot小，大于k位置的都比pivot大。
i = 0
j = 0
k = len(s) - 1
while j < len(s): # use j to iterate throught the array.
	if s[j] < pivot: # swap with index i, 
    	swap(i, j)
        i += 1
        j += 1
    elif s[j] > pivot:
    	swap(j, k)
        k -= 1
	else:
    	j += 1
```

### KMP string pattern matching

本质是找：针对一个string的最长prefix\suffix匹配。基于这个table，在pattern match的时候，当遇到部分匹配的情况时，我们可以利用match这部分的longest prefix\suffix match直接从suffix的位置继续开始匹配，而省略了其中的一部分匹配过程。
```python
# construct the lookup table, f(i) records that up till position i, the length of the longest prefix\suffix match.
f(0) = 0
for(i = 1; i < n; i++)
{
    t = f(i-1)
    while(t > 0 && b[i] != b[t])
        t = f(t-1)
    if(b[i] == b[t]){
        ++t
    f(i) = t
}
```

### Graph

关于图像遍历的算法常见技巧：
- 直接修改graph二维数组来做visited的作用，而不需要新建一个等大小的数组增加内存开销，尤其对于recursion影响大。

### BFS
算法重心在于level的累加，是当queue中来自上一层的所有node都pop出来之后，level += 1。
```python
from collections import deque
queue = []
queue.append(source)
level = 0
directions = [[0, 1], [1, 0], [0, -1], [-1, 0]]
while len(queue) > 0:
	level += 1
    size = len(queue)
    while size > 0:
    	size -= 1
        curr = queue.popleft()
        for dx, dy in directions:
        	newx, newy = curr[0] + dx, curr[1] + dy
            if new_position_valid():
            	grid[newx][newy] = 0 # mark visited.
                check_if_meet_final_target() # return level-related number.
                queue.append(newx, newy)
```

### find majority element

Q: there is one majority element in the array, it appear more than n/2 times. 

solutions:

- binary search tree with counting. 
insert the node into binary search tree, if such leaf already exists, increase the value of that node till one exceeds n/2. for a balanced binary tree, T: O(nlogn), S: O(n), need extra n space for creating binary tree.

- moore voting(find_candidate + validate)
validate的时间是O(n)。使用类似semaphore的想法。利用一个counter，如果相邻的连续是相同的就counter++，如果不同就清零更换一个character。

### product puzzle without division in O(n)

Q: given an array of element, return another array of same size, where each element is the product of all element except for itself. you cannot use division. do this in O(n) time.

- 构建左右累计数列。
一个很实用的技巧，当这个位置和其他所有位置的信息相关的时候，或者，如果naive的做法是基于每个点从中往外扩开的情况的话，可以考虑这个方向。也即，从左一次做累计操作，O(n)，同理从右也一遍。在本题中则是构建累乘数列，`L[i] = L[i- 1] * A[i - 1]`, `R[i - 1] = R[i] * A[i], i = n - 1, i--`. 则`prod = L[i] * R[i]`

### subarray\substring matching by hashing

应用比如 plagiarism。
构建一种算法，使得计算hash value的阶段可以累加，也就是说对于一串字符串来说，不需要每次在插入字符或者删除字符的时候对所有字符编码O(n)，而只需要O(1)的复杂度来更新hash value：
找到一个base，`next = (prev * base + new_char) % large_prime`，类比构建正数分位。


# General Tricks

- 在python里，当在循环里面需要匹配多个字符的时候，往往需要考虑边界问题，尤其是在循环停止之后漏掉的字符，这个时候多用slicing operation: `s[:i+1]`而不是直接用index ref这种： `s[i+1]`，因为slicing operation可以避免index overflow的问题。

- 大数相加、相乘时注意overflow的问题，在cpp和java里会出现，在python里不会。

- XOR可以用来辅助（A XOR A = 0; A XOR 0 = A）
  - even\odd apperance.
  - find missing number.
  - find duplicate.
  
- merge sort. 可以记录大小元素的先后顺序。可用于count inversions。

- quick sort. 核心在于partition，剩下的就是divide and conquer，在partition的时候，重点在O(n)的时间内，选取一个pivot，同时将所有比pivot点小的点移动到pivot左侧，比pivot点大的点移到右侧。本质上看，这个O(n)的操作，可以找到第n-index(pivot)大的元素也即pivot。可用于find k largest elements。

- space complexity优化的技巧。看每一次独立的遍历中依赖的变量数量。通常在dp问题里面会遇到。简单的情况是依赖于前一个或者前两个（fibonacci数列）的subproblems的答案，那么其实所需要的空间就为依赖的变量数即可，大部分dp都涉及构建一个两维的dp table，但如果每一次独立循环中问题只涉及本行和前一行的subproblems的答案，空间通常可以优化为max(row_size, column_size)，只需要每次不断地更新那一列即可。

- `y = x & !(x - 1)` will get the rightmost set bit of x. 因为(x - 1)的作用其实是反转所有rightmost set bit以右的bits。

- BST可以拓展来用于interval, number of elements in range。

- 关于heap和BST的区别：
  - 误区：heap的find max\min为O(1)，比BST更好。但其实我们可以用extra variable来拿BST的max\min从而达到同样的效果
  - 因为heap从底部插入数据，而bst是从顶部插入数据。所以heap的insert的amortized time complexity是O(1)因为最底层占了一半以上的数据。
  
- function stack也算作time complexity里。

- BST很多时候可以和divide and conquer\DP联系在一起。因为本质上每一个root都可以将range分为两个独立的range（subproblem）。结合具体问题进一步完整recursion或者dp table。

- 关于permutation&combination（排列组合），当选取的相同元素之间的排序不重要的时候，用组合combination, `C_(m+n)^(n) = (m+n)!/m!*n!`，当选取的相同元素之间的顺序也算的时候，用排列`A_(m+n)^(n) = (m+n)!/m!`
