
<img src="https://github.com/ratulSharker/Gif-Demonstration/blob/master/RSUIImageViewMultiborder/banner.png" style='color:#FF0000'>

<a href="https://codebeat.co/projects/github-com-ratulsharker-rsuiimageviewmultiborder"><img alt="codebeat badge" src="https://codebeat.co/badges/e1ce0815-765a-4e65-9365-c58a7dec7d29" /></a>
[![Build Status](https://travis-ci.org/ratulSharker/RSUIImageViewMultiborder.svg?branch=master)](https://travis-ci.org/ratulSharker/RSUIImageViewMultiborder)
[![Language](https://img.shields.io/badge/language-obj--c-orange.svg)](https://en.wikipedia.org/wiki/IOS)
[![Platform](https://img.shields.io/badge/platform-ios-green.svg)](https://en.wikipedia.org/wiki/IOS)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://opensource.org/licenses/MIT)

# Quick Demo
<img src="https://github.com/ratulSharker/Gif-Demonstration/blob/master/RSUIImageViewMultiborder/RSUIImageViewMultiborder-demo.gif" alt="Demo">


# Background
Customising ios application are quiet challenging when there is no apple provided user interface or api to do that. Showing multiple border alongside the shown image is one of that. Like following:

<img src="https://github.com/ratulSharker/Gif-Demonstration/blob/master/RSUIImageViewMultiborder/sample-border-requirement.png" alt="Sample bordererd image" height='217px' width='219px'>

To achieve that we have to put `UIImageView` inside an `UIView` as a sub-view and changing the container view's background color. Another way to achive is to subclass the `UIImageView` and implement the `drawRect:` method to draw whatever we need. But apple discourages to implement the `drawRect:`, and even they didn't executes your `drawRect:` implementation. 

Directly from the [appledoc](https://developer.apple.com/reference/uikit/uiimageview?language=objc)

>### Do not use image views for custom drawing. 
TheUIImageView class does not draw its content using the drawRect: method. Use image views only to present images. To do custom drawing involving images, subclass UIView directly and draw your image there.

So here it is, `UIView` is subclassed and the `UIImage` is drawn inside with proper content mode specified, maintaining specified number of border.

# Installation
Copy the class named [`RSUIImageViewMultiborder`](https://github.com/ratulSharker/RSUIImageViewMultiborder/tree/master/RSUIImageViewMultiborder) and two category files. In interface builder take an `UIView` and set the custom class as `RSUIImageViewMultiborder`.

`RSUIImageViewCustomBadge` will be available through cocoapod soon.

# Customizing
Adding a new border is the most easiest part. To add a new border in `RSUIImageViewCustomBadge.h` add two property of the following format

```objective-c
@property IBInspectable UIColor *border_color_xxx;
@property IBInspectable CGFloat border_width_xxx;
```

which represents a border.

Things we needed to take into account, is that, the border declaration preceedes the other border are rendered in the outer section from other border. For example

```objective-c
@property IBInspectable UIColor     *border_color_1;  //first border - the outmost border
@property IBInspectable CGFloat     border_width_1;

@property IBInspectable UIColor     *border_color_2;  //second border
@property IBInspectable CGFloat     border_width_2;

@property IBInspectable UIColor     *border_color_3;  //third border from the outmost border
@property IBInspectable CGFloat     border_width_3;

@property IBInspectable UIColor     *border_color_4;  //fourth border
@property IBInspectable CGFloat     border_width_4;
```

so find the appropriate position of the border, where to add it and feel free to delete any unnecessary border you are not using. Deleting a border requires to delete two property indicating a border.

# Properties
`RSUIImageViewMultiborder` has following properties 

|Property             |Type               |Denotes                                          |
|:--------------------|:------------------|:------------------------------------------------|
|isRounded            |BOOL               |set the corner radius to it's half of it's width |
|border_color_xxx     |UIColor            |designate the color of a border                  |
|border_width_xxx     |CGFloat            |the width of the border                          |
|image                |UIImage            |image to be rendered                             |
|contentMode          |UIViewContentMode  |actually the property contentMode is shared from UIView, which determine the render mode of the image property|


#  Features
There are several features which are not ready yet. Features completed are marked.

- [X] CI-integration.
- [X] Support rounded and non-rounded regular border.
- [X] Support IBDesignable to be customized from interface builder.
- [X] Adding a border just adding necessary properties.
- [X] Handle image drawing for all content mode.
- [ ] Available in cocoapod.
- [ ] Finding a cleaner way to add border while installed via cocoapod.
- [ ] Supporting line drawing style in interface builder (i.e dotted line, rounded dotted line etc).

# License

RSUIImageViewMultiborder is available under the MIT license. See the [LICENSE](https://github.com/ratulSharker/RSUIImageViewMultiborder/blob/master/LICENSE) file for more info.

Please feel free to file an [issue](https://github.com/ratulSharker/RSUIImageViewMultiborder/issues), on any inconsistency found or new feature needed.
