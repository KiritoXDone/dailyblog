---
title: "2024CCPC网络赛" #标题
date: 2024-09-10T14:45:39+08:00 #创建时间
lastmod: 2024-09-10T14:45:39+08:00 #更新时间
author: ["KiritoXD"] #作者
tags: 
- "补题"
description: "" #描述
weight: # 输入1可以顶置文章，用来给文章展示排序，不填就默认按时间排序
slug: ""
draft: false # 是否为草稿
showToc: true # 显示目录
TocOpen: true # 自动展开目录
hidemeta: false # 是否隐藏文章的元信息，如发布日期、作者等
disableShare: true # 底部不显示分享栏
showbreadcrumbs: true #顶部显示当前路径
---
# 前言

好久没写题了，被暴打。  
参赛过程也是抽象，开局就罚站 30 min  

---

# 补题

## L 网络预选赛
好不容易卡出来题面，看到 L 已经过了不少了，卡了半天才提交过  

```c
#include <bits/stdc++.h>
using namespace std;
#define ls now<<1
#define rs now<<1|1
#define endl "\n"
typedef long long ll;
const int N=1e3+7, mod=1e9+7;

void solve(){
    int n, m, ans = 0;
    char mp[N][N];
    cin >> n >> m;
    for(int i = 1; i <= n; i++)
        for(int j = 1; j <= m; j++) cin >> mp[i][j];
    
    for(int i = 1; i < n; i++){
        for(int j = 1; j < m; j++){
            if(mp[i][j] == 'c' && mp[i+1][j] == 'p' && mp[i][j+1] == 'c' && mp[i+1][j+1] == 'c') ans++;
        }
    }
    cout << ans << endl;
}

int main(){
    ios::sync_with_stdio(0);
    cin.tie(0); cout.tie(0);
    int t = 1;
    // cin >> t;
    while(t--) solve();
    return 0;
}
```

## K 取沙子游戏

奇数时，一直取 1 即可。  
为偶数时，如果 $lowbit(n)<=k$，先手取 $lowbit(n)<=k$，再不断模仿后者即可。  
反之，随意取后的 $lowbit$ 一定 $<=k$，后手一定获胜  

```c
#include <bits/stdc++.h>
using namespace std;
#define ls now<<1
#define rs now<<1|1
#define endl "\n"
#define lowbit(x) ((x)&(-x))
typedef long long ll;
const int N=1e5+7, mod=1e9+7;

void solve(){
    int n,k;
    cin>>n>>k;
    if(lowbit(n)<=k)cout<<"Alice\n";
    else cout<<"Bob\n";
}

int main(){
    ios::sync_with_stdio(0);
    cin.tie(0);cout.tie(0);
    int t=1;
    cin>>t;
    while(t--)solve();
    return 0;
}
```
## B 军训 II
显然是排序后的不整齐度最小，那么方案数就是数组中的重复数的排列组合之和，要注意有升序降序两种，但只有一种数时不考虑

```c
#include <bits/stdc++.h>
using namespace std;
#define ls now<<1
#define rs now<<1|1
#define endl "\n"
#define lowbit(x) ((x)&(-x))
typedef long long ll;
const int N=1e6+7, mod=998244353;

ll n,a[N],ans=0,vis[N],cnt=0,answ=1,com[N];

void solve(){
    cin>>n;
    com[0]=1;
    for(int i=1;i<=n;i++){
        com[i]=(com[i-1]*i)%mod;
    }
    for(int i=1;i<=n;i++){
        cin>>a[i];
        if(!vis[a[i]])cnt++;
        vis[a[i]]++;
    }
    sort(a+1,a+1+n);
    for(int i=1;i<=n;i++){
        ll mx=a[i],mn=a[i];
        for(int j=i+1;j<=n;j++){
            mx=max(mx,a[j]),mn=min(mn,a[i]);
            ans+=(mx-mn);
        }
    }
    for(int i=1;i<=n;i++){
        if(vis[a[i]]==1)continue;
        answ=(answ*com[vis[a[i]]])%mod;
        vis[a[i]]=1;
    }
    if (cnt > 1) answ = (answ * 2) % mod;
    cout<<ans<<" "<<answ<<endl;
}

int main(){
    ios::sync_with_stdio(0);
    cin.tie(0);cout.tie(0);
    int t=1;
    // cin>>t;
    while(t--)solve();
    return 0;
}
```
## D 编码器-解码器

观察题目  
$S_i'=\begin{cases}S_{i-1}'+a_i+S_{i-1}'&\text{if}i>1\\a_1&\text{if}i=1\end{cases}$
可以发现 $S_{i}'$ 是由 $S_{i-1}'$ 变换而来的，所以可以递推每一位 $i$ 上的答案  
可以开一个三维数组 $f[i][l][r]$ : $i$ 指第几位  $l$ 指从 $t$ 的第几位开始  $r$ 指到 $t$ 的第几位结束  
通过这种方法，我们可以记录 $t$ 的所有子串在当前 $i$ 位出现的次数，只需要将我们需要的子串拼接起来即可得到能找到的 $t$ 串数量 

```c
#include <bits/stdc++.h>
using namespace std;
#define ls now<<1
#define rs now<<1|1
#define endl "\n"
#define lowbit(x) ((x)&(-x))
typedef long long ll;
const int N=1e2+7, mod=998244353;

string s,t;
int n,m;
ll f[N][N][N];

void solve(){
    cin>>s>>t;
    n=s.length(),m=t.length();
    for(int i=0;i<m;i++)
        if(s[0]==t[i])f[0][i][i]=1;
    for(int i=1;i<n;i++){
        for(int l=0;l<m;l++){
            for(int r=l;r<m;r++){
                f[i][l][r]=(f[i-1][l][r]*2) % mod;
                if(l==r){
                    if(s[i]==t[l])f[i][l][r]=(f[i][l][r]+1) % mod;
                }
                else{
                    if(s[i]==t[l])f[i][l][r]=(f[i][l][r]+f[i-1][l+1][r]) % mod;
                    if(s[i]==t[r])f[i][l][r]=(f[i][l][r]+f[i-1][l][r-1]) % mod;
                    for(int k=l;k<r;k++)
                        f[i][l][r]=(f[i][l][r]+f[i-1][l][k]*f[i-1][k+1][r]) % mod;
                    for(int k=l+1;k<r;k++)
                        if(s[i]==t[k])f[i][l][r]=(f[i][l][r]+f[i-1][l][k-1]*f[i-1][k+1][r]) % mod;
                }
            }
        }
    }
    cout<<f[n-1][0][m-1]<<endl;
}

int main(){
    ios::sync_with_stdio(0);
    cin.tie(0);cout.tie(0);
    int t=1;
    // cin>>t;
    while(t--)solve();
    return 0;
}
```
