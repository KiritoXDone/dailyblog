---
title: "Hpuacm1103" #标题
date: 2024-11-05T17:00:13+08:00 #创建时间
lastmod: 2024-11-05T17:00:13+08:00 #更新时间
author: ["KiritoXD"] #作者
tags: 
- "补题"
description: "" #描述
summary: "区域赛选拔赛补题" #描述
categories: ['Study'] #分类
weight: # 输入1可以顶置文章，用来给文章展示排序，不填就默认按时间排序
slug: ""
draft: false # 是否为草稿
showToc: true # 显示目录
TocOpen: true # 自动展开目录
hidemeta: false # 是否隐藏文章的元信息，如发布日期、作者等
disableShare: true # 底部不显示分享栏
showbreadcrumbs: true #顶部显示当前路径
---

牛魔的 vs code 刚开场就炸了，debug 纯靠输出在调  

### L - 附加题1 

读题可发现，只有相邻的会有干扰，那么除了第一个是 k 种可能，其他的都是 (k-1) 种选择  

```c
#include <bits/stdc++.h>
using namespace std;
#define ls now<<1
#define rs now<<1|1
#define endl "\n"
#define lowbit(x) ((x)&(-x))
#define int long long
typedef long long ll;
const int N=1e5+7, mod=1e9+7;

int ans=0,n,k;

void solve(){
    cin>>n>>k;
    ans=k;
    for(int i=2;i<=n;i++){
        ans*=(k-1);
    }
    cout<<ans<<endl;
}

signed main(){
    ios::sync_with_stdio(0);
    cin.tie(0);cout.tie(0);
    int t=1;
    // cin>>t;
    while(t--)solve();
    return 0;
}
```

### C - SYease

开始想用 dp 暴力写，喜提超时，然后暴力选最佳选项，再用剩余钱替换一部分片段，也错，但是达到了 28/30 误导了好久，以为这个是正解   

实际上就是先用最小价值确定长度，再用剩余的钱看从 9 到 0 能换几个比最小价值选项大的  

```c
#include <bits/stdc++.h>
using namespace std;
#define ls now<<1
#define rs now<<1|1
#define endl "\n"
#define lowbit(x) ((x)&(-x))
typedef long long ll;
#define int long long 
const int N=1e6+7, mod=1e9+7;

int n;

void solve(){
    cin>>n;
    int mn=10000000,pos=-1;
    for(int i=1;i<=9;i++){
        cin>>c[i].x;
        if(mn>=c[i].x){
            mn=c[i].x;
            pos=i;
        }
        c[i].id=i;
    }
    int len=n/mn;
    int lft=n-len*mn;
    if(!len){
        cout<<"0\n";
        return;
    }
    int cnt[10]={0};
    memset(cnt,0,sizeof(cnt));
    cnt[pos]=len;
    for(int i=9;i>=1;i--){
        if(i<=pos)break;
        int tmp=c[i].x-mn;
        if(tmp<=lft){
            int t=lft/tmp;
            if(t>cnt[pos])break;
            cnt[i]=t;
            cnt[pos]-=t;
            lft-=t*tmp;
        }
    }
    for(int i=9;i>0;i--){
        for(int j=1;j<=cnt[i];j++)cout<<i;
    }
}

signed main(){
    ios::sync_with_stdio(0);
    cin.tie(0);cout.tie(0);
    int t=1;
    // cin>>t;
    while(t--)solve();
    return 0;
}
```

### G - dyfhpu

要保证操作后数最小，且不能有先导零，其实就是在 k+1 前找最小的首位即可，再在后面开一个单调栈即可  

```c
#include <bits/stdc++.h>
using namespace std;
#define ls now<<1
#define rs now<<1|1
#define endl "\n"
#define lowbit(x) ((x)&(-x))
typedef long long ll;
const int N=1e5+7, mod=1e9+7;

int n,k;
string s;

void solve(){
    cin>>s>>k;
    n=s.size();
    int st=1e9;
    for(int i=0;i<=k;i++){
        if(s[i]-'0'>0){
            st=min(st,s[i]-'0');
        }
    }
    int pos=-1;
    for(int i=0;i<n;i++){
        if(s[i]-'0'==st){
            pos=i;
            break;
        }
        else{
            k--;
        }
    }
    deque<int>q;
    q.push_back(st);
    for(int i=pos+1;i<n;i++){
        int t=s[i]-'0';
        while(q.size()>1&&t<q.back()&&k){
            k--;
            q.pop_back();
        }
        q.push_back(t);
    }   
    while(k){
        q.pop_back();
        k--;
    }
    for(int x:q)cout<<x;
    cout<<endl;
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

### E - LAING2122

正解比题短系列  

首先注意到 w \lep 10^6 同时可以选 300 个数，最多用 3 个数来组合  

一个六位数，平均分成三份后，每份都是一个两位数，那么只要把从 1 ~ 100 的 i i*100 i*10000 都加进去就行了  

这样就能组合出所有的六位数  

```c
#include <bits/stdc++.h>
using namespace std;
#define ls now<<1
#define rs now<<1|1
#define endl "\n"
#define lowbit(x) ((x)&(-x))
typedef long long ll;
const int N=1e5+7, mod=1e9+7;

