# [PowerShell Journey](http://blog.bladefirelight.com) Source Code

This is the source code of PowerShell Journey, a personal blog and portfolio built with [Jekyll](http://jekyllrb.com) and a starter from Made Mistakes.

#### SVG Icons

To easily add inline SVG icons to a post or page use the following Liquid tag.

```
{% icon [name] %}
```

`{% icon smile %}` will output `<svg class="icon"><use xmlns:xlink="http://www.w3.org/1999/xlink" xlink:href="#icon-smile"></use></svg>`

SVG assets are optimized and smashed together into `_includes/svg-icons.svg` and can be referenced by name (see table below).

To update or add new assets:

1. Place appropriately named `.svg` files into the `_svg` folder.
2. Run `grunt images` to optimize and copy to `/svg/` (may need to clean out folder when removing SVGs).
3. Run `grunt svg` to squash all SVGs into `_includes/svg-icons.svg`.

| Name                   | Description            | Example                                         |
| ---------------------- | ---------------------- | ------------------------------------------------|
| **amazon**             | Amazon logo            | ![Amazon](http://i.imgur.com/DLvnqFq.png)       |
| **comments**           | chat bubble            | ![comments](http://i.imgur.com/vMK8dtw.png)     |
| **deal-with-it**       | sunglasses face        | ![deal with it](http://i.imgur.com/C67DMje.png) |
| **facebook**           | Facebook square logo   | ![Facebook](http://i.imgur.com/xUlOyEl.png)     |
| **paypal**             | PayPal logo            | ![PayPal](http://i.imgur.com/AaSzVUh.png)       |
| **smile**              | smiley face            | ![smiley](http://i.imgur.com/Z0P08qm.png)       |
| **twitter**            | Twitter logo           | ![Twitter](http://i.imgur.com/mRmVsDI.png)      |
| **wink**               | wink face              | ![wink](http://i.imgur.com/Z9V5X5r.png)         |
