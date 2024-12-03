---
title: "在 Hugging Face 上部署 AList (Aria2 和 Qbitorrent 可用)" #标题
date: 2024-12-01T14:57:08+08:00 #创建时间
lastmod: 2024-12-01T14:57:08+08:00 #更新时间
author: ["KiritoXD"] #作者
tags: 
- "AList"
- "Hugging Face"
summary: "我 TM 薅薅薅" #描述
categories: ['Tech'] #分类
weight: # 输入1可以顶置文章，用来给文章展示排序，不填就默认按时间排序
slug: ""
draft: false # 是否为草稿
showToc: true # 显示目录
TocOpen: true # 自动展开目录
hidemeta: false # 是否隐藏文章的元信息，如发布日期、作者等
disableShare: true # 底部不显示分享栏
showbreadcrumbs: true #顶部显示当前路径
password: ilovedio
---

### Hugging Face

首先注册 [抱抱脸](https://huggingface.co/) 账号，新建一个 space 

具体选项看图 ![123](https://img.chkaja.com/3b314c4f674d45be.png)   

接着在库里建一个 Dockerfile，把代码粘贴过去  

```dockerfile
FROM ubuntu:22.04

# Install necessary tools 
RUN apt-get update && \
    apt-get install -y software-properties-common && \
    add-apt-repository ppa:qbittorrent-team/qbittorrent-stable && \
    apt-get update && \
    apt-get install -y \
        qbittorrent-nox \
        tar \
        gzip \
        file \
        jq \
        curl \
        sed \
        aria2 \
        locales \
        locales-all && \
    rm -rf /var/lib/apt/lists/

RUN locale-gen zh_CN.UTF-8
ENV LANG=zh_CN.UTF-8 \
    LANGUAGE=zh_CN:zh \
    LC_ALL=zh_CN.UTF-8

# Set up a new user named "user" with user ID 1000 
RUN useradd -m -u 1000 user 

# Switch to the "user" user 
USER user 

# Set home to the user's home directory 
ENV HOME=/home/user \ 
    PATH=/home/user/.local/bin:$PATH 

# Set the working directory to the user's home directory 
WORKDIR $HOME/alist 

# Download the latest alist release using jq for robustness 
RUN curl -sL https://api.github.com/repos/alist-org/alist/releases/latest | \ 
    jq -r '.assets[] | select(.name | test("linux-amd64.tar.gz$")) | .browser_download_url' | \ 
    xargs curl -L | tar -zxvf - -C $HOME/alist 

# Set up the environment 
RUN chmod +x $HOME/alist/alist && \ 
    mkdir -p $HOME/alist/data 

# Create data/config.json file with database configuration 
RUN echo '{\
    "force": false,\
    "address": "0.0.0.0",\
    "port": 5244,\
    "scheme": {\
        "https": false,\
        "cert_file": "",\
        "key_file": ""\
    },\
    "cache": {\
        "expiration": 60,\
        "cleanup_interval": 120\
    },\
    "database": {\
        "type": "mysql",\
        "host": "ENV_MYSQL_HOST",\
        "port": ENV_MYSQL_PORT,\
        "user": "ENV_MYSQL_USER",\
        "password": "ENV_MYSQL_PASSWORD",\
        "name": "ENV_MYSQL_DATABASE"\
    }\
}' > $HOME/alist/data/config.json 

# Create a startup script that runs Alist and Aria2 
RUN echo '#!/bin/bash\n\
sed -i "s/ENV_MYSQL_HOST/${MYSQL_HOST:-localhost}/g" $HOME/alist/data/config.json\n\
sed -i "s/ENV_MYSQL_PORT/${MYSQL_PORT:-3306}/g" $HOME/alist/data/config.json\n\
sed -i "s/ENV_MYSQL_USER/${MYSQL_USER:-root}/g" $HOME/alist/data/config.json\n\
sed -i "s/ENV_MYSQL_PASSWORD/${MYSQL_PASSWORD:-password}/g" $HOME/alist/data/config.json\n\
sed -i "s/ENV_MYSQL_DATABASE/${MYSQL_DATABASE:-alist}/g" $HOME/alist/data/config.json\n\
aria2c --enable-rpc --rpc-listen-all --rpc-allow-origin-all --rpc-listen-port=6800 --daemon\n\
qbittorrent-nox --webui-port=8080 &\n\
$HOME/alist/alist server --data $HOME/alist/data' > $HOME/alist/start.sh && \ 
    chmod +x $HOME/alist/start.sh 

# Set the command to run when the container starts 
CMD ["/bin/bash", "-c", "/home/user/alist/start.sh"] 

# Expose the default Alist port 
EXPOSE 5244 6800 8080
```

再在 readme.md 里增添一行 `app_port:5244`  

注册一个 mysql 数据库，方便机子重启数据不丢失

推荐用 [sqlpub](https://sqlpub.com/) 或者 [db4free](https://www.db4free.net/)  

然后添加 variables:
- MYSQL_USER
- MYSQL_PORT (默认 3306)
- MYSQL_PASSWORD
- MYSQL_HOST (db4free.net 或 mysql.sqlpub.com)
- MYSQL_DATABASE

### AList 

第一次启动 (对 sql 来说) 会生成一个密码，记得在 log 里找，登录上去之后可以导入以前配置什么的，即可正常使用  

### Cloudflare Worker

#### 公开库

前文图上推荐设置为私人库，可能能活更久，但是搜索公开库发现 AList 泛滥，还不如方便方便自己，公开库后便可以使用 Worker 反代到自己域名下访问  


```js
export default {
  async fetch(request, env) {
    const _url = new URL(request.url);
    const hostname = _url.hostname
    _url.hostname = "github.com"
    const req = new Request(_url, request);
    req.headers.set('origin', 'https://github.com');
    
    const res = await fetch(req);
    let newres = new Response(res.body, res);

    let location = newres.headers.get('location');
    if (location !== null && location !== "") {
      location = location.replace('://github.com', '://'+hostname);
      newres.headers.set('location', location);
    }
    return newres 
  },
};
```

替换 `github.com` 为 `用户名-space名.hf.space` 即可

#### 私库 (AList 不可用此方法)

只适用于 `header` 不包含 `Authorization`

刚发现私人库通过 access token 也可以反代访问  

访问地址同样如上 `用户名-space名.hf.space`  

在抱抱脸上点头像后选择 access token  

![1](https://img.chkaja.com/8f95e342a0c360f9.png)  

名称随意

token 权限选 Repositories 的三个即可

![2](https://img.chkaja.com/aada7646d202b430.png)

Worker 代码如下  

在设置中添加变量 HF_TOKEN 值为上文生成的 access token

```js
export default {
  async fetch(request, env) {
    const url = new URL(request.url);
    
    // 处理API请求和其他请求
    url.host = 'xxxx.hf.space';
    
    // 添加认证头用于访问私有空间
    const headers = new Headers(request.headers);
    headers.set('Authorization', `Bearer ${env.HF_TOKEN}`);
    
    const newRequest = new Request(url, {
      method: request.method,
      headers: headers,
      body: request.body
    });
    
    return fetch(newRequest);
  }
}
```
