---
title: "Test Page"
excerpt: "Test Form"
sitemap: false
permalink: /test.html
layout: none
slug: testform
---

# Test Page

<form method="POST" action="https://api.staticman.net/v2/entry/BladeFireLight/blog_source/master/comments">
  <!-- <input name="options[redirect]" type="hidden" value="https://localhost:4000/"> -->
  <input name="options[origin]" type="hidden" value="{{ page.url | absolute_url }}"> 
  <!-- e.g. "2016-01-02-this-is-a-post" -->
   <input name="options[slug]" type="hidden" value="{{ page.slug }}"> 
  <label><input name="fields[name]" type="text">Name</label>
  <label><input name="fields[email]" type="email">E-mail</label>
  <label><textarea name="fields[message]"></textarea>Message</label>
  
  <button type="submit">Go!</button>
</form>
