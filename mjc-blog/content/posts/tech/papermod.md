---
title: "Papermod" #标题
date: 2024-12-02T21:45:20+08:00 #创建时间
lastmod: 2024-12-02T21:45:20+08:00 #更新时间
author: ["KiritoXD"] #作者
tags: 
- "paper-mod"
- "blog"
summary: "记录优化主题的过程"
categories: ['Tech'] #分类
description: "记录优化主题的过程" #描述
weight: # 输入1可以顶置文章，用来给文章展示排序，不填就默认按时间排序
slug: ""
draft: false # 是否为草稿
showToc: true # 显示目录
TocOpen: true # 自动展开目录
hidemeta: false # 是否隐藏文章的元信息，如发布日期、作者等
disableShare: true # 底部不显示分享栏
showbreadcrumbs: true #顶部显示当前路径
---

## 搜索页

### 添加标签  

在 `./layouts/_default/search.html` 中末尾添加  

```html
{{- if not (.Param "hideTags") }}
{{- $taxonomies := .Site.Taxonomies.tags }}
{{- if gt (len $taxonomies) 0 }}
<h2 style="margin-top: 32px">{{- (.Param "tagsTitle") | default "tags" }}</h2>
<ul class="terms-tags">
    {{- range $name, $value := $taxonomies }}
    {{- $count := .Count }}
    {{- with site.GetPage (printf "/tags/%s" $name) }}
    <li>
        <a href="{{ .Permalink }}">{{ .Name }} <sup><strong><sup>{{ $count }}</sup></strong></sup> </a>
    </li>
    {{- end }}
    {{- end }}
</ul>
{{- end }}
{{- end }}
```

同时去 `./content/search.md` 添加如下  

```yml
hideTags: false
tagsTitle: Tags 
```

### Fuse.js 

可以通过修改 `config.yml` 来配置搜索  

```yml
  fuseOpts: # 搜索配置
    isCaseSensitive: false
    shouldSort: true
    location: 0
    distance: 1000
    threshold: 0.4
    minMatchCharLength: 0
    keys: [ "title", "permalink", "summary", "content" ]
```

## 文章概览

使用的应该是 `summary` 而不是 `description`