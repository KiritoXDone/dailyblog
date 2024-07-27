+++
title = "简单的排序"
date = "2024-07-20T12:16:26+08:00"


tags = ["sort",]
+++

# 简单的排序实现

***

## 快速排序

 快排 分治思想 复杂度[nlogn,n^2] 不稳定 --x随机取   
 排序区间为[l,r]时，长度小于1，直接退出，否则选一个数字x作为比较元素   
 将大于x的放右边，小于x的放左边，等于x的随意放   
 确定x的位置后，对两侧继续递归    

```
void quicksort(int l, int r) {
    if (l >= r) return; // 长度小于1，直接退出  
    swap(a[l], a[l + rand() % (r - l + 1)]); // 保证x随机取  
    int x = a[l];  
    int i = l, j = r;  
    while (i < j) {  
        while (i < j && a[j] > x) // 不能写成a[j] >= x  
            j--;  
        if (i < j)   
            a[i++] = a[j];  
        while (i < j && a[i] < x) // 不能写成a[i] <= x  
            i++;  
        if (i < j)    
            a[j--] = a[i];   
    }   
    a[i] = x;  
    quicksort(l, i - 1); // 不能递归i  
    quicksort(i + 1, r);      
}
```

//另一种写法
```
void Quicksort(int l, int r){   
    if(l>=r)return;   
    int b[100001],c[100001];  
    int x=a[l+rand()&(r-l+1)];  
    int l1=0,l2=0,y=0;  
    for(int i=l;i<=r;i++){  
        if(a[i]<x)  
            b[++l1]=a[i];  
        else   
            if(a[i]>x)  
                c[++l2]=a[i];  
            else ++y;  
    }  
    for(int i=1;i<=l1;i++)
        a[l+i-1]=b[i];  
    for(int i=1;i<=y;i++)  
        a[l+l1+i-1]=x;  
    for(int i=1;i<=l2;i++)  
        a[l+l1+y+i-1]=c[i];  
    Quicksort(l,l+l1-1);  
    Quicksort(l+l1+y,r);  
}
```

***
## 归并排序

归并排序 分治 复杂度 nlogn 且稳定
要排序[l,r]，长度为1直接退出，否则分为[l,m],[m+1,r];
递归两个子区间进行归并排序
将排序好的子区间合并

```
void mergesort(int l,int r){
    if(l==r)return;
    int m=(l+r)/2;
    mergesort(l,m);
    mergesort(m+1,r);
    int p1=l,p2=m+1,tot=0;
    while(p1<=m&&p2<=r){
        if(a[p1]<=a[p2])
            c[++tot]==a[p1++];
        else
            c[++tot]=a[p2++];
    }
    while(p1<=m)
        c[++tot]=a[p1++];
    while(p2<=m)
        c[++tot]=a[p2++];
    for(int i=1;i<=tot;i++)
        a[i+l-1]=c[i];
}
```
***

## 计数排序

计数排序 适合值域范围较小 复杂度 n+k 稳定
统计每个数字出现了几次
统计完出现次数，求前缀和，可知道每个数字在拍完序的位置的范围
保证稳定性，倒着确定原本每个位置上的数字最后排在低级位

```
void countingsort(){
    memset(c,0,sizeof(c));
    for(int i=1;i<=n;i++)
        ++c[a[i]];
    for(int i=1;i<=m;i++)
        for(int j=1;j<=c[i];j++)
            printf("%d",i);
    printf("\n");

    for(int i=2;i<=m;i++)
        c[i]+=c[i-1];
    for(int i=n;i;i--)
        r[i]=c[a[i]]--;
    for(int i=1;i<=n;i++)
        printf("%d",r[i]);
    printf("\n");
}
```
***

## 基数排序

基数排序 复杂度 nk
拆分成 m 个关键字 从后往前 依次对m个关键字进行排序
每次排序会使用上一次排序的结果
一般使用计数排序来完成每次的排序
例如对三位数排序 先排个位 再排十位 再排百位
经常被用于字符串的排序 后缀数组的核心就是基数排序

```
void countingsort(){
    memset(c,0,sizeof(c));
    for(int i=1;i<=n;i++)
        ++c[v[i]];
    for(int i=1;i<=9;i++)
        c[i]+=c[i-1];
    for(int i=n;i;i--)
        r[sa[i]]=c[v[sa[i]]]--;
    for(int i=1;i<=n;i++)
        sa[r[i]]=i;
}

void radixsort(){
    for(int i=1;i<=n;i++)
        sa[i]=i;
    int x=1;
    for(int i=1;i<=m;i++,x*=10){
        for(int j=1;j<=n;j++){
            v[j]=a[j]/x%10;
        }
        countingsort();
    }
}
```