int w;
vector<int>ans;

void solve(){
    cin>>w;
    cout<<300<<endl;
    for(int i=1;i<=100;i++){
        cout<<i<<" "<<i*100<<" "<<i*10000<<" ";
    }
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

### D - haowen521

找给出的数组中的递增片段有几个，每个片段都可以接到上一层的一个节点上，这样接就是最低层数 

```c
#include <bits/stdc++.h>
using namespace std;
#define ls now<<1
#define rs now<<1|1
#define endl "\n"
#define lowbit(x) ((x)&(-x))
typedef long long ll;
const int N=2e5+7, mod=1e9+7;

int n;
int a[N] = {0};
vector<int>seg;

void solve(){
    seg.clear();
    cin>>n;
    for(int i=1;i<=n;i++){
        cin>>a[i];
    }
    int k=1;
    for(int i=3;i<=n;i++){
        if(a[i]<a[i-1]){
            seg.push_back(k);
            k=1;
        }
        else{
            k++;
        }
    }
    seg.push_back(k);
    int now=1;
    int tmp=1,nxt=0;
    for(auto x:seg){
        if(!tmp){
            tmp=nxt;
            now++;
            nxt=0;
        }
        tmp--;
        nxt+=x;
    }
    cout<<now<<endl;
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

### K - XingRin

赛时写了个 O(n^2 \log n) 的，但是遇到相同的数时会变 O(n^3 \log n)   

可以记录每个位置前某个数的出现次数  

这样就可以枚举 j,k 的位置，然后找 j 前方 a[k] 出现了多少和 k 后方 a[j] 出现的次数  

O(N^2) 即可通过  

```c
#include <bits/stdc++.h>
using namespace std;
#define ls now<<1
#define rs now<<1|1
#define endl "\n"
#define lowbit(x) ((x)&(-x))
typedef long long ll;
const int N=3e3+7, mod=1e9+7;

int n;
int s[N][N],a[N];
ll ans=0;

void solve(){
    ans=0;
    cin>>n;
    for(int i=1;i<=n;i++){
        cin>>a[i];
        for(int j=1;j<=n;j++){
            s[i][j]=s[i-1][j];
        }
        s[i][a[i]]++;
    }
    for(int i=2;i<=n;i++){
        for(int j=i+1;j<n;j++){
            ans+=(s[i-1][a[j]])*(s[n][a[i]]-s[j][a[i]]);
        }
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

### M - 附加题2

很眼熟，之前应该写过这种的来着，要加强补题  

注意到 k<20 那我们只需要对每个位置开一个 set 最多存 20 个元素即可  

```c
#include <bits/stdc++.h>
using namespace std;
#define ls now<<1
#define rs now<<1|1
#define endl "\n"
#define lowbit(x) ((x)&(-x))
typedef long long ll;
const int N=1e5+7, mod=1e9+7;

int n,q,a[N];
vector<int>edge[N];
multiset<int>s[N];

void dfs(int now,int fa){
    for(auto x:edge[now]){
        if(x==fa)continue;
        s[now].insert(a[x]);
        if(s[now].size()>20)s[now].erase(s[now].begin());
        dfs(x,now);
    }
    if (fa != 0) {
        for(auto x:s[now]){
            s[fa].insert(x);
            if(s[fa].size()>20)s[fa].erase(s[fa].begin());
        }
    }
}

void solve(){
    cin>>n>>q;
    for(int i=1;i<=n;i++){
        cin>>a[i];
    }
    for(int i=1;i<n;i++){
        int u,v;
        cin>>u>>v;
        edge[u].push_back(v);
        edge[v].push_back(u);
    }
    dfs(1,0);
    for(int i=1;i<=n;i++){
        s[i].insert(a[i]);
    }
    while(q--){   
        int v,k;
        cin>>v>>k;
        if (k > s[v].size()) {
            cout << -1 << endl;
        } else {
            auto ans = s[v].rbegin();
            advance(ans, k-1);
            cout << *ans << endl;
        }
    }
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

### H - guohaonan

易发现可以将两个数组拼接起来，a 在前，b 在后，保证整个数组是不降的，那么就是求 n 种数排列成单调不降的方案数，用 dp 跑即可 

```c
#include <bits/stdc++.h>
using namespace std;
#define ls now<<1
#define rs now<<1|1
#define endl "\n"
#define lowbit(x) ((x)&(-x))
typedef long long ll;
const int N=1e5+7, mod=1e9+7;

int n,m;
ll f[25][N],sum[25][N];

void solve(){
    cin>>n>>m;
    for(int i=1;i<=n;i++)f[1][i]=1,sum[1][i]=i;
    ll ans=0;
    m*=2;
    for(int i=2;i<=m;i++){
        for(int j=1;j<=n;j++){
            f[i][j]=sum[i-1][j];
            sum[i][j]=((sum[i][j-1]+f[i][j])%mod+mod)%mod;
        }
    }
    for(int i=1;i<=n;i++)ans=((ans+f[m][i])%mod+mod)%mod;
    cout<<ans<<endl;
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
