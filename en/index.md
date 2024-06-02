---
layout: default
title: AIST  -  Intelligent Systems Research Institute
lang: en
permalink: /en/
---


<div class="mainContents">
<span style="color : #333333;
	font-size : 120%;
"><b>Solving Japan’s challenges with robotics and AI technologies</b></span> <br/>
<p class="justify">We promote R&amp;D of “Intelligent Systems” that integrate robotics, AI,
      advanced sensing, and dependable control. These systems autonomously recognize
      people and environments in real-time and respond accordingly. Our focus
      includes next-generation robotics and automation: intelligent task-performing
      robots, teleoperated systems, humanoids, drones, personal mobility, and
      autonomous transport services, as well as technologies that enhance their
      safety and reliability. </p>
<div style="text-align: center;"><img border="0" src="{{ '/en/images/isri_concept_en.jpg' | relative_url }}" style=""/></div>
<br/>
<br/>
<div class="newsListTitle"><h2>What's New</h2></div>
<dl class="newsListCont">{% assign en_posts = site.posts | where: 'lang', 'en' %}{% for post in en_posts limit:5 %}<dt>{{ post.date | date: '%Y/%m/%d' }}</dt><dd><a href="{{ post.url | relative_url }}">{{ post.title }}</a></dd>{% endfor %}</dl>
<p class="news-archive-link"><a href="{{ '/en/archive/' | relative_url }}">Past news →</a></p>
<br/>
<!-- Inquiry -->
<div class="grayLineBox">
<h2>Inquiry</h2>
<h3>Intelligent Systems Research Institute</h3>
<p>Address : AIST Tsukuba Central 2, 1-1-1 Umezono, Tsukuba, Ibaraki, 305-8568,
        Japan<br/>
        Phone: +81-29-861-6670<br/>
        Email: M-isri-info-ml*aist.go.jp (Please convert "*" to "@".)</p>
</div>
<!-- Inquiry end --><br/>
</div>
