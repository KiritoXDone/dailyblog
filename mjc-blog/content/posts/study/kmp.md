---
title: "KMP" #标题
date: 2024-07-20T21:33:32+08:00 #创建时间
lastmod: 2024-07-20T21:33:32+08:00 #更新时间
author: ["KiritoXD"] #作者
tags: 
- "kmp"
- "string"
- "exkmp"

description: "KMP算法学习记录" #描述
weight: # 输入1可以顶置文章，用来给文章展示排序，不填就默认按时间排序
slug: ""
draft: false # 是否为草稿
showToc: true # 显示目录
TocOpen: true # 自动展开目录
hidemeta: false # 是否隐藏文章的元信息，如发布日期、作者等
disableShare: true # 底部不显示分享栏
showbreadcrumbs: true #顶部显示当前路径
---

# KMP学习记录
---
## 理念学习

字符串匹配问题 查找s中p是否出现  
暴力匹配 O(nm)  
哈希优化 O(n+m)  
KMP 线性复杂度解决 O(n+m)  
KMP 中对于 s 中每个位置 i，我们要找到最大的 j 满足s[i - j +1]...s[i] 和 p[1]...[j] 相同  
f[i] 对应j的位置，j对应p中的位置  
如果 j 不等于 m，并且 s[i + 1] == p[j + 1]，j 右移一位  
否则，j 向前回退，到满足 s[i - k + 1]...s[i] == p[1]...[j] 且 k 最大的位  
如果 s[i + 1] 仍不等于 p[j + 1]，不停向前回退，直到相等或 j = 0  

快速求出 k  
易得到求 k 与 s 无关  
最大的 k 满足 k < j,使得 p[1]..p[k] 和 p[j - k + 1]...p[j] 完全相同  
可以用 next 维护每个 j 对应的 k  

```c
void kmp(){
    n=s.size()+1,m=p.size()+1;//字符串下标从 1 开始
    int j=0;
    nxt[1]=0;
    for(int i=2;i<=m;i++){
        while(j>0&&p[j+1]!=p[i])
            j=nxt[j];
        if(p[j+1]==p[i])
            j++;
        nxt[i]=j;
    }
    j=0;
    for(int i=1;i<=n;i++){
        while((j==m)||(j>0&&p[j+1]!=s[i]))
            j=nxt[j];
        if(p[j+1]==s[i])
            j++;
        f[i]=j;
    }
}
```
---
## 洛谷例题

[P3375](https://www.luogu.com.cn/problem/P3375 "P3375 【模板】KMP")



```
#include <bits/stdc++.h>
using namespace std;
const int N = 1e6+10;

int n, m;
string s, p;
int nxt[N], f[N];

void kmp() {
    n = s.size();
    m = p.size();
    nxt[0] = 0;
    int j = 0;
    for (int i = 1; i < m; i++) {
        while (j > 0 && p[i] != p[j])
            j = nxt[j - 1];
        if (p[i] == p[j])
            j++;
        nxt[i] = j;
    }
    j = 0;
    for (int i = 0; i < n; i++) {
        while (j > 0 && s[i] != p[j])
            j = nxt[j - 1];
        if (s[i] == p[j])
            j++;
        f[i] = j;
        if (j == m) {
            cout << i - m + 2 << endl;
            j = nxt[j - 1];
        }
    }
    for (int i = 0; i < m; i++) {
        cout << nxt[i] << " ";
    }
    cout << endl;
}

int main() {
    cin >> s >> p;
    kmp();
    return 0;
}
```
---
# EXKMP(Z-algorithm)

## 理论学习 

线性时间复杂度求出字符串s和他的任意后缀 s[i]...s[n] 的最长公共前缀的长度 O(n)  

与 kmp 的区别：一个是到 s[i] 结束，一个是从 s[i] 开始  

定义 z[1] = 0，从 2 到 n 枚举 i，依次计算 z[i] 的值  
计算 z[i] 时，前面的 z 都已经计算好了  
对于 j，有 s[j]...s[j + z[j] - 1] 和 s[1]...s[z[j]] 完全相等  

为了计算 z[i]，在枚举i的过程中，需要维护R的最大区间 [L, R],其中 L = j，R =j + z[i] - 1  
初始时 L = 1,R = 0  
如果 i <= R:  
    易知 s[L]...s[R] = s[1]...s[R - L + 1]  
    令 k = i - L + 1,i 与 k 的位置对应，此时s[i]..s[R] = s[k]..s[R - L + 1]  
    如果 z[k] < R - i + 1，说明从 k 开始匹配不到那么远，也就是从 i 开始匹配不到 R，此时 z[i] = z[k]  
    反之，说明可以匹配到 R 那么远，从 R+1 开始往后暴力  
如果 i > R:  
    暴力枚举匹配，记得更新 L 和 R   

```c
void exkmp(){
    int L=1,R=0;
    z[1]=0;
    for(int i=2;i<=2;i++){
        if(i>R)
            z[i]=0;
        else{
            int k=i-L+1;
            z[i]=min(z[k],R-i+1);
        }
        while(i+z[i]<=n&&s[z[i]+1]==s[i+z[i]])
            ++z[i];
        if(i+z[i]-1>R)
            L=i,R=i+z[i]=1;
    }
}
```

## 例题
给出字符串 s, p,求 s 中 p 出现的次数和位置
```
#include <bits/stdc++.h>
using namespace std;

string s,p;
int z[200001],n,m;

void exkmp(){
    n=s.size();
    m=p.size();
    p=p+"#"+s;
    int L=0,R=-1;
    z[0]=0;
    for(int i=1;i<n+m+1;i++){
        if(i>R)
            z[i]=0;
        else{
            int k=i-L;
            z[i]=min(z[k],R-i);
        }
        while(i+z[i]<n+m+1&&p[z[i]]==p[i+z[i]])
            ++z[i];
        if(i+z[i]-1>R)
            L=i,R=i+z[i]-1;
    }
    int ans=0;
    for(int i=m+1;i<m+n+1;i++)
        if(z[i]==m)ans++;
    cout<<ans<<endl;
    for(int i=m+1;i<n+m+1;i++)
        if(z[i]==m)cout<<i-m<<endl;
}

int main(){
    cin>>s>>p;
    exkmp();
    return 0;
}
```