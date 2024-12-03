---
title: "ICPC 2022 西安 VP" #标题
date: 2024-10-19T17:04:37+08:00 #创建时间
lastmod: 2024-10-19T17:04:37+08:00 #更新时间
author: ["KiritoXD"] #作者
tags: 
- "补题"
description: "" #描述
summary: "表现还行" #描述
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


### J. Strange Sum

最多选两个，每选当前这个会限制选的范围，那么答案就一定是前面最大的加上现在这个的最大值  


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
    int n;
    cin>>n;
    ll mx=0,ans=0;
    for(int i=1;i<=n;i++){
        ll x;
        cin>>x;
        ans=max(ans,x+mx);
        mx=max(mx,x);
    }
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


### C. Clone Ranran

如果要克隆增加人数，一定是先在出题操作前增加的，那么就遍历可能的克隆次数，找到总共的最小代价 

```c
#include <bits/stdc++.h>
#define max(x,y) ((x)<(y)?(y):(x))
#define min(x,y) ((x)>(y)?(y):(x))
#define mk(x,y) make_pair(x,y)
using namespace std;
typedef long long ll;
const int N=3e2+7,inf=1e9+7;
const ll mod=2097152;

ll a,b,c;

void solve()
{
    ll ans=1e18,now=0,peo=1;
    cin>>a>>b>>c;
    while(peo<=c*2){
        ans=min(ans,(int)ceil(1.0*c/peo)*b+now);
        now+=a;
        peo*=2;
    }
    cout<<ans<<endl;
}
int main()
{
    std::ios::sync_with_stdio(0);
    std::cin.tie(0);
    int T=1;
    cin>>T; 
    while(T--) {
        solve();
    }
    return 0;
}
```

### F. Hotel

因为双人房只能同队的同性别住，那只用对每队考虑即可   

如果同一队内有同性的，那就可以考虑用双人房，否则全用单价低的房间  

```c
#include <bits/stdc++.h>
#define max(x,y) ((x)<(y)?(y):(x))
#define min(x,y) ((x)>(y)?(y):(x))
#define mk(x,y) make_pair(x,y)
using namespace std;
typedef long long ll;
const int N=3e2+7,inf=1e9+7;
const ll mod=2097152;

void solve()
{
    int n,c1,c2,sum=0;
    cin>>n>>c1>>c2;
    for(int i=1;i<=n;++i) {
        string s;
        cin>>s;
        bool flag=0;
        if(s[0]==s[1]||s[0]==s[2]||s[1]==s[2])  flag=1;
        int mi=min(c1,c2),ans=3*mi;
        if(flag)  ans=min(ans,mi+c2);
        sum+=ans;
    }
    printf("%d\n",sum);
}
int main()
{
    std::ios::sync_with_stdio(0);
    std::cin.tie(0);
    int T=1;
    // cin>>T; 
    while(T--) {
        solve();
    }
    return 0;
}
```

### G. Perfect Word  

所有 $t$ 按长度排序，依次在后面的串是否满足他的子串在前面都出现过即可  

```c
#include <bits/stdc++.h>
#define max(x,y) ((x)<(y)?(y):(x))
#define min(x,y) ((x)>(y)?(y):(x))
#define mk(x,y) make_pair(x,y)
using namespace std;
typedef long long ll;
const int N=1e5+7,inf=1e9+7;
const ll mod=2097152;
string s[N];
map<string,bool> mp;
bool cmp(string x,string y)
{
    return x.length()<y.length();
}
void solve()
{
    int n,ans=0;
    cin>>n;
    for(int i=1;i<=n;++i)  cin>>s[i];
    sort(s+1,s+1+n,cmp);
    for(int i=1;i<=n;++i) {
        if(s[i].length()==1)  mp[s[i]]=1,ans=1;
        else {
            string tmp=s[i].substr(0,s[i].length()-1);
            if(mp.find(tmp)==mp.end())  continue;
            tmp=s[i].substr(1,s[i].length()-1);
            if(mp.find(tmp)==mp.end())  continue;
            mp[s[i]]=1;
            ans=s[i].length();
        }
    }
    printf("%d",ans);
}
int main()
{
    std::ios::sync_with_stdio(0);
    std::cin.tie(0);
    int T=1;
    // cin>>T; 
    while(T--) {
        solve();
    }

    return 0;
}
```


### E. Find Maximum 

打表后发现，遇到 $3$ 的倍数就会变小一次，每三次是一个小片段，根据这个性质用 $dfs$ 暴力找即可  

```c
#include <bits/stdc++.h>
#define max(x,y) ((x)<(y)?(y):(x))
#define min(x,y) ((x)>(y)?(y):(x))
#define mk(x,y) make_pair(x,y)
using namespace std;
typedef long long ll;
const int N=1e5+7,inf=1e9+7;
const ll mod=2097152;
ll F(ll x)
{
    if(x<3)  return 1+x;
    int y=x%3;
    return y+1+F(x/3);
}
ll sol(ll l,ll r)
{
    ll ans=0;
    while(l<=r&&l%3!=0) {
        ll x=F(l);
        ans=max(ans,x);
        ++l;
    }
    if(l>r)  return ans;
    while(l<=r&&r%3!=2) {
        ll x=F(r);
        ans=max(ans,x);
        --r;
    }
    if(l>r)  return ans;
    ll tmp=sol(l/3,r/3)+3;
    return max(ans,tmp);
}
void solve()
{
    ll l,r;
    cin>>l>>r;
    printf("%lld\n",sol(l,r));
}
int main()
{
    std::ios::sync_with_stdio(0);
    std::cin.tie(0);
    int T=1;
    cin>>T; 
    while(T--) {
        solve();
    }

    return 0;
}
```

### L. Tree

观察题目，发现集合要么是一条链，要么是当前所有的叶子节点，这代表了两种操作，要找到最少的操作次数  

记录当前的叶子节点，往上查找一层，用出度判断是否为分叉情况，找到当前的链数，用这个链数加上取叶子节点的次数，即为当前答案，一直找到往上没有链为止  

```c
#include <bits/stdc++.h>
using namespace std;
#define ls now<<1
#define rs now<<1|1
#define endl "\n"
#define lowbit(x) ((x)&(-x))
typedef long long ll;
const int N=1e6+7, mod=1e9+7;

int n;
vector<int>nxt[N];
int fa[N],deg[N];
deque<int>leaf;
bool vis[N];

void dfs(int x,int f,int len){
    fa[x]=f;
    for(auto y:nxt[x]){
        if(y!=f)dfs(y,x,len+1),++deg[x];
    }
    if(!deg[x])leaf.push_back(x);
}

void solve(){
    leaf.clear();
    cin>>n;
    for(int i=2;i<=n;i++){
        int x;
        cin>>x;
        nxt[x].push_back(i);
        nxt[i].push_back(x);
    }
    dfs(1,0,1);
    int ans=leaf.size();
    for(int i=1;!leaf.empty();i++){
        int cnt=leaf.size();
        while(cnt--){
            int x=fa[leaf.front()];
            leaf.pop_front();
            if(!x)continue;
            --deg[x];
            if(!deg[x])leaf.push_back(x);
        }
        ans=min(ans,i+(int)leaf.size());
    }
    cout<<ans<<endl;
    for(int i=1;i<=n;i++)nxt[i].clear(),vis[i]=0,deg[i]=0;
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

### B. Cells Coloring

网络流，好像挺板的，后面学了补  



### A. Bridge

LCT，后面学了补  


