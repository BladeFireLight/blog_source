---
layout: archive
permalink: /projects/
title: "PowerShell Projects"
date: 2016-03-01T15:05:16-04:00
excerpt: "A selection of scripts and modules I have worked on."
ads: false
tiles: false
feature:
  visible: false
  headline: "PowerShell Projects"
  category: projects
---

{{ page.excerpt | markdownify }}
## WindowsImageTools
{% for post in site.categories.projects %}
  {% if post.categories contains  'WindowsImageTools' %}
  {% include archive__item.html %}
  {% endif %}
{% endfor %}
<!-- 
## Proj2
{% for post in site.categories.projects %}
  {% if post.categories contains  'proj2' %}
  {% include archive__item.html %}
  {% endif %}
{% endfor %}
## other
{% for post in site.categories.projects %}
  {% if post.categories.size ==  1 %}
  {% include archive__item.html %}
  {% endif %}
{% endfor %}
-->