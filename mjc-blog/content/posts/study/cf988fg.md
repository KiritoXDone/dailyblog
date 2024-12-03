---
title: "Codeforces Round 988 (Div. 3) F and G" #标题
date: 2024-11-28T19:31:47+08:00 #创建时间
lastmod: 2024-11-28T19:31:47+08:00 #更新时间
author: ["KiritoXD"] #作�?tags: 
tags:
- "补题"
description: "" #描述
categories: ['Study'] #分类
summary: "昨天差的两题补在这了" #描述
weight: # 输入1可以顶置文章，用来给文章展示排序，不填就默认按时间排�?slug: ""
draft: false # 是否为草�?showToc: true # 显示目录
TocOpen: true # 自动展开目录
hidemeta: false # 是否隐藏文章的元信息，如发布日期、作者等
disableShare: true # 底部不显示分享栏
showbreadcrumbs: true #顶部显示当前路径
---
### F. Ardent Flames

读题易想到二分答案

二分次数，对于每个怪物 $i$，已知当前攻击的次数，就能得到每次攻击必须造成的伤害

+   如果这个伤害大于 $m$，那么跳过它，这个怪物不可选
+   反之将 $\begin{bmatrix}
x_i-\left(m-\left\lceil\frac{h_i}{t}\right\rceil\right),x_i+\left(m-\left\lceil\frac{h_i}{t}\right\rceil\right)
\end{bmatrix}$ 左右端分别储存，通过离散化来查找同处于某区间内数的个数，记录个数的最大值，如果大于 $k$，当前 $check$ 即为 $1$

```c
#include <bits/stdc++.h>
using namespace std;
#define ls now<<1
#define rs now<<1|1
#define endl "\n"
#define lowbit(x) ((x)&(-x))
typedef long long ll;
const int N=1e5+7, mod=1e9+7;

int n,m,k;
int x[N],h[N];

bool check(int mid){
    deque<int>p,q;
    int cnt=0,mx=0;
    for(int i=1;i<=n;i++){
        int dmg=ceil(1.0*h[i]/mid);
        if(dmg>m)continue;
        int cha=m-dmg;
        p.push_back(x[i]-cha),q.push_back(x[i]+cha+1);
    }
    sort(p.begin(),p.end());
    sort(q.begin(),q.end());
    while(p.size()&&q.size()){
        if(p.front()==q.front())q.pop_front(),p.pop_front();
        else if(p.front()<q.front())p.pop_front(),cnt++;
        else q.pop_front(),cnt--;
        mx=max(mx,cnt);
    }
    return mx>=k;
}

void solve(){
    cin>>n>>m>>k;
    for(int i=1;i<=n;i++)cin>>h[i];
    for(int i=1;i<=n;i++)cin>>x[i];
    int l=1,r=mod,ans=-1;
    while(l<=r){
        ll mid=(l+r)>>1;
        if(check(mid)){
            r=mid-1;
            ans=mid;
        }
        else l=mid+1;
    }
    cout<<ans<<endl;
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

### G. Natlan Exploring

可以想到用 dp 来统计答案，$f_i = f_i + f_j \quad (1 \leq j < i, \gcd(a_i, a_j) \neq 1)$

但是直接暴力统计是 $O(n^2)$ 的，显然不行，要优化，$gcd$ 具体值无所谓，只要不为 $1$，那么只要两数互质即可，即没有相同的质因数就行了

考虑对 $a[i]$ 分解，然后暴力统计符合情况的，但这样依然容易被卡掉

所以还需要优化

可以发现，其实真正有用的数，就是由质因数倍增产生关系的，将 x 产生的数放在一起，再计算这个 x 会对答案造成的贡献，但是这样会重复计算，所以要考虑容斥，只需要在计算时看 质因子的个数，如果为奇数，就加上，反之，则减去

```cpp
#include <bits/stdc++.h>
using namespace std;
#define ls now<<1
#define rs now<<1|1
#define endl "\n"
#define lowbit(x) ((x)&(-x))
typedef long long ll;
const int N=1e6+7, mod=998244353;

int n,a[N],b[N],f[N];
vector<int>g[N],h[N];

void fc1(int x,int id){
    for(int i=2;1ll*i*i<=x;i++){
        if(x%i==0){
            h[id].push_back(i);
            while(x%i==0)x/=i;
        }
    }
    if(x>1)h[id].push_back(x);
}

void fc2(int id){
    int x=1;
    for(auto t:h[id])x*=t;
    for(int i=2;1ll*i*i<=x;i++){
        if(x%i==0){
            g[id].push_back(i);
            if(x!=i)g[id].push_back(x/i);
        }
    }
    if(x>1)g[id].push_back(x);
}

void solve(){
    cin>>n;
    int mx=0;
    for(int i=1;i<=n;i++){
        cin>>a[i];
        mx=max(mx,a[i]);
    }
    for(int i=2;i<=mx;i++){
        fc1(i,i),fc2(i);
    }
    f[1]=1;
    for(int i=1;i<=n;i++){
        for(auto x:g[a[i]]){
            if(h[x].size()&1)f[i]=(f[i]+b[x])%mod;
            else f[i]=(f[i]-b[x]+mod)%mod;
        }
        for(auto x:g[a[i]])b[x]=(b[x]+f[i])%mod;
    }
    cout<<f[n]<<endl;
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