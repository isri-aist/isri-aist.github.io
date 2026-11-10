---
layout: default
title: 過去のお知らせ
lang: ja
permalink: /archive/
---
<h2>年度別のお知らせ</h2>
{% assign ja_posts = site.posts | where: 'lang', 'ja' %}
{% assign years = ja_posts | group_by: 'fiscal_year' | sort: 'name' | reverse %}
{% for year in years %}<h3 id="fy{{ year.name }}">{{ year.name }}年度</h3><dl class="newsListCont">{% for post in year.items %}<dt>{{ post.date | date: '%Y/%m/%d' }}</dt><dd><a href="{{ post.url | relative_url }}">{{ post.title }}</a></dd>{% endfor %}</dl>{% endfor %}
