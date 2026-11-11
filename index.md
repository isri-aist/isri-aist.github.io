---
layout: default
title: ISRIトップ
lang: ja
permalink: /
---


<div class="mainContents">
<span style="font-size : 150%;
	color : #474747;
"><b>ロボティクス・AIで人口減少など社会課題に挑む</b></span> <br/>
      　当部門では、ロボティクス、AI、高精度センシング、安全・信頼性の高い制御技術を統合し、環境や人の状態をリアルタイムで認識し、自律的に判断・行動する「インテリジェントシステム」の研究開発を推進しています。高度作業ロボット、遠隔操作ロボット、ヒューマノイド、ドローン、自動運転など次世代ロボット技術の実現を目指しています。
      <br/>
<br/>
<div style="text-align: center;"><img alt="図：労働者不足等の社会課題の解決のためのインテリジェントシステムの実現" border="0" src="{{ '/ja/images/isri_concept_ja.jpg' | relative_url }}" style=""/></div>
<br/>
<br/>
<br/>
<!-- 更新履歴 -->
<div class="newsListTitle"><h2 id="info">お知らせ</h2></div>
<dl class="newsListCont">{% assign ja_posts = site.posts | where: 'lang', 'ja' %}{% for post in ja_posts limit:5 %}<dt>{{ post.date | date: '%Y/%m/%d' }}</dt><dd><a href="{{ post.url | relative_url }}">{{ post.title }}</a></dd>{% endfor %}</dl>
<p class="news-archive-link"><a href="{{ '/archive/' | relative_url }}">過去のお知らせはこちら →</a></p><!-- 連絡先 -->
<div class="grayLineBox">
<h2>連絡先</h2>
<h3>国立研究開発法人 産業技術総合研究所　情報・人間工学領域<br/>
        インテリジェントシステム研究部門</h3>
<p>　[代表]<br/>
        　〒305-8568　茨城県つくば市梅園1-1-1　中央事業所２群<br/>
        　電話: 029-861-6670<br/>
        　Eメール： M-isri-info-ml*aist.go.jp（*を@に変更して送信してください。）</p>
</div>
<br/>
<!-- アクセスカウンタ --><i>Count from 2025/06/13</i>　 <!-- アクセスカウンタここまで -->
</div>
