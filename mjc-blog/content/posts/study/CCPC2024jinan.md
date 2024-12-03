---
title: "CCPC2024jinan" #标题
date: 2024-12-03T12:20:07+08:00 #创建时间
lastmod: 2024-12-03T12:20:07+08:00 #更新时间
author: ["KiritoXD"] #作者
tags: ['补题', 'CCPC']
summary: "VP 差强人意" #描述
categories: ['Study'] #分类
description: ""
weight: # 输入1可以顶置文章，用来给文章展示排序，不填就默认按时间排序
slug: ""
draft: false # 是否为草稿
showToc: true # 显示目录
TocOpen: true # 自动展开目录
hidemeta: false # 是否隐藏文章的元信息，如发布日期、作者等
disableShare: true # 底部不显示分享栏
showbreadcrumbs: true #顶部显示当前路径
password:  #密码，默认不加密
---

### 前言

又是差罚时能偷银，唉，还是实力不够，这场感觉可写的不少，和之前 vp 南京那场差不多

### A. The Fool

刚开始一眼以为找 QWQ 差点交了，还好考虑了一下，实际是一堆相同的串，里面会有一个串与其他串不同，输出那个串的位置

```cpp
#include <bits/stdc++.h>
using namespace std;
int main(){
    int n,m,k;
    cin>>n>>m>>k;
    string s[n+1];
    map<string,vector<pair<int,int>>>mp;
    for(int i=1;i<=n;i++)cin>>s[i];
    for(int i=1;i<=n;i++){
        int cnt=1;
        for(int j=0;j<(int)s[i].size();j+=k){
            string tmp=s[i].substr(j,k);
            mp[tmp].push_back({i,cnt});
            cnt++;
        }
    }
    for(int i=1;i<=n;i++){
        int cnt=1;
        for(int j=0;j<(int)s[i].size();j+=k){
            string tmp=s[i].substr(j,k);
            if(mp[tmp].size()==1){
                cout<<i<<" "<<cnt<<endl;
                return 0;
            }
            cnt++;
        }
    }
}
```

### J. Temperance

被题意哈住了，实际上先删值小的并不会影响到后面的，因为如果他和后面值更大的在同一行或列，他也是那个大值，而不是这个小的值

所以只需要统计小于 $i$ 的值有多少个即可

