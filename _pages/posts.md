---
layout: archive
permalink: /posts/
title: "Blog Posts"
date: 2016-03-10
excerpt: "A collection of thoughts, ideas and scripts I've written."
subtitle: "A collection of thoughts, ideas and scripts I've written."
feature:
  visible: true
  headline: "Featured Posts"
  category: posts
---

{% for post in site.categories.posts %}
  {% if post.featured != true %}
  {% include archive__item.html %}
  {% endif %}
{% endfor %}
