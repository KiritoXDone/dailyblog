---
title: "LCA" #标题
date: 2024-08-06T21:45:34+08:00 #创建时间
lastmod: 2024-08-06T21:45:34+08:00 #更新时间
author: ["KiritoXD"] #作者
tags: 
- "LCA"
- "Tree"
description: "" #描述
summary: "LCA 学习记录" #描述
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
# LCA(最近公共祖先)
---
## 简介

两个节点的最近公共祖先，就是两个点的公共祖先里，离根最远的那个  

1. $LCA(\{u\}) = u$  
2. $u$ 是 $v$ 的祖先，当且仅当 $LCA(\{u, v\}) = u$  
3. 如果 $u, v$ 互不为祖先，那么二者存在 $LCA(\{u, v\})$ 的两颗不同子树中  
4. 前序遍历中，$LCA(S)$ 出现在所有 $S$ 中元素之前，后序遍历中 $LCA(S)$ 则出现在所有 $S$ 中元素之后  
5. 两点集并的最近公共祖先为两点集分别的最近公共祖先的最近公共祖先，即 $LCA(A\cup B)=LCA(LCA(A), LCA(B))$  
6. 两点的最近公共祖先必定处在树上两点间的最短路上  
7. $d(u,v)=h(u)+h(v)-2h(LCA(u,v))$，其中 $d$ 是树上两点间的距离，$h$ 代表某点到树根的距离  
---

## 求法

### 朴素算法 

每次都找深度较大的点，令其向上搜索，显然两个点最后会相遇，相遇位置即为 $LCA$，或者先调整深度较大的点，使二者深度相同后，一起向上跳转，最后也会相遇  

需要先 $dfs$ 预处理整棵树，此过程为 $O(n)$, 查询过程也为 $O(n)$  

### 倍增算法   

#### 简介

是朴素算法的改进版本，预处理 $fa[x][i]$ 数组，使游标可以快速移动，减少跳转次数。  

$fa[x][i]$ 表示的是点 $x$ 的第 $2^i$ 个祖先。可以通过 $dfs$ 预处理得到  

优化跳转的过程：首先，我们要将 $u, v$ 跳转到同一深度，计算得出二者深度之差为 $y$，将 $y$ 用二进制拆分，将 $y$ 次游标跳转优化为 $y$ 的二进制中 $1$ 的个数次跳转。接着从最大的 $i$ 开始循环尝试，一直到 $0$，如果 $fa[u][i] \neq fa[v][i]$，那么最后的 $LCA$ 为 $fa[u][0]$  

预处理的时间复杂度是 $O(n \log n)$, 查询的时间复杂度是 $O(\log n)$  

#### 模板

```c
#include <bits/stdc++.h>
using namespace std;
const int N = 6e5+7;

int n,m,s;
vector<int>v[N];
int d[N],f[N][32];

void dfs(int x,int y){
  d[x]=d[y]+1;
  f[x][0]=y;
  for(int i=1;i<=31;i++){
    f[x][i]=f[f[x][i-1]][i-1];
  }
  for(int i=0;i<v[x].size();i++){
    if(d[v[x][i]]==0)dfs(v[x][i],x);
  }
}

int lca(int x,int y){
  if(d[x]<d[y])swap(x,y);
  for(int i=31;i>=0;i--){
    if(f[x][i]!=0&&d[f[x][i]]>=d[y])
      x=f[x][i];
  }
  if(x==y)return x;
  for(int i=31;i>=0;i--){
    if(f[x][i]!=0&&f[y][i]!=0&&f[x][i]!=f[y][i]){
      x=f[x][i];
      y=f[y][i];
    }
  }
  return f[x][0];
}

int main(){
  cin>>n>>m>>s;
  for(int i=1;i<n;i++){
    int x,y;
    cin>>x>>y;
    v[x].push_back(y);
    v[y].push_back(x);
  }
  dfs(s,0);
  for(int i=1;i<=m;i++){
    int x,y;
    cin>>x>>y;
    cout<<lca(x,y)<<endl;
  }
}
```


#### 例题

