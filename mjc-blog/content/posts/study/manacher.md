---
title: "Manacher" #标题
date: 2024-07-22T22:59:43+08:00 #创建时间
lastmod: 2024-07-22T22:59:43+08:00 #更新时间
author: ["KiritoXD"] #作者
tags: 
- "manacher"
- "string"
description: "Manacher 学习记录" #描述
weight: # 输入1可以顶置文章，用来给文章展示排序，不填就默认按时间排序
slug: ""
draft: false # 是否为草稿
showToc: true # 显示目录
TocOpen: true # 自动展开目录
hidemeta: false # 是否隐藏文章的元信息，如发布日期、作者等
disableShare: true # 底部不显示分享栏
showbreadcrumbs: true #顶部显示当前路径
---
# Manacher
---
## 理念学习

解决最长回文子串问题

给出一个任意字符串，求出这个字符串中最长的回文子串

正常情况下，需要对长度奇偶不同的分类讨论。但可以用一个 s 中不存在的字符，把 s 中每一位隔开，再求新串中奇数长度的最长回文子串即可

对于新串 s ，我们的目的是求出从它的任意位置 i 出发，往两边最远能拓展出的回文子串的长度，记做 p[i] (包括 i 本身，所以最小为 1)

维护 p[i] 的值：  
    维护一个到目前位置的R最大的区间 [L, R]，其中 L = M - p[M] + 1 (M < i) R = M + p[M] - 1  
    [L, R] 是一个回文串
    如果i <= R:  
        找到 i 对于 M 的对称点 k，此时 i - M = M - k,k = 2 * M - i;    
        此时有两种情况：  
            (1)如果 p[k] 对应的回文区间 [k - p[k] + 1, k + p[k] - 1]，不含左端点 L，说明这个回文区间在 [L, R] 之中，此时我们可以得到 p[i] = p[k]   
            (2)如果包含了左端点L，此时 [L, 2*k-L] 这一端为回文串。由于 [L, R] 是回文串，可得出 [2*i-R, R] 也是回文串。往两端暴力拓展即可。    
    如果 i > R：  
        暴力两端拓展即可    
    都要记得更新 M, L, R 的值。    

```c
void manacher(){
    n=s.size();
    t.resize(2*n+10);
    int m=0;
       t[0]='$';
    for(int i=0;i<n;i++){
        t[++m]=s[i],t[++m]='$';
    }
    int M=0,R=0;
    for(int i=0;i<m;i++){
        if(i>R)
            p[i]=1;
        else
            p[i]=min(p[2*M-i],R-i+1);
        while(i-p[i]>=0&&i+p[i]<=m&&t[i-p[i]]==t[i+p[i]])
            ++p[i];
        if(i+p[i]-1>R)
            M=i,R=i+p[i]-1;        
    }
    int ans=0;
    for(int i=0;i<=m;i++){
        ans=max(ans,p[i]);
    }
    cout<<ans-1<<endl;
}
```
---
## 洛谷例题

[P3805](https://www.luogu.com.cn/problem/P3805)  

```
#include <bits/stdc++.h>
using namespace std;
const int N = 2e7+10;

int n,p[2*N];
string s,t;

void manacher(){
    n=s.size();
    t.resize(2*n+10);
    int m=0;
    t[0]='$';
    for(int i=0;i<n;i++){
        t[++m]=s[i],t[++m]='$';
    }
    int M=0,R=0;
    for(int i=0;i<m;i++){
        if(i>R)
            p[i]=1;
        else
            p[i]=min(p[2*M-i],R-i+1);
        while(i-p[i]>=0&&i+p[i]<=m&&t[i-p[i]]==t[i+p[i]])
            ++p[i];
        if(i+p[i]-1>R)
            M=i,R=i+p[i]-1;        
    }
    int ans=0;
    for(int i=0;i<=m;i++){
        ans=max(ans,p[i]);
    }
    cout<<ans-1<<endl;
}

int main(){
    cin>>s;
    manacher();
    return 0;
}
```
坑点：字符串 t 要 resize，不然 re