```cpp
#include <bits/stdc++.h>
using namespace std;
const int N = 1e5+7;

int a[N],b[N],c[N];
int n;

void solve(){
    map<int,int>x,y,z;
    vector<int>s;
    cin>>n;
    for(int i=1;i<=n;i++){
        cin>>a[i]>>b[i]>>c[i];
        x[a[i]]++;
        y[b[i]]++;
        z[c[i]]++;
    }
    for(int i=1;i<=n;i++){
        int tmp=-1;
        tmp=max({x[a[i]]-1,y[b[i]]-1,z[c[i]]-1});
        s.push_back(tmp);
    }
    sort(s.begin(),s.end());
    s.push_back(N+50);
    int cnt=0;
    for(int i=0;i<n;i++){
        while(s[cnt]<i&&cnt<(int)s.size())cnt++;
        cout<<cnt<<" ";
    }
    cout<<"\n";
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

### B. The Magician

一共 $52$ 张牌，每种牌最多 $13$ 张，最多剩下 $3$ 张，即一共最多剩下 $12$ 张，要求的其实就是用这 $12$ 张能再拼出几个同花顺

队长大模拟两发过

```cpp
#include <bits/stdc++.h>
using namespace std;
const int N=1e5+7;
int cnt[5],id[1000],flag[5],num=0;
bool vis[5];
bool sol()
{
    int sum=0,now[5],tmp=num,ff[5];
    for(int i=1;i<=4;++i) {
        if(!vis[i])  sum+=cnt[i];
        now[i]=cnt[i];
        ff[i]=flag[i];
    }
    for(int i=1;i<=4;++i) {
        if(!vis[i])  continue;
        if(ff[i]){
            int x=min(3,5-now[i]);
            now[i]+=x;
            sum-=x;
            ff[i]=0;
        }
        if(now[i]==5)  continue;
        int x=min(tmp,5-now[i]);
        now[i]+=x;
        tmp-=x;sum-=x;
        if(now[i]==5)  continue;
        else  return 0;
    }
    return 1;
}
bool dfs(int k)
{
    if(k==0) {
        return  sol();
    }
    for(int i=1;i<=4;++i) {
        if(vis[i])  continue;
        vis[i]=1;
        bool x=dfs(k-1);
        if(x)  return 1;
        vis[i]=0;
    }
    return 0;
}
void solve()
{
    num=0;
    for(int i=1;i<=4;++i)  cnt[i]=flag[i]=0,vis[i]=0;
    int n,ans=0;
    cin>>n;
    for(int i=1;i<=n;++i) {
        string s;
        cin>>s;
        ++cnt[id[s[1]]];
    }
    for(int i=1;i<=4;++i) {
        ans+=cnt[i]/5;
        cnt[i]%=5;
    }
    for(int i=1;i<=4;++i)  cin>>flag[i];
    for(int i=1;i<=2;++i) {
        int x;
        cin>>x;
        num+=x;
    }
    int tot=0;
    for(int i=1;i<=4;++i) {
        tot+=cnt[i];
    }
    for(int i=tot/5;i>=1;--i) {
        bool x=dfs(i);
        if(x) {
            ans+=i;
            break;
        }
    }
    printf("%d\n",ans);
    
}
int main()
{
    ios::sync_with_stdio(0);
    cin.tie(0);cout.tie(0);
    id['D']=1;id['C']=2;id['H']=3;id['S']=4;
    int T=1;
    cin>>T;
    
    while(T--) {
        solve();
    }
    return 0;
}
```

### F. The Hermit

#### 加的思路

开始我想的是统计每种数可能被删的次数，最后在所有的答案中减去这部分

但是想错了一点就是只考虑了删前几位，没有考虑倍增时，前面的几个都能删

队长想的是按长度分开，前面的部分是倍增关系需要删的，后面部分是留下的，加到答案上的

前面的片段的长度只可能为 $O(\log n)$，同时确定前面片段的最大值之后，后面的片段只需要按组合数计算得出数量即可

每次加前面片段的种类数量乘以后面片段的种类数量即可

口胡得到这个应该是 $O(n \log n \log n)$ 的来着，实际交上去只跑了 $200$ 多 $ms$

```c
#include <bits/stdc++.h>
using namespace std;
typedef long long ll;
const int N=1e5+7,mod=998244353;
ll jc[N],inv[N],f[N][20],n,m,g[N][20],id[N];
ll qpow(ll x,ll k)
{
    ll ans=1,tmp=x;
    while(k) {
        if(k&1)  ans=ans*tmp%mod;
        tmp=tmp*tmp%mod;
        k>>=1;
    }
    return ans;
}
ll C(int x,int y)
{
    if(x<y)  return 0;
    return jc[x]*inv[y]%mod*inv[x-y]%mod;
}
ll calc(int x,int y)
{
    if(x<y)  return 0;
    if(y==0)  return 0;
    if(g[id[x]][n-y]!=-1)  return g[id[x]][n-y];
    ll sum=0;
    for(int i=1;i<=x;++i) {
        sum=(sum+C(x/i-1,y-1))%mod;
    }
    sum=(C(x,y)-sum+mod)%mod;
    g[id[x]][n-y]=sum;
    return sum;
}
void solve()
{
    memset(g,-1,sizeof(g));
    int tot=0;
    cin>>m>>n;
    inv[0]=jc[0]=1;
    for(int i=1;i<=m;++i) {
        jc[i]=jc[i-1]*i%mod;
        inv[i]=inv[i-1]*qpow(i,mod-2)%mod;
        if(!id[m/i])  id[m/i]=++tot;
    }
    ll ans=calc(m,n)*n%mod;
    for(int i=1;i<=m;++i) {
        f[i][1]=1;
        for(int j=1;j<=19&&j<=n;++j) {
            if(!f[i][j])  break;
            for(int k=i*2;k<=m;k+=i)  f[k][j+1]=(f[k][j+1]+f[i][j])%mod;
            ll x=calc(m/i,n-j);
            ans=(ans+f[i][j]*x%mod*(n-j)%mod)%mod;
        }
    }
    printf("%lld",ans);
}
int main()
{
    ios::sync_with_stdio(0);
    cin.tie(0);cout.tie(0);
    int T=1;
    // cin>>T;
    while(T--) {
        solve();
    }
    return 0;
}
```

#### 减的思路

题解和我开始想那种有点类似，是减每个数能被删的次数

把队长那个和我想的结合下差不多

按题解的思路：

+   先固定一个元素 $x$，如果他能被删掉：
    +   比他小的，构成了一个以 $x$ 结尾的倍数链
    +   比他大的，都是 $x$ 的倍数
+   小的部分枚举倍数链，求得长度为 c，当前值为 x 的链的数量
+   大的部分直接组合数求

最后减去的总数为 $\sum_{1\leq c\leq n,1\leq x\leq m}f_{c,x}\cdot
\begin{pmatrix}
\lfloor m/x\rfloor-1 \\
n-c
\end{pmatrix}.$