---
layout: archive
permalink: /style-guide/
title: "Style Guide"
excerpt: "A handy collection of all the colors, typography, UI patterns, and components used."
fullwidth: true
ads: false
share: false
---


## Text Alignment

Align text blocks with the following classes.

Left aligned text `.text-left`
{: .text-left}

```markdown
Left aligned text
{: .text-left}
```

---

Center aligned text. `.text-center`
{: .text-center}

```markdown
Center aligned text.
{: .text-center}
```

---

Right aligned text. `.text-right`
{: .text-right}

```markdown
Right aligned text.
{: .text-right}
```

---

**Justified text.** `.text-justify` Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque vel eleifend odio, eu elementum purus. In hac habitasse platea dictumst. Fusce sed sapien eleifend, sollicitudin neque non, faucibus est. Proin tempus nisi eu arcu facilisis, eget venenatis eros consequat.
{: .text-justify}

```markdown
Justified text.
{: .text-justify}
```

---

No wrap text. `.text-nowrap`
{: .text-nowrap}

```markdown
No wrap text.
{: .text-nowrap}
```

## Image Alignment

Position images with the following classes.

![image-center]({{ "/assets/images/image-alignment-580x300.jpg" | absolute_url }}){: .align-center}

The image above happens to be **centered**.

```markdown
![image-center](/assets/images/filename.jpg){: .align-center}
```

---

![image-left]({{ "/assets/images/image-alignment-150x150.jpg" | absolute_url }}){: .align-left} The rest of this paragraph is filler for the sake of seeing the text wrap around the 150×150 image, which is **left aligned**. There should be plenty of room above, below, and to the right of the image. Just look at him there --- Hey guy! Way to rock that left side. I don't care what the right aligned image says, you look great. Don't let anyone else tell you differently.

```markdown
![image-left](/assets/images/filename.jpg){: .align-left}
```

---

![image-right]({{ "/assets/images/image-alignment-300x200.jpg" | absolute_url }}){: .align-right}

And now we're going to shift things to the **right align**. Again, there should be plenty of room above, below, and to the left of the image. Just look at him there --- Hey guy! Way to rock that right side. I don't care what the left aligned image says, you look great. Don't let anyone else tell you differently.

```markdown
![image-right](/assets/images/filename.jpg){: .align-right}
```

---

![full]({{ "/assets/images/image-alignment-1200x4002.jpg" | absolute_url }})
{: .full}

The image above should extend outside of the parent container on right.

```markdown
![full](/assets/images/filename.jpg)
{: .full}
```

## Buttons

Make any link standout more when applying the `.btn` class.

```html
<a href="#" class="btn">Link Text</a>
```

| Button Type   | Example | Class | Kramdown |
| ------        | ------- | ----- | ------- |
| Default       | [Text](#link){: .btn} | `.btn` | `[Text](#link){: .btn}` |
| Success       | [Text](#link){: .btn .btn--success} | `.btn .btn--success` | `[Text](#link){: .btn .btn--success}` |
| Warning       | [Text](#link){: .btn .btn--warning} | `.btn .btn--warning` | `[Text](#link){: .btn .btn--warning}` |
| Danger        | [Text](#link){: .btn .btn--danger} | `.btn .btn--danger` | `[Text](#link){: .btn .btn--danger}` |
| Info          | [Text](#link){: .btn .btn--info} | `.btn .btn--info` | `[Text](#link){: .btn .btn--info}` |
| Inverse       | [Text](#link){: .btn .btn--inverse} | `.btn .btn--inverse` | `[Text](#link){: .btn .btn--inverse}` |
| Light Outline | [Text](#link){: .btn .btn--light-outline} | `.btn .btn--light-outline` | `[Text](#link){: .btn .btn--light-outline}` |

| Button Size | Example | Class | Kramdown |
| ----------- | ------- | ----- | -------- |
| X-Large     | [X-Large Button](#){: .btn .btn--x-large} | `.btn .btn--x-large` | `[Text](#link){: .btn .btn--x-large}` |
| Large       | [Large Button](#){: .btn .btn--large} | `.btn .btn--large` | `[Text](#link){: .btn .btn--large}` |
| Default     | [Default Button](#){: .btn} | `.btn` | `[Text](#link){: .btn}` |
| Small       | [Small Button](#){: .btn .btn--small} | `.btn .btn--small` | `[Text](#link){: .btn .btn--small}` |

## Notices

Call attention to a block of text.

| Notice Type | Class              |
| ----------- | -----              |
| Default     | `.notice`          |
| Primary     | `.notice--primary` |
| Info        | `.notice--info`    |
| Warning     | `.notice--warning` |
| Success     | `.notice--success` |
| Danger      | `.notice--danger`  |

**Watch out!** This paragraph of text has been emphasized with the `{: .notice}` class.
{: .notice}

**Watch out!** This paragraph of text has been emphasized with the `{: .notice--primary}` class.
{: .notice--primary}

**Watch out!** This paragraph of text has been emphasized with the `{: .notice--info}` class.
{: .notice--info}

**Watch out!** This paragraph of text has been emphasized with the `{: .notice--warning}` class.
{: .notice--warning}

**Watch out!** This paragraph of text has been emphasized with the `{: .notice--success}` class.
{: .notice--success}

**Watch out!** This paragraph of text has been emphasized with the `{: .notice--danger}` class.
{: .notice--danger}

{% capture notice-text %}
You can also add the `.notice` class to a `<div>` element.

* Bullet point 1
* Bullet point 2
{% endcapture %}

<div class="notice--info">
  <h4>Notice Headline:</h4>
  {{ notice-text | markdownify }}
</div>

## Code blocks

{% highlight powershell linenos=table %}
<#  highlitable code with line numbers useing liquid (not ability to wrap) #>
get-help
get-command
this is the line that never ends. it goes on on on my freind, you would not belive it but it started verry small,b ut soon is was not so small at all. thisis the line that never ends...
{% endhighlight %}


```markdown
{% raw %}{% highlight powershell linenos=table %}
get-help
get-command
{% endhighlight %}{% endraw %}
```
~~~ powershell?line_numbers=true
# Basic code block (vs Code and comment friendly)
get-help
get-command
~~~

```markdown
~~~ powershell
get-help
get-command
~~~
```

    test 3