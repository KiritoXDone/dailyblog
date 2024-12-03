---
title: "树形DP" #标题
date: 2024-10-11T18:23:38+08:00 #创建时间
lastmod: 2024-10-11T18:23:38+08:00 #更新时间
author: ["KiritoXD"] #作者
tags: 
- "树形DP"
- "DP"
summary: "树形 DP 学习记录" #描述
categories: ['Study'] #分类
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
### 树上 DP

顾名思义，在树上进行的 DP，一般通过递归进行  

一般开 $f_{i,j}$ 表示以 $i$ 为根的子树的最优解，第二维表示选不选 $i$   


#### 洛谷 没有上司的舞会 [P1352](https://www.luogu.com.cn/problem/P1352)

##### 题目

某大学有 $n$ 个职员，编号为 $1\ldots n$。

他们之间有从属关系，也就是说他们的关系就像一棵以校长为根的树，父结点就是子结点的直接上司。

现在有个周年庆宴会，宴会每邀请来一个职员都会增加一定的快乐指数 $r_i$，但是呢，如果某个职员的直接上司来参加舞会了，那么这个职员就无论如何也不肯来参加舞会了。

所以，请你编程计算，邀请哪些职员可以使快乐指数最大，求最大的快乐指数。  

##### 解决  

设 $f_{i,j}$ 代表以 $i$ 为根的子树的最优解，$j$ 用 $0,1$ 来表示取不取 $i$ 这个人  

对于每个节点，都有两种决策

- 不取当前节点，他的子节点都可以取，或不取，$f_{i,0} = \sum_{x \in \text{child}(i)} \max(f_{x,0}, f_{x,1})$  

- 取当前节点，他的子节点都不能取，$f_{i,0} = \sum_{x \in \text{child}(i)}f_{x,0}+a_i$ 

```c
#include <bits/stdc++.h>
using namespace std;
#define ls now<<1
#define rs now<<1|1
#define endl "\n"
#define lowbit(x) ((x)&(-x))
typedef long long ll;
const int N=1e5+7, mod=1e9+7;


vector<int> edge[N];
int a[N],n,cnt,f[N][2],ans;
bool vis[N];

void dfs(int now) {
    f[now][0] = 0;
    f[now][1] = a[now];
    for (int i = 0; i < (int)edge[now].size(); i++) {
        int to = edge[now][i];
        dfs(to);
        f[now][0] += max(f[to][0], f[to][1]);
        f[now][1] += f[to][0];
    }
}

void solve(){
    cin>>n;
    for(int i=1;i<=n;i++)cin>>a[i];
    for(int i=1;i<n;i++){
        int x,y;
        cin>>x>>y;
        edge[y].push_back(x);
        vis[x]=1;
    }
    int root=0;
    for(int i=1;i<=n;i++){
        if(!vis[i]){
            root=i;
            break;
        }
    }
    dfs(root);
    cout<<max(f[root][0],f[root][1])<<endl;
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

#### CF Sheriff's Defense  [2014F](https://codeforces.com/contest/2014/problem/F)

##### 题目  
给定一张 $n$ 结点 $n - 1$ 条边的有点权的树。初始每个结点都是黑色。

你可以执行任意次以下操作：将一个黑点染成白色，并将所有与它相邻的结点的权值减去 $c$（不包括自己）。

最大化全部白点的权值之和。

###### 解决 
用 $f_{u,j}$ 记录，同上一题 

设计状态 $f_{u,0}$ 表示在以 $u$ 为根的子树下，不选择 $u$ 所能获得的最大价值，初始值为 $0$；

$f_{u,1}$ 表示在以 $u$ 为根的子树下，选择 $u$ 所能获得的最大价值，初始值为 $a_u$。

如果某个点不选，那它不会对结果造成影响  

- 若不选 $u$ 则
  $$
  f_{u,0} = f_{u,0} + \max(f_{v,0}, f_{v,1})
  $$
- 若选 $u$ 则
  $$
  f_{u,1} = f_{u,1} + \max(f_{v,0}, f_{v,1} - c \times 2)
  $$
  如果选 $v$ 那他会对 $u->v$ 和 $v->u$ 这两条路径造成消耗所以要减两个 $c$

```c
#include <bits/stdc++.h>
using namespace std;
#define ls now<<1
#define rs now<<1|1
#define endl "\n"
#define lowbit(x) ((x)&(-x))
typedef long long ll;
const int N=2e5+7, mod=1e9+7;

ll n,c,s,ans;
ll dp[N][2];
vector<int>edge[N];
bool vis[N];

void dfs(int now,int fa){
    for(auto i:edge[now]){
        if(i!=fa){
            dfs(i,now);
            dp[now][0]+=max(dp[i][0],dp[i][1]);
            dp[now][1]+=max(dp[i][0],dp[i][1]-(c<<1));
        }
    }
}

