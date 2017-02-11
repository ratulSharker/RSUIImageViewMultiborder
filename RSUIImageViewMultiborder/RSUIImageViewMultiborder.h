//  Copyright (c) 2017 Ratul sharker
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

#import <UIKit/UIKit.h>


IB_DESIGNABLE
@interface RSUIImageViewMultiborder : UIView

/**
 *  Decide's, is the view will shaped rounded or not
 */
@property IBInspectable BOOL        isRounded;


/**
 *  Here declared two property in pair
 *  1. border_color_xxx
 *  2. border_width_xxx
 *  
 *  Each property pair represent's a border. First property represent the
 *  UIColor of the border and the second property declare the width of the 
 *  border. The border declared in first position are to be rendered in
 *  most outer border, and border declared later are to be rendered 
 *  inside the previous one.
 *
 *  To add a new border you have to do two thing right.
 *  1. find the position of the border (after which border it will be placed)
 *  2. declare two property of following format
        
        @property IBInspectable UIColor     *border_color_xxx;
        @property IBInspectable CGFloat     border_width_xxx;
 *
 *  it will eventually appear in the interface builder.
 *
 */
@property IBInspectable UIColor     *border_color_1;
@property IBInspectable CGFloat     border_width_1;

@property IBInspectable UIColor     *border_color_2;
@property IBInspectable CGFloat     border_width_2;

@property IBInspectable UIColor     *border_color_3;
@property IBInspectable CGFloat     border_width_3;

@property IBInspectable UIColor     *border_color_4;
@property IBInspectable CGFloat     border_width_4;

/**
 *  UIImage which will be rendered
 */
@property IBInspectable UIImage     *image;

@end
