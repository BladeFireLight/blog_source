---
layout: archive
permalink: /faqs/
title: "Frequently Asked Questions"
date: 2015-09-23T14:11:44-04:00
excerpt: "Because no one likes to repeat things here's a compilation of answers to questions I'm often asked."
---

{{ page.excerpt | markdownify }}

Did I leave something out that you were looking for an answer to? Feel free to reach out and [ask me]({{ site.url }}/contact).

{% assign other_faqs = site.faqs | where: "type", "other" | sort: "order" %}
<!--
## Header
-->
<ul class="fl">
{% for faq in other_faqs %}
<li><a href="{{ faq.url }}">{{ faq.title }}</a></li>
{% endfor %}
</ul>