void solve(){
    ans=0;
    cin>>n>>c;
    for(int i=1;i<=n;i++){
        edge[i].clear();
        cin>>dp[i][1];
        dp[i][0]=0;
        vis[i]=0;
    }
    for(int i=1;i<n;i++){
        int u,v;
        cin>>u>>v;
        edge[u].push_back(v);
        edge[v].push_back(u);
    }
    dfs(1,0);
    cout<<max(dp[1][0],dp[1][1])<<endl;
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

### 树上背包  

即背包问题和树上 DP 的结合  

#### 洛谷  CTSC1997 选课  [P2014](https://www.luogu.com.cn/problem/P2014)

##### 题目

在大学里每个学生，为了达到一定的学分，必须从很多课程里选择一些课程来学习，在课程里有些课程必须在某些课程之前学习，如高等数学总是在其它课程之前学习。现在有 $N$ 门功课，每门课有个学分，每门课有一门或没有直接先修课（若课程 $a$ 是课程 $b$ 的先修课即只有学完了课程 $a$，才能学习课程 $b$）。一个学生要从这些课程里选择 $M$ 门课程学习，问他能获得的最大学分是多少？


##### 解决

新增一个 $0$ 学分的必修课，作为所有无前选课的课的前选课，这样就能构建出一颗以新增节点为根的树  

设 $f_{i,j}$ 为第 $i$ 个节点，$j$ 为背包容量  

初始值为 $f_{i,0} = s_{i}$

递归每颗子树 

每次递归记录当前背包容量，和当前所能得到的最大值



```c
#include <bits/stdc++.h>
using namespace std;
#define endl "\n"
typedef long long ll;
const int N = 2e4 + 7, mod = 1e9 + 7;

int n, m, f[N][N];
vector<int> edge[N];
int s[N];

int dfs(int x) {
    if (edge[x].empty()) return 0;
    int sum = 0;
    for (int i : edge[x]) {
        int t = dfs(i);
        sum += t + 1;
        for (int j = sum; j >= 0; j--) {
            for (int k = 0; k <= t; k++) {
                if (j - k - 1 >= 0) f[x][j] = max(f[x][j], f[x][j - k - 1] + f[i][k]);
            }
        }
    }
    return sum;
}

void solve() {
    cin >> n >> m;
    for (int i = 1; i <= n; i++) {
        int k;
        cin >> k >> s[i];
        edge[k].push_back(i);
    }
    for (int i = 1; i <= n; i++) f[i][0] = s[i];
    f[0][0] = 0;
    dfs(0);
    cout << f[0][m] << endl;
}

int main() {
    ios::sync_with_stdio(0);
    cin.tie(0); cout.tie(0);
    int t = 1;
    // cin >> t;
    while (t--) solve();
    return 0;
}
```


### 换根 DP

又被称为二次扫描，通常不指定根节点，同时根节点的变化会使一些值发生变化，例如子节点深度和，点权和等  

通常两次 DFS，第一次预处理深度，点权和等信息，第二次 DFS 进行 DP
 
#### 洛谷 STA-Station [P3478](https://www.luogu.com.cn/problem/P3478) 


##### 题目

给定一个 $n$ 个点的树，请求出一个结点，使得以这个结点为根时，所有结点的深度之和最大。

一个结点的深度之定义为该节点到根的简单路径上边的数量。

##### 解决

不妨令 $u$ 为当前结点，$v$ 为当前结点的子结点。首先需要用 $s_i$ 来表示以 $i$ 为根的子树中的结点个数，并且有 $s_u = 1 + \sum s_v$。显然需要一次 DFS 来计算所有的 $s_i$，这次的 DFS 就是预处理，我们得到了以某个结点为根时其子树中的结点总数。

考虑状态转移，这里就是体现“换根”的地方了。令 $f_u$ 为以 $u$ 为根时，所有结点的深度之和。

$f_v \leftarrow f_u$ 可以体现换根，即以 $u$ 为根转移到以 $v$ 为根。显然在换根的转移过程中，以 $v$ 为根或以 $u$ 为根会导致其子树中的结点的深度产生改变。具体表现为：

- 所有在 $v$ 的子树上的结点深度都减少了 $1$，那么总深度和就减少了 $s_v$；
- 所有不在 $v$ 的子树上的结点深度都增加了 $1$，那么总深度和就增加了 $n - s_v$；

根据这两个条件就可以推出状态转移方程：

$$ f_v = f_u - s_v + n - s_v = f_u + n - 2 \times s_v $$

于是在第二次 DFS 遍历整棵树并状态转移 $f_v = f_u + n - 2 \times s_v$，那么就能求出以每个结点为根时的深度和了。最后只需要遍历一次所有根结点深度和就可以求出答案。


```c
#include <bits/stdc++.h>
using namespace std;
#define ls now<<1
#define rs now<<1|1
#define endl "\n"
#define lowbit(x) ((x)&(-x))
typedef long long ll;
const int N=2e6+7, mod=1e9+7;

vector<int>edge[N];
ll n;
ll f[N],sz[N],dep[N];

void dfs(int u,int fa){
    sz[u]=1;
    dep[u]=dep[fa]+1;
    for(auto v:edge[u]){
        if(v==fa)continue;
        dfs(v,u);
        sz[u]+=sz[v];
    }
}

void ans(int u,int fa){
    f[u]=f[fa]+n-sz[u]-sz[u];
    for(auto v:edge[u]){
        if(v==fa)continue;
        ans(v,u);
    }
}

void solve(){
    cin>>n;
    for(int i=1;i<n;i++){
        int u,v;
        cin>>u>>v;
        edge[u].push_back(v);
        edge[v].push_back(u);
    }
    dfs(1,1);
    for(int i=1;i<=n;i++){
        f[1]+=dep[i];
    }
    ans(1,1);
    ll res=-1;
    int now;
    for(int i=1;i<=n;i++){
        if(f[i]>res){
            res=f[i];
            now=i;
        }
    }
    cout<<now<<endl;
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
