---
title: "ICPC2024shanghai" #标题
date: 2024-11-20T20:30:48+08:00 #创建时间
lastmod: 2024-11-20T20:30:48+08:00 #更新时间
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
### 前言

铁了，唉，赛时发挥一坨屎   


### I. In Search of the Ultimate Artifact

赛时一眼盯真，鉴定为纯纯的暴力，自己写了会发现老是不对，让队长上机调了几分钟过了   

题意即每次选当前最大的 $k$ 个数相乘，求最后能得到的最大的数是多少，对这个最大的数取模  

```c
#include <bits/stdc++.h>
using namespace std;
#define ls now<<1
#define rs now<<1|1
#define endl "\n"
#define lowbit(x) ((x)&(-x))
typedef long long ll;
const int N=2e5+7, mod=998244353;

int n,k;
ll a[N];

void solve(){
	cin>>n>>k;
	for(int i=1;i<=n;i++)cin>>a[i];
	sort(a+1,a+1+n,greater<ll>());
	ll ans=a[1]%mod;
	deque<int>q;
	ll tmp=1;
	for(int i=2;i<=n;i++){
		if(a[i]==0)break;
		q.push_back(a[i]);
		tmp=(tmp*a[i])%mod;
		if((int)q.size()%(k-1)==0){
			ans=(ans*tmp)%mod;
			tmp=1;
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


### C. Conquer the Multiples

赛时居然卡了 1 个多小时  

简单的博弈论   

易发现，偶数乘于任何数都还是偶数，即从偶数开始的人，是无法阻碍另一个人的，但是奇数的人可以去拿偶数位上的，即奇数开始的人处于优势地位   

基础情况为每个人只拿当前位置  

最优情况，偶数仍然只能拿当前位置，拿后面的只会妨碍自己，奇数能拿偶数时优先拿偶数   

可以发现，基础步数是区间内奇偶的个数，考虑到最优情况，奇数会拿走偶数的，我们只需要看奇数按最优的操作后，谁的步数多即可  


```c
#include <bits/stdc++.h>
using namespace std;
#define ls now<<1
#define rs now<<1|1
#define endl "\n"
#define lowbit(x) ((x)&(-x))
typedef long long ll;
const int N=2e5+7, mod=998244353;

ll l,r;

