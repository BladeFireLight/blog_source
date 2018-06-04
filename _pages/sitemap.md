---
layout: archive
title: "Sitemap"
permalink: /sitemap/
author_profile: false
---

A list of all the posts and pages found on the site. For you robots out there is an [XML version]({{ "sitemap.xml" | absolute_url }}) available for digesting as well.

<h2>Pages</h2>
{% for post in site.pages %}
  {% include archive-single.html %}
{% endfor %}

<h2>Posts</h2>
{% for post in site.posts %}
  {% include archive-single.html %}
{% endfor %}

{% capture written_label %}'None'{% endcapture %}

{% for collection in site.collections %}
{% unless collection.output == false or collection.label == "posts" %}
  {% capture label %}{{ collection.label }}{% endcapture %}
  {% if label != written_label %}
  <h2>{{ label }}</h2>
  {% capture written_label %}{{ label }}{% endcapture %}
  {% endif %}
{% endunless %}
{% for post in collection.docs %}
  {% unless collection.output == false or collection.label == "posts" %}
  {% include archive-single.html %}
  {% endunless %}
{% endfor %}
{% endfor %}


A hierarchical breakdown of all the sections and pages found on the site. For you robots out there is an [XML version]({{ site.url }}/sitemap.xml) available for digesting.

<div class="sitemap">
  <ul id="primaryNav" class="col5">
    <li id="home"><a href="{{ site.url }}/">Home</a></li>
    <li><a href="{{ site.url }}/about/">About</a>
      <ul>
        <li><a href="{{ site.url }}/faqs/">Frequently Asked Questions</a></li>
        <li><a href="{{ site.url }}/contact/">Contact</a></li>
        <li><a href="{{ site.url }}/support/">Support</a></li>
        <li><a href="{{ site.url }}/terms/">Terms</a></li>
        <li><a href="{{ site.url }}/style-guide/">Style Guide</a></li>
      </ul>
    </li>
    <li><a href="{{ site.url }}/tag/">Archives by Tag</a>
      <ul>
        {% assign tags_list = site.tags | sort %}  
        {% for tag in tags_list %} 
          <li><a href="{{ site.url }}/tag/{{ tag[0] | replace:' ','-' | downcase }}/">{{ tag[0] }}</a></li>
        {% endfor %}
      </ul>
    </li>
    <li><a href="{{ site.url }}/posts/">Blog Posts</a>
      <ul>
        {% for post in site.categories.posts %}
        {% include post-list.html %}
        {% endfor %}
      </ul>
    </li>
    <li><a href="{{ site.url }}/nuggets/">PowerShell Nuggets</a>
      <ul>
        {% for post in site.categories.nuggets %}
		  {% include post-list.html %}
        {% endfor %}
      </ul>
    </li>
    <li><a href="{{ site.url }}/projects/">Projects</a>
      <ul>
        {% for post in site.categories.projects %}
        {% include post-list.html %}
        {% endfor %}
      </ul>
    </li>
  </ul><!-- /.col5 -->
</div><!-- /.sitemap -->

