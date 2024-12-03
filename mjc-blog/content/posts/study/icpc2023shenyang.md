---
title: "ICPC 2023 沈阳 VP" #标题
date: 2024-10-20T17:04:40+08:00 #创建时间
lastmod: 2024-10-20T17:04:40+08:00 #更新时间
author: ["KiritoXD"] #作者
tags: 
- "补题"
description: "" #描述
summary: "LPL 你这里欠我的用什么还" #描述
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

### C. Swiss Stage

四目 TES 打的像浓 shit，真的恶臭  

```c
#include <bits/stdc++.h>
#define max(x,y) ((x)<(y)?(y):(x))
#define min(x,y) ((x)>(y)?(y):(x))
#define mk(x,y) make_pair(x,y)
#define lson (now<<1)
#define rson (now<<1|1)
using namespace std;
typedef long long ll;
const int N=2e5+7,inf=1e9+7;
const ll mod=2097152;

void solve()
{
    int x,y;
    cin>>x>>y;
    int ans[10][10];
    ans[0][0]=4;
    ans[0][1]=4;
    ans[0][2]=6;
    ans[1][0]=3;
    ans[1][1]=3;
    ans[1][2]=4;
    ans[2][0]=2;
    ans[2][1]=2;
    ans[2][2]=2;
    cout<<ans[x][y];
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


### J. Graft and Transplant

每次只能选度数不为 $1$ 的点，看一共有多少个能选的点即可 

```C
#include <bits/stdc++.h>
using namespace std;
#define ls now<<1
#define rs now<<1|1
#define endl "\n"
#define lowbit(x) ((x)&(-x))
typedef long long ll;
const int N=1e5+7, mod=1e9+7;

int n,u,v;
int deg[55];

void solve(){
    cin>>n;
    for(int i=1;i<n;i++){
        cin>>u>>v;
        deg[u]++;
        deg[v]++;
    }
    int cnt=0;
    for(int i=1;i<=n;i++){
        if(deg[i]>1)cnt++;
    }
    if((cnt&1)||(!cnt))cout<<"Bob\n";
    else cout<<"Alice\n";
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

### E. Sheep Eat Wolves

开始想的是模拟，但是模拟一直调不出来，最后用 $dp$ 调出来了

用 $f_{i,j}$ 记录最佳方案的代价，$i,j$ 分别对应当前左侧的羊和狼的数量  

船每次都是坐满最优，使某些狼一直在船上，比船上留空位更优  

同时羊送到对岸，绝对不可能再返回，但是狼可能来回携带，如样例2，那么我们可以枚举带回狼的数量 

递推公式如下   

$f_{i,j}=\begin{cases}0,&i=0\\\1,&i\leq p\\\min\{f_{ij}+f_{i-x,j-y}+2\}\end{cases}$  

最后输出 $f_{x,y}$ 即可  

```c
#include <bits/stdc++.h>
using namespace std;
#define ls now<<1
#define rs now<<1|1
#define endl "\n"
#define lowbit(x) ((x)&(-x))
typedef long long ll;
const int N=1e2+10, mod=1e9+7;

int f[N][N],x,y,q,p;

bool check(int x,int y){
    return (x&&y-x>q);
}

void solve(){
    cin>>x>>y>>p>>q;
    memset(f,-1,sizeof(f));
    for(int i=0;i<=x;i++){
        for(int j=0;j<=y;j++){
            if(check(x-i,y-j))continue;
            if(i==0){
                f[i][j]=0;
                continue;
            }
            if(i<=p){
                f[i][j]=1;
                continue;
            }
            for(int k=0;k<=i&&k<=p;k++){
                int l=p-k;
                if(check(i-k,j-l))continue;
                for(int m=0;m<=p&&m<=y-j+l;m++){
                    if(k==0&&m==p)continue;
                    if(f[i-k][j-l+m]==-1)continue;
                    if(f[i][j]==-1)f[i][j]=2+f[i-k][j-l+m];
                    else f[i][j]=min(f[i][j],2+f[i-k][j-l+m]);
                }
            }
        }
    }
    cout<<f[x][y]<<endl;
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


### K. Maximum Rating 

队长一眼顶针出结论，$k$ 是连续的，找上下限即可  

显然上限为先进行所有为正数的比赛，下限为先进行所有为负数的比赛，同时正数的比赛从小到大排  

现在的问题就转化到如何维护这个 $k$ 的范围  

需要用线段树维护，同时根据 $a$ 的范围发现需要动态开点  

```c
#include <bits/stdc++.h>
using namespace std;
#define ls now<<1
#define rs now<<1|1
#define endl "\n"
#define lowbit(x) ((x)&(-x))
typedef long long ll;
const int N=2e5+7, mod=1e9+7;

struct Node{
    int l,r,cnt;
    ll sum;
}tr[N*2*32];

int tot=0,rt=0;
ll a[N];

void add(int& now,int l,int r,int x,int v){
    if(!now)now=++tot;
    tr[now].sum+=x*v;
    tr[now].cnt+=v;
    if(l==r)return;
    ll mid=(l+r)>>1;
    if(x<=mid)add(tr[now].l,l,mid,x,v);
    else add(tr[now].r,mid+1,r,x,v);
}

int ask(int now,int l,int r,ll x){
    if(!now)return 0;
    if(tr[now].sum<=x)return 0;
    if(l==r)return tr[now].cnt-(x/l);
    ll mid=(l+r)>>1;
    if(tr[tr[now].l].sum>x)return tr[tr[now].r].cnt+ask(tr[now].l,l,mid,x);
    else return ask(tr[now].r,mid+1,r,x-tr[tr[now].l].sum);
}

void solve(){
    int n,q,cnt=0;
    cin>>n>>q;
    for(int i=1;i<=n;i++){
        cin>>a[i];
        if(a[i]>0)++cnt;
        add(rt,-1e9,1e9,a[i],1);
    }
    while(q--){
        ll x,v;
        cin>>x>>v;
        if(a[x]>0)--cnt;
        add(rt,-1e9,1e9,a[x],-1);
        a[x]=v;
        add(rt,-1e9,1e9,a[x],1);
        if(a[x]>0)++cnt;
        int tmp=ask(rt,-1e9,1e9,0);
        cout<<cnt-tmp+1<<endl;
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
