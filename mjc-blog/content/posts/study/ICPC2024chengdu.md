---
title: "ICPC2024chengdu" #标题
date: 2024-11-08T21:36:35+08:00 #创建时间
lastmod: 2024-11-08T21:36:35+08:00 #更新时间
author: ["KiritoXD"] #作者
tags: 
- "补题"
description: "" #描述
summary: "ICPC 区域赛首战，前排铜，还可以" #描述
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
### L. Recover Statistics

直接按要求输出 100 个数即可  

```c
#include <bits/stdc++.h>
using namespace std;
#define ls now << 1
#define rs now << 1 | 1
#define endl "\n"
#define lowbit(x) ((x) & (-x))
typedef long long ll;
const int N = 1e5 + 7, mod = 1e9 + 7;

void solve() {
    int a,b,c;
    cin>>a>>b>>c;
    cout<<100<<endl;
    for(int i=1;i<=50;i++){
        cout<<a<<" ";
    }
    for(int i=1;i<=45;i++){
        cout<<b<<" ";
    }
    for(int i=1;i<=4;i++){
        cout<<c<<" ";
    }
    cout<<c+1;
}

int main() {
    ios::sync_with_stdio(0);
    cin.tie(0);
    cout.tie(0);
    int t = 1;
    // cin >> t;
    while (t--) solve();
    return 0;
}
```

### J. Grand Prix of Ballance

按题意模拟即可  

赛时榜歪了，应该直接上机写的  

```c
#include <bits/stdc++.h>
using namespace std;
#define ls now << 1
#define rs now << 1 | 1
#define endl "\n"
#define lowbit(x) ((x) & (-x))
typedef long long ll;
const int N = 1e5 + 7, mod = 1e9 + 7;

struct Node{
    int id,flag;
    ll val;
    bool operator<(const Node &t){
        if(val==t.val)return id<t.id;
        return val>t.val;
    }
}a[N];

int n,m,q,op,x,id,flag,cnt;

void solve() {
    cin>>n>>m>>q;
    flag=0;
    cnt=0;
    for(int i=1;i<=m;i++)a[i].id=i,a[i].val=0,a[i].flag=0;
    while(q--){
        cin>>op;
        if(op==1){
            cin>>x;
            if(x>n)continue;
            flag=x;
            cnt=0;
        }
        else if(op==2){
            cin>>id>>x;
            if(a[id].flag==flag||x!=flag)continue;
            a[id].flag=flag;
            a[id].val+=(m-cnt);
            cnt++;
        }
        else{
            cin>>id>>x;
            if(a[id].flag==flag||x!=flag)continue;
            a[id].flag=flag;
        }
    }
    sort(a+1,a+1+m);
    for(int i=1;i<=m;i++){
        cout<<a[i].id<<" "<<a[i].val<<endl;
    }
}

int main() {
    ios::sync_with_stdio(0);
    cin.tie(0);
    cout.tie(0);
    int t = 1;
    cin >> t;
    while (t--) solve();
    return 0;
}
```

### A. Arrow a Row

首先可以确定 No 的情况：第一个为 `-`；后三个不是 `>>>`；没有 `-` 存在  

接着分析如何构造原串   

我们可以每次确定 1 个位置

后缀确定后基本不会再变动，所以我们先考虑构造后缀，可以先构造出后缀连续的 > 片段，全部从 1 开始，长度逐渐从 n 递减  

接着构造前面的片段，先保证构造的片段不会影响后缀，即选取的箭串 `-` 不能影响到后缀，即确定了当前构造的长度  

