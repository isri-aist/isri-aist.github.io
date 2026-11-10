---
layout: default
title: News archive
lang: en
permalink: /en/archive/
---
<h2>News by fiscal year (April–March)</h2>
{% assign en_posts = site.posts | where: 'lang', 'en' %}
{% assign years = en_posts | group_by: 'fiscal_year' | sort: 'name' | reverse %}
{% for year in years %}<h3>{{ year.name }} fiscal year</h3><dl class="newsListCont">{% for post in year.items %}<dt>{{ post.date | date: '%Y/%m/%d' }}</dt><dd><a href="{{ post.url | relative_url }}">{{ post.title }}</a></dd>{% endfor %}</dl>{% endfor %}
