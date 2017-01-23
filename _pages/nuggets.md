---
layout: archive
permalink: /nuggets/
title: "PowerShell Nuggets"
date: 2016-03-10
excerpt: "A collection of little nuggets of PowerShell I found useful."
subtitle: "A collection of little nuggets of PowerShell I found useful."
feature:
  visible: true
  headline: "Featured Nuggets"
  category: nuggets
---

{% for post in site.categories.nuggets %}
  {% include archive-single.html %}
{% endfor %}