void solve(){
	cin>>l>>r;
	if(l&1){
		if(l*2<=r){cout<<"Alice\n";return;}
	}
	else {
		if((l+1)*2<=r){cout<<"Bob\n";return;}
	}
	cout<<(((r-l+1)&1) ? "Alice\n" : "Bob\n");
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

### G. Geometry Task

赛场上太急了，思路只对了一部分，还有部分没想到就上机开始硬调了  


显然易想到二分答案，重点就是 $check$ 的过程  

开始想法是对于每个 $红线$，用二分找他的最优的 $蓝线$ 与其匹配，但是忽视了 $a<0$ $a>0$ 对于最优的要求的不同  例如 $2$ 者的最优都是 $1$ 时，$蓝线$ 数据为 $\{1,2,3\}$，如果先判断了正的那个，它就会取走 $1$，那么 负的就取不了了  

所以，将问题转化为区间取数问题，对于负数，是在 $[1,x]$，上取数，对于正数，是在 $[x,n]$ 上取数  
将正负分开处理，分别考虑能取走几个即可，最后返回 $cnt>=(mid+1)/2$ 即可


```c
#include<bits/stdc++.h>
using namespace std;
typedef long long ll;

const int N=2e5+7;

struct Node{
	ll a,b;
	bool operator<(const Node &tmp){
		if(a==tmp.a)return b<tmp.b;
		return a<tmp.a;
	}
};

Node a[N];
ll c[N];
int cnt[N];
int n,fu,zheng;

bool check(ll x){
	int res=0;
	for(int i=1;i<=n;i++)cnt[i]=0;
	for(int i=1;i<=n;i++){
		if(a[i].a<0){
			ll l=1,r=fu,ans=0;
			while(l<=r){
				ll mid=(l+r)>>1;
				if(a[i].a*c[mid]+a[i].b>=x)l=mid+1,ans=mid;
				else r=mid-1;
			}
			cnt[ans]++;
		}
		else if(a[i].a==0){
			if(a[i].b>=x)res++;
		}
		else{
			ll l=zheng,r=n,ans=0;
			while(l<=r){
				ll mid=(l+r)>>1;
				if(a[i].a*c[mid]+a[i].b>=x)r=mid-1,ans=mid;
				else l=mid+1;
			}
			cnt[ans]++;
		}
	}
	int sum=0;
	for(int i=1;i<=fu;i++){
		sum++;
		if(cnt[i]){
			if(sum>=cnt[i])res=res+cnt[i],sum=sum-cnt[i];
			else res=res+sum,sum=0;
		}
	}
	sum=0;
	for(int i=n;i>=zheng;i--){
		sum++;
		if(cnt[i]){
			if(sum>=cnt[i])res+=cnt[i],sum-=cnt[i];
			else res+=sum,sum=0;
		}
	}
	return res>=(n+1)/2;
}

void solve(){
	cin>>n;
	for(int i=1;i<=n;i++)cin>>a[i].a;
	for(int i=1;i<=n;i++)cin>>a[i].b;
	for(int i=1;i<=n;i++)cin>>c[i];
	sort(a+1,a+1+n);
	sort(c+1,c+1+n);
	ll l=-2e18,r=2e18,ans=0;
	fu=0,zheng=n+1;
	for(int i=n;i>0;i--){
		if(a[i].a<0){
			fu=i;
			break;
		}
	}
	for(int i=1;i<=n;i++){
		if(a[i].a>0){
			zheng=i;
			break;
		}
	}
	while(l<=r){
		ll mid=ll(l+r)>>1;
		if(check(mid))l=mid+1,ans=mid;
		else r=mid-1;
	}
	cout<<ans<<endl;
}

int main(){
	int t;
	cin>>t;
	while(t--)solve();
	return 0;
}
```


### B. Basic Graph Algorithm

md 三个人硬是没开出来  

显然最优是连不到下个点时加边，前面能回溯时则不加，选择回溯来实现这个点  

加边一定是加到靠前的点更优  

代码实现:
- 首先开一个超级源点 $0$ 可连到所有的节点，同时所有的节点也能回到这个超级源点

- 然后记录条边连接的点  

- 用 $dfs$ 实现，我们从 $0$ 端点开始，将能到达的点中回来的路全部删掉，接着判断是否子节点中是否能够通往下一个节点，如果没有对应的路，就加点，接着以下一个点进行 $dfs$  

- 实现回溯的关键在于 $dfs$ 中的判断采用的是 $while$，如果当前这个节点他没有边，那我们应该回去，此时之前的节点仍然能进行判断，是否需要加边  

```c
#include <bits/stdc++.h>
using namespace std;
#define ls now<<1
#define rs now<<1|1
#define endl "\n"
#define lowbit(x) ((x)&(-x))
typedef long long ll;
const int N=3e5+7, mod=1e9+7;

int n,m,k;
int p[N];
int vis[N];
vector<pair<int,int>>ans;
vector<int>edges[N];
set<int>edge[N];

void dfs(int now){
	k++;
	vis[now]=1;
	for(int v:edges[now])edge[v].erase(now);
	while(edge[now].size()&&k<=n){
		if(!edge[now].count(p[k]))ans.push_back({now,p[k]});
		dfs(p[k]);
	}
}

void solve(){
	cin>>n>>m;
	ans.clear();
	k=0;
	for(int i=1;i<=n;i++){
		edge[i].insert(0);
		edge[0].insert(i);
		edges[i].push_back(0);
		edges[0].push_back(i);
	}
	for(int i=1;i<=m;i++){
		int u,v;
		cin>>u>>v;
		edge[u].insert(v);
		edge[v].insert(u);
		edges[u].push_back(v);
		edges[v].push_back(u);
	}
	for(int i=1;i<=n;i++)cin>>p[i];
	dfs(0);
	cout<<ans.size()<<endl;
	for(auto [x,y]:ans)cout<<x<<" "<<y<<endl;
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

### D. Decrease and Swap  

开始队友读错题，以为每个盒子里一块石头，差点上机特判，还好冷静了，虽然对结果也没什么影响  

实际上。每个盒子内都是无限块石头，那考虑时，可以考虑某个区间内的整体操作，即我们遍历向后扫，记录当前各出现的 $01$ 次数，如果 $cnt0>cnt1$ 那么，经过神奇的变换操作，我们一定可以将这个区间内所有的 $1$ 变为 $0$，最后如果 $cnt1+cnt0>3 || cnt1+cnt0==0$ 那么就是 Yes    

为什么 $cnt0>cnt1$ 当前区间一定能转化成功:  
- 因为我们的操作次数是无限的，同时这个触发条件一定有两个 $0$ ，那么我们经过一些交换后，总能使两个 $0$ 到达当前串的末尾，此时前面的盒子直接无脑消掉即可  

那么最后 $cnt1+cnt0>3$ 为什么是 Yes:  
- 最后剩下的没转化的串中，$1$ 的个数大于等于 $0$ 的个数，同时这个串的长度大于 $3$，即我们可以先对几个 $1$ 操作，转化出来两个 $0$，再根据前面的理论，此时的串一定能转换过去  

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
string s;
int cnt[N];

void solve(){
	cin>>n>>s;
	int c1=0,c0=0;
	for(int i=0;i<n;i++){
		if(s[i]=='1')c1++;
		else c0++;
		if(c0>c1)c1=c0=0;
	}
	if(c1+c0>3||c1+c0==0){
		cout<<"Yes\n";
	}
	else cout<<"No\n";
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

