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

#import "RSUIImageViewMultiborder.h"

@interface RSUIImageViewMultiborder (PropertyHandler)

/**
 *  Get the total number of border count
 *  it asserts on the total declared property
 */
+ (NSUInteger)getBorderCount;

/**
 *  Get the border color of a particular border
 *  indexed via the parameter index.
 */
- (UIColor*)getBorderColorAtIndex:(NSUInteger)index;

/**
 *  Get the border width of a particular border
 *  indexed via the parameter index.
 */
- (CGFloat)getBorderWidthAtIndex:(NSUInteger)index;

@end
