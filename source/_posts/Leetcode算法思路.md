title: Leetcode算法思路
date: 2018-06-30 10:32:06
tags: [算法, leetcode, interview, C++]
categories: 技术
---

My Leetcode solution analysis. 

<!-- more -->

## algorithm summary

### median

A position that the number of elements at two sides is the same.

Problems: NO.4


### two pointer

Essentially a way of searching. find the direction of keeping the sub-structure optimality. keep the optimality and explore\compare.

Problems: NO.11


## data structure summary

### trie(prefix tree)

```c++
// trie node
struct TrieNode
{
    struct TrieNode *children[ALPHABET_SIZE];

    // isEndOfWord is true if the node represents
    // end of a word
    bool isEndOfWord;
};

// Returns new trie node (initialized to NULLs)
struct TrieNode *getNode(void){
    struct TrieNode *pNode =  new TrieNode;
    pNode->isEndOfWord = false;

    for (int i = 0; i < ALPHABET_SIZE; i++)
        pNode->children[i] = NULL;

    return pNode;
}

// If not present, inserts key into trie
// If the key is prefix of trie node, just
// marks leaf node
void insert(struct TrieNode *root, string key)
{
    struct TrieNode *pCrawl = root;

    for (int i = 0; i < key.length(); i++)
    {
        int index = key[i] - 'a';
        if (!pCrawl->children[index])
            pCrawl->children[index] = getNode();

        pCrawl = pCrawl->children[index];
    }

    // mark last node as leaf
    pCrawl->isEndOfWord = true;
}
```
> Note the coding way in method `insert()`, we use a new variable `struct TrieNode *pCrawl` to iterate through the `key`, so that it doesn't change the position of `*root`.

- https://www.geeksforgeeks.org/trie-insert-and-search/