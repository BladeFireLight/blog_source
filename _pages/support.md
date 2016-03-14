---
permalink: /support/
title: "Show Your Support"
date: 2016-03-10
modified: 2016-03-10
excerpt: "If you like the free content I provide, here are some great ways to show your support and motivate me to create more of it."
share: false
author: false
---

The tutorials, PowerShell Modules, and other articles I publish have been a true labor of love for me. If you've found any of this free content useful here's how to show your thanks and motivate me to create more of it.

{% include toc.html %}

## Spread the Word

Have a website or use social networking sites like Twitter, Facebook, Google+, Tumblr, or Pinterest? Please consider sharing any of the content found on **{{ site.title}}** or linking to <{{ site.url }}>

## Follow Me on Social Media

I typically post once or twice a day --- I'm not the type to barf out a stream of rants and retweets in quick succession. Posts are along the lines of in-process artwork, speed painting videos, web design and development tidbits, sarcastic remarks, and photographic fragments from what little life I live.

{% if site.owner.twitter %}
* [Twitter](https://twitter.com/{{ site.owner.twitter }}) {% endif %} {% if site.owner.instagram %}
* [Instagram](https://instagram.com/{{ site.owner.instagram }}/) {% endif %} {% if site.owner.tumblr %}
* [Tumblr](http://{{ site.owner.tumblr }}.tumblr.com/) {% endif %} {% if site.owner.github %}
* [GitHub](https://github.com/{{ site.owner.github }}) {% endif %} {% if site.owner.youtube %}
* [YouTube](https://www.youtube.com/user/{{ site.owner.youtube }}) {% endif %} {% if site.owner.facebook %}
* [Facebook](https://www.facebook.com/{{ site.owner.facebook }}) {% endif %} {% if site.owner.google.plus %}
* [Google+]({{ site.owner.google.plus }}) {% endif %} 
{:.fl}

{% if site.ownder.google.feedburner %}
## Subscribe to the Feeds

All of the content on Made Mistakes is made available for free via syndicated feeds[^rss].

Subscribing to the [**All Posts**](http://feeds.feedburner.com/{{ site.owner.google.feedburner }}) feed will nab you everything posted to {{ site.title}}. 
{:.fl}

[^rss]: Right click any of the feed links found on this page and paste into your feed reader of choice. My favorite is [feedly](http://feedly.com), which syncs your subscriptions across all browsers and mobile devices.

<a href="http://cloud.feedly.com/#subscription%2Ffeed%2Fhttp%3A%2F%2Ffeeds.feedburner.com%2{{ site.owner.google.feedburner }}"  target="blank"><img id="feedlyFollow" src="http://s3.feedly.com/img/follows/feedly-follow-rectangle-flat-medium_2x.png" alt="follow on feedly" width="71" height="28"></a> 
{% endif %}

{% if site.owner.paypal-me or site.owner.cash-me or site.owner.coinebase %}
## Send a Donation

I include banner ads on the site to help offset the costs associated with keeping this site up, but we all know no one clicks on that crap. If you'd like to send a donation my way so I can continue to provide free content and themes, hit one of the buttons below. 

<p markdown="0">
  {% if site.owner.paypal-me %}
  <a href="https://www.paypal.me/{{ site.owner.paypal-me }}" onclick="ga('send', 'event', 'link', 'click', 'Send PayPal');" class="btn">{% icon paypal %} Send PayPal Money</a>
  {% endif %}  
  {% if site.owner.cash-me %}
  <a href="https://cash.me/${{ site.owner.cash-me }}" onclick="ga('send', 'event', 'link', 'click', 'Send Square Cash');" class="btn">Send Square Cash</a>
  {% endif %}  
  {% if site.owner.coinebase %}
  <a href="https://coinbase.com/checkouts/0a71043d672fbedccb0ce98e139a8a17" onclick="ga('send', 'event', 'link', 'click', 'Send Bitcoins');" class="btn">Send Bitcoins</a>
  {% endif %}  
</p>
{% endif %}

 {% if site.owner.amazon.referral %}
## Buy Something

If you shop on [Amazon.com]({{site.owner.amazon.referral}}), using my referral link below will give me a small commission if you end up buying something and will cost you nothing. {% if site.owner.amazon.wishlist} I also maintain an Amazon Wish List if you are feeling extra generous. {% icon wink %} {% endif %}

<p markdown="0">
  <a href="{{site.owner.amazon.referral}}" onclick="ga('send', 'event', 'link', 'click', 'Shop Amazon');" class="btn">{% icon amazon %} Shop Amazon</a>
  {% if site.owner.amazon.wishlist} 
  <a href="http://amzn.com/w/1K58RT2NS0SDP" onclick="ga('send', 'event', 'link', 'click', 'Amazon Wish List');" class="btn">{% icon amazon %} Amazon Wish List</a>
  {% endif %}
  </p>
{% endif %}