[HDU 2586](https://acm.hdu.edu.cn/showproblem.php?pid=2586)  树上最短路查询  

```c
#include <bits/stdc++.h>
using namespace std;
const int N = 40005;

vector<int>v[N],w[N];
int fa[N][31],cost[N][31],dep[N];
int n,m,a,b,c;

void dfs(int now,int fno){
  fa[now][0]=fno;
  dep[now]=dep[fa[now][0]]+1;
  for(int i=1;i<31;i++){
    fa[now][i]=fa[fa[now][i-1]][i-1];
    cost[now][i]=cost[fa[now][i-1]][i-1]+cost[now][i-1];
  }
  int sz=v[now].size();
  for(int i=0;i<sz;i++){
    if(v[now][i]==fno)continue;
    cost[v[now][i]][0]=w[now][i];
    dfs(v[now][i],now);
  }
}

int lca(int x,int y){
  if(dep[x]>dep[y])swap(x,y);
  int tmp=dep[y]-dep[x],ans=0;
  for(int j=0;tmp;++j,tmp>>=1){
    if(tmp&1)ans+=cost[y][j],y=fa[y][j];
  }
  if(y==x)return ans;
  for(int j=30;j>=0&&y!=x;j--){
    if(fa[x][j]!=fa[y][j]){
      ans+=cost[x][j]+cost[y][j];
      x=fa[x][j];
      y=fa[y][j];
    }
  }
  ans+=cost[x][0]+cost[y][0];
  return ans;
}

void solve(){
  memset(fa,0,sizeof(fa));
  memset(cost,0,sizeof(cost));
  memset(dep,0,sizeof(dep));
  cin>>n>>m;
  for(int i=1;i<=n;i++){
    v[i].clear();
    w[i].clear();
  }
  for(int i=1;i<n;i++){
    cin>>a>>b>>c;
    v[a].push_back(b);
    v[b].push_back(a);
    w[a].push_back(c);
    w[b].push_back(c);
  }
  dfs(1,0);
  for(int i=1;i<=m;i++){
    cin>>a>>b;
    cout<<lca(a,b)<<endl;
  }
}

int main(){
  ios::sync_with_stdio(0);
  cin.tie(0);cout.tie(0);
  int t;
  cin>>t;
  while(t--)solve();
  return 0;
}
```

### Tarjan 算法

#### 简介

是离线算法，需要使用并查集记录某个结点的祖先结点  

1. 首先接受输入边(领接链表)，查询边(另一个链表中)。查询边其实是虚拟加的边，每次输入查询边的时候，都将此边和其反向边加入到 $queryedge$ 数组里  
2. 然后对其进行 $DFS$ 遍历，同时使用 $vis$ 数组记录结点是否被访问，$parent$ 记录当前结点的父亲结点  
3. 每次遍历到某个结点的时候，认为这个结点的根节点就是他本身，。让以这个结点为根节点的 $DFS$ 全遍历完以后，再将这个结点的根节点设置为这个结点的父一级结点  
4. 回溯的时候，如果以该节点为起点，$queryedge$ 查询边的另一个结点也恰好访问过了，直接更新查询边的 $LCA$ 结果  
5. 输出结果  

Tarjan 算法需要初始化并查集，所以预处理的时间复杂度为 $O(n)$。

朴素的 Tarjan 算法处理所有 $m$ 次询问的时间复杂度为 $O(m \alpha(m+n, n) + n)$  

#### 模板 

```c
#include <algorithm>
#include <cstring>
#include <iostream>
using namespace std;

class Edge {
 public:
  int toVertex, fromVertex;
  int next;
  int LCA;
  Edge() : toVertex(-1), fromVertex(-1), next(-1), LCA(-1) {};
  Edge(int u, int v, int n) : fromVertex(u), toVertex(v), next(n), LCA(-1) {};
};

const int MAX = 100;
int head[MAX], queryHead[MAX];
Edge edge[MAX], queryEdge[MAX];
int parent[MAX], visited[MAX];
int vertexCount, queryCount;

int find(int x) {
  if (parent[x] == x) {
  return x;
  } else {
  return parent[x] = find(parent[x]);
  }
}

void tarjan(int u) {
  parent[u] = u;
  visited[u] = 1;

  for (int i = head[u]; i != -1; i = edge[i].next) {
  Edge& e = edge[i];
  if (!visited[e.toVertex]) {
    tarjan(e.toVertex);
    parent[e.toVertex] = u;
  }
  }

  for (int i = queryHead[u]; i != -1; i = queryEdge[i].next) {
  Edge& e = queryEdge[i];
  if (visited[e.toVertex]) {
    queryEdge[i ^ 1].LCA = e.LCA = find(e.toVertex);
  }
  }
}

int main() {
  memset(head, 0xff, sizeof(head));
  memset(queryHead, 0xff, sizeof(queryHead));

  cin >> vertexCount >> queryCount;
  int count = 0;
  for (int i = 0; i < vertexCount - 1; i++) {
  int start = 0, end = 0;
  cin >> start >> end;

  edge[count] = Edge(start, end, head[start]);
  head[start] = count;
  count++;

  edge[count] = Edge(end, start, head[end]);
  head[end] = count;
  count++;
  }

  count = 0;
  for (int i = 0; i < queryCount; i++) {
  int start = 0, end = 0;
  cin >> start >> end;

  queryEdge[count] = Edge(start, end, queryHead[start]);
  queryHead[start] = count;
  count++;

  queryEdge[count] = Edge(end, start, queryHead[end]);
  queryHead[end] = count;
  count++;
  }

  tarjan(1);

  for (int i = 0; i < queryCount; i++) {
  Edge& e = queryEdge[i * 2];
  cout << "(" << e.fromVertex << "," << e.toVertex << ") " << e.LCA << endl;
  }

  return 0;
}
```