```c
#include <bits/stdc++.h>
using namespace std;
#define ls now<<1
#define rs now<<1|1
#define endl "\n"
#define lowbit(x) ((x)&(-x))
typedef long long ll;
const int N=1e5+7, mod=1e9+7;

string s;
deque<pair<int,int>>q;

void solve(){
    cin>>s;
    int n=s.size();
    q.clear();
    s=" "+s;
    if(s.substr(n-2,3)!=">>>"||s[1]=='-'||s.find('-')==-1){
        cout<<"No\n";
        return;
    }
    cout<<"Yes ";
    int cnt=0;
    for(int i=n;i>0;i--){
        if(s[i]=='>')cnt++;
        else break;
    }
    for(int i=n;i>n-cnt+3;i--){
        if(s[i]=='>'){
            q.push_back({1,i});
        }
        else break;
    }
    int r=n-cnt+3;
    for(int i=1;i<r-2;i++){
        if(s[i]=='>'){
            q.push_back({i,r-i+1});
        }
    }
    cout<<q.size()<<endl;
    for(auto [x,y]:q){
        cout<<x<<" "<<y<<endl;
    }
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

### G. Expanding Array

赛时被卡太久了，不然真感觉银有望  

队友已经手玩出最多 8 种可能，但当时想复杂了  

实际上确实只有这么多可能  

某位上有 0,1 时，二者都可以取，只有 1 时只能进行异或操作，只有 0 时怎么操作都不会产生变化  

所以可以选取 011,101 两个数，看怎样操作才能取得所有的可能  

假设二者为 x,y  

首先是二者本身 x,y  

接着是 x^y x|y x&y  

然后是 x|(x^y)  y|(x^y)  

最后是 (x^y)^(x^y) 即为 0  

依次插入一个 set 中即可   

```c
#include <bits/stdc++.h>
using namespace std;
#define ls now << 1
#define rs now << 1 | 1
#define endl "\n"
#define lowbit(x) ((x) & (-x))
typedef long long ll;
const int N = 1e5 + 7, mod = 1e9 + 7;

int n;
set<int>s;
int a[N];

void solve() {
    cin>>n;
    for(int i=1;i<=n;i++)cin>>a[i];
    for(int i=1;i<n;i++){
        s.insert(a[i]);
        s.insert(a[i+1]);
        s.insert(a[i]^a[i+1]);
        s.insert((a[i]^a[i+1])&a[i]);
        s.insert((a[i]^a[i+1])&a[i+1]);
        s.insert(a[i]|a[i+1]);
        s.insert(a[i]&a[i+1]);
        s.insert(0);
    }
    cout<<s.size()<<endl;
}

int main() {
    ios::sync_with_stdio(0);
    cin.tie(0);
    cout.tie(0);
    // freopen("..//..//in_out//in.txt", "r", stdin);
    // freopen("..//..//in_out//out.txt", "w", stdout);
    int t = 1;
    // cin >> t;
    while (t--) solve();
    return 0;
}
```

### I. Good Partitions

找原数组中的不下降的片段，可以将每个片段的终止位置储存起来，此时的答案就是所有片段长度的 gcd 的因子个数  

常见的维护区间 gcd 是使用线段树，统计因子个数采用埃氏筛即可  

修改时同步 update 即可使 tr[1] 中始终存储为所有片段的 gcd  

```c
#include <bits/stdc++.h>
using namespace std;
#define ls now<<1
#define rs now<<1|1
#define endl "\n"
#define lowbit(x) ((x)&(-x))
typedef long long ll;
const int N=2e5+7, mod=1e9+7;

int tr[N<<2];
int n,q,a[N],x,v,cf[N],phi[N];

void init(int n){
    for(int i=1;i<=n;i++){
        for(int j=1;j*i<=n;j++){
            phi[j*i]++;
        }
    }
}

void update(int now){
    tr[now]=__gcd(tr[ls],tr[rs]);
}

void build(int now,int l,int r){
    if(l==r){
        if(cf[l]<0){
            tr[now]=l;
        }
        else tr[now]=0;
        return;
    }
    int mid=(l+r)>>1;
    build(ls,l,mid);
    build(rs,mid+1,r);
    update(now);
}

void modify(int now,int l,int r,int val,int pos){
    if(l==r){
        if(val>=0){
            tr[now]=0;
        }
        else tr[now]=l;
        return;
    }
    int mid=(l+r)>>1;
    if(pos<=mid){
        modify(ls,l,mid,val,pos);
    }
    else modify(rs,mid+1,r,val,pos);
    update(now);
}

