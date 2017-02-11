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
#import <objc/objc-runtime.h>

@implementation RSUIImageViewMultiborder
{
    
}

@synthesize isRounded = _isRounded;


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    NSArray <NSString*> *allPropertyNames = [self allPropertyNames];
    NSArray <NSString*> *borderColorProperyNames = [allPropertyNames filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF beginswith 'border_color'"]];
    NSArray <NSString*> *borderWidthProperyNames = [allPropertyNames filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF beginswith 'border_width'"]];
    CGFloat imageInset = 0;
    for(NSString *borderWidthPropertyName in borderWidthProperyNames)
    {
        imageInset += [[self valueForKey:borderWidthPropertyName] doubleValue];
    }
    
    //
    //  get image based on contentMode
    //
    CGRect imageRect = CGRectInset(self.bounds,
                                   imageInset,
                                   imageInset);
    
    
    UIImage *resizedImage = [self getCGImageForUIImage:self.image
                                           contentMode:self.contentMode
                                             forRect:CGRectMake(0,
                                                                0,
                                                                CGRectGetWidth(imageRect),
                                                                CGRectGetHeight(imageRect))];
    [resizedImage drawInRect:imageRect];
    
    UIColor *borderColor;
    CGFloat summedBorderWidth = 0, currentBorderWidth;
    if(borderColorProperyNames.count == borderWidthProperyNames.count)
    {
        for(unsigned int index = 0; index < borderWidthProperyNames.count; index++)
        {
            borderColor = [self valueForKey:borderColorProperyNames[index]];
            currentBorderWidth = [[self valueForKey:borderWidthProperyNames[index]] doubleValue];
            CGContextSetStrokeColorWithColor(ctx, borderColor.CGColor);
            CGContextSetLineWidth(ctx, currentBorderWidth);
            
            NSLog(@"summed border width %f", summedBorderWidth);
            
            if(_isRounded)
            {
                CGContextAddEllipseInRect(ctx, CGRectInset(self.bounds,
                                                           summedBorderWidth + currentBorderWidth /2.0,
                                                           summedBorderWidth + currentBorderWidth /2.0));
            }
            else
            {
                CGContextAddRect(ctx, CGRectInset(self.bounds,
                                                  summedBorderWidth + currentBorderWidth /2.0,
                                                  summedBorderWidth + currentBorderWidth /2.0));
            }
            
            //
            //  upcoming feature
            //
//            CGFloat ra[] = {2 , 2};
//            CGContextSetLineDash(ctx, 0, ra, 2);
//            CGContextSetLineCap(ctx, kCGLineCapRound);
            
            summedBorderWidth += currentBorderWidth;
            
            CGContextStrokePath(ctx);
        }
    }
}

#pragma mark setMethod
-(BOOL)isRounded
{
    return self.isRounded;
}
-(void)setIsRounded:(BOOL)isRounded
{
    _isRounded = isRounded;
    if(_isRounded)
    {
        self.layer.cornerRadius = CGRectGetMidX(self.bounds);
        self.clipsToBounds = YES;
    }
}

#pragma mark private image content mode maintainer method
/**
 *  Get an resized image according to the content mode in a given rect
 *
 *  @param
 *      image       (which is needed to be resized according to content mode)
 *      contentMode (expected content mode for the image)
 *      rect        (designated rectangle for the image to be rendered)
 */
-(UIImage*)getCGImageForUIImage:(UIImage*)image
                      contentMode:(UIViewContentMode)contentMode
                          forRect:(CGRect)rect
{
    switch (contentMode) {
        
        case UIViewContentModeScaleAspectFill:
        case UIViewContentModeScaleAspectFit:
            // contents scaled to fit with fixed aspect. remainder is transparent
        {
            CGFloat heightRatio = image.size.height / CGRectGetHeight(rect);
            CGFloat widthRatio = image.size.width / CGRectGetWidth(rect);
            
            
            CGFloat maxRatio = (contentMode == UIViewContentModeScaleAspectFit) ?
            MAX(heightRatio, widthRatio) : MIN(heightRatio, widthRatio);
            
            
            CGRect resultedImageRect = CGRectMake(0,
                                                  0,
                                                  image.size.width / maxRatio,
                                                  image.size.height / maxRatio);
            
            resultedImageRect = CGRectOffset(resultedImageRect,
                                             CGRectGetMidX(rect) - CGRectGetMidX(resultedImageRect),
                                             CGRectGetMidY(rect) - CGRectGetMidY(resultedImageRect));
            
            return [self getImage:image
                      drawnOnRect:rect.size
                    withImageRect:resultedImageRect];
        }
            break;
        case UIViewContentModeRedraw:              // redraw on bounds change (calls -setNeedsDisplay)
        case UIViewContentModeCenter:             // contents remain same size. positioned adjusted.
        case UIViewContentModeTop:
        case UIViewContentModeBottom:
        case UIViewContentModeLeft:
        case UIViewContentModeRight:
        case UIViewContentModeTopLeft:
        case UIViewContentModeTopRight:
        case UIViewContentModeBottomLeft:
        case UIViewContentModeBottomRight:
        {
            NSLog(@"not yet supported -- returning UIViewContentModeScaleToFill");
        }
        case UIViewContentModeScaleToFill:
        {
            return image;
        }
            break;
            
        default:
            break;
    }
    return nil;
}

/**
 *  Get an image drawn with a given canvas size and given image size
 *  
 *  @param
 *      image         (which will be resized)
 *      canvasSize    (whole size of the canvas)
 *      imageRect     (Rect of the image which define both size of the image and the position in the canvas)
 */
-(UIImage*)getImage:(UIImage*)image
        drawnOnRect:(CGSize)canvasSize
      withImageRect:(CGRect)imageRect
{
    //UIGraphicsBeginImageContext(rect.size);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(canvasSize, NO, 0.0);
    [image drawInRect:imageRect];
    
    UIImage *resultedImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();;
    
    return resultedImage;
}

/**
 *  Get the list of all properties of this class
 */
- (NSArray<NSString*> *)allPropertyNames
{
    unsigned count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    
    NSMutableArray *rv = [NSMutableArray array];
    
    unsigned i;
    for (i = 0; i < count; i++)
    {
        objc_property_t property = properties[i];
        NSString *name = [NSString stringWithUTF8String:property_getName(property)];
        [rv addObject:name];
    }
    
    free(properties);
    
    return [NSArray arrayWithArray:rv];
}
@end