void solve(){
    cin>>n>>q;
    for(int i=1;i<=n;i++)cin>>a[i];
    for(int i=1;i<n;i++)cf[i]=a[i+1]-a[i];
    if(n==1){
        cout<<1<<endl;
        while(q--){
            cin>>x>>v;
            cout<<1<<endl;
        }
        return;
    }
    build(1,1,n-1);
    int ans=abs(tr[1]);
    if(n==1||ans==0)cout<<n<<endl;
    else cout<<phi[ans]<<endl;
    while(q--){
        cin>>x>>v;
        a[x]=v;
        if(x>1)modify(1,1,n-1,a[x]-a[x-1],x-1);
        if(x<n)modify(1,1,n-1,a[x+1]-a[x],x);
        if(n==1){
            cout<<n<<endl;
            continue;
        }
        ans=abs(tr[1]);
        if(!ans){
            cout<<n<<endl;
        }
        else cout<<phi[ans]<<endl;
    }
}

int main(){
    ios::sync_with_stdio(0);
    cin.tie(0);cout.tie(0);
    init(N);
    int t=1;
    cin>>t;
    while(t--)solve();
    return 0;
}
```

### B. Athlete Welcome Ceremony

找出所有的可行方案，再利用前缀和求出当前所给的选择的总和即可  

```c
#include <bits/stdc++.h>
using namespace std;
#define ls now<<1
#define rs now<<1|1
#define endl "\n"
#define lowbit(x) ((x)&(-x))
typedef long long ll;
const int N = 3e2 + 5, mod = 1e9 + 7;

int n, q, x, y, z;
string s;
ll dp[2][N][N][4], f[N][N];
map<char, int> tr;
int cnt = 0;

void init() {
    if (s[1] == '?') {
        dp[1 % 2][1][0][1] = 1;
        dp[1 % 2][0][1][2] = 1;
        dp[1 % 2][0][0][3] = 1;
        cnt++;
    } else {
        dp[1 % 2][0][0][tr[s[1]]] = 1;
    }

    for (int i = 2; i <= n; i++) {
        memset(dp[i % 2], 0, sizeof(dp[i % 2])); // 清零当前 dp 层
        if (s[i] == '?') cnt++;
        for (int j = 0; j <= i; j++) {
            for (int k = 0; j + k <= i; k++) {
                if (s[i] == '?') {
                    // 对于 '?', 更新状态时考虑所有字符
                    for (int l = 1; l <= 3; l++) {
                        int x, y;
                        if (l == 1) x = 2, y = 3;
                        else if (l == 2) x = 1, y = 3;
                        else x = 1, y = 2;
                        if (j - (l == 1) < 0 || k - (l == 2) < 0) continue;
                        dp[i % 2][j][k][l] = (dp[i % 2][j][k][l] + dp[(i + 1) % 2][j - (l == 1)][k - (l == 2)][x] + dp[(i + 1) % 2][j - (l == 1)][k - (l == 2)][y]) % mod;
                    }
                } else {
                    int x = tr[s[i]];
                    for (int l = 1; l <= 3; l++) {
                        if (l != x) {
                            dp[i % 2][j][k][x] = (dp[i % 2][j][k][x] + dp[(i + 1) % 2][j][k][l]) % mod;
                        }
                    }
                }
            }
        }
    }

    // 构建 f 数组（合法三维前缀和）
    for (int i = 0; i <= cnt; i++) {
        for (int j = 0; j + i <= cnt; j++) {
            f[i][j] = 0;
            for (int k = 1; k <= 3; k++) {
                f[i][j] = (f[i][j] + dp[n % 2][i][j][k]) % mod;
            }
        }
        // 计算前缀和
        for (int j = 1; i + j <= cnt; j++) {
            f[i][j] = (f[i][j] + f[i][j - 1]) % mod;
        }
    }
}

void solve() {
    cin >> n >> q >> s;
    s = " " + s;  // 字符串下标从1开始
    init();
    while (q--) {
        cin >> x >> y >> z;
        ll ans = 0;
        // 处理查询，计算合法的三维前缀和
        for (int i = 0; i <= x; i++) {
            int j = cnt - z - i;
            if (i > cnt) break;
            if (j > y) continue;
            j = max(0, j);
            j = min(j, cnt - i);
            ans = (ans + f[i][min(y, cnt - i)] - (j > 0 ? f[i][j - 1] : 0) + mod) % mod;
        }
        cout << ans << endl;
    }
}

int main() {
    ios::sync_with_stdio(0);
    cin.tie(0); cout.tie(0);
    int t = 1;
    tr['a'] = 1, tr['b'] = 2, tr['c'] = 3;
    while (t--) solve();
    return 0;
}
```
