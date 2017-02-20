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
//#import <objc/objc-runtime.h>     //this header is only available to simulator SDK
#import <objc/runtime.h>

@implementation RSUIImageViewMultiborder

static NSArray <NSString*>  *borderColorPropertyNames;
static NSArray <NSString*>  *borderWidthPropertyNames;

@synthesize isRounded = _isRounded;


/**
 *  while the class loads, this method is fired, instead of generating 
 *  property names each time the view invalidates, pre-calculate the 
 *  property list will enhance performance.
 */
+(void)load
{
    NSArray <NSString*> *allPropertyNames = [self allPropertyNames];
    borderColorPropertyNames = [allPropertyNames filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF beginswith 'border_color'"]];
    borderWidthPropertyNames = [allPropertyNames filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF beginswith 'border_width'"]];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    /**
     *  This code segment may confuse you but here is the explanation. We
     *  set the isRounded property before the view is properly layoutted.
     *  so settings it's corner radius before-hand layout sets it wrong
     *  value. so after a layout is done we re-apply the isRounded
     *  value, so that proper corner radius is set.
     */
    self.isRounded = _isRounded;
}
    
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    //  drawing image
    [self handleImageDrawing];
    
    //  drawing border
    [self handleBorderDrawing:ctx];
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
    else
    {
        self.layer.cornerRadius = 0.0;
    }
}

#pragma mark drawing related methods
/**
 *  This method manage all image drawing related task. 
 *  It actually generate the image according to the 
 *  self.contentMode, then draw the image according to
 *  the inset created by the border.
 */
-(void)handleImageDrawing
{
    CGFloat imageInset = 0;
    for(NSString *borderWidthPropertyName in borderWidthPropertyNames)
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
}
/**
 *  This method manage all the border drawing related task.
 *  It actually set the current stroke color according to the
 *  currently drawing border, calculate the rect where the
 *  border will be drawn and then draw the border by taking the
 *  consideration of property "isRounded". An elipse is been drawn on
 *  rounded case and an rect is drawn on non-rounded case.
 */
-(void)handleBorderDrawing:(CGContextRef)ctx
{
    NSAssert(borderColorPropertyNames.count == borderWidthPropertyNames.count, @"inequal number of border-color and border-width property");
    
    CGFloat summedBorderWidth = 0, currentBorderWidth;
    for(unsigned int index = 0; index < borderWidthPropertyNames.count; index++)
    {
        UIColor *borderColor = [self valueForKey:borderColorPropertyNames[index]];
        currentBorderWidth = [[self valueForKey:borderWidthPropertyNames[index]] doubleValue];
        
        if(!currentBorderWidth) continue;//if border is equal to zero, just ignore the drawing
        
        CGContextSetStrokeColorWithColor(ctx, borderColor.CGColor);
        CGContextSetLineWidth(ctx, currentBorderWidth);
        
        CGFloat size = summedBorderWidth + currentBorderWidth /2.0;
        
        if(_isRounded)
            CGContextAddEllipseInRect(ctx, CGRectInset(self.bounds,size,size));
        else
            CGContextAddRect(ctx, CGRectInset(self.bounds,size,size));

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
            return [self handleAspectFillOrFitContentMode:contentMode forImage:image forRect:rect];
        case UIViewContentModeCenter:             // contents remain same size. positioned adjusted.
        case UIViewContentModeTop:
        case UIViewContentModeBottom:
        case UIViewContentModeLeft:
        case UIViewContentModeRight:
        case UIViewContentModeTopLeft:
        case UIViewContentModeTopRight:
        case UIViewContentModeBottomLeft:
        case UIViewContentModeBottomRight:
            return [self handleImagePlacementContentMode:contentMode forImage:image forRect:rect];
        case UIViewContentModeRedraw:              // redraw on bounds change (calls -setNeedsDisplay
        case UIViewContentModeScaleToFill:
            return image;
    }
}
/**
 *  Handle the two major content mode in a separate function.
 *  
 *  @param
 *  contentMode - supported mode is AspectFit or AspectFill.
 *  image       - image which needed to be rendered.
 *  rect        - destination rect.
 */
-(UIImage*)handleAspectFillOrFitContentMode:(UIViewContentMode)contentMode
                                   forImage:(UIImage*)image
                                    forRect:(CGRect)rect
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

/**
 *  Handle some common content mode scenarios. handled content modes are
 *  listed following. Common thing for all these modes are that, image size
 *  remains unchanged, but the position of the image is changed.
 *
 *  UIViewContentModeCenter
 *  UIViewContentModeTop
 *  UIViewContentModeBottom
 *  UIViewContentModeLeft
 *  UIViewContentModeRight
 *  UIViewContentModeTopLeft
 *  UIViewContentModeTopRight
 *  UIViewContentModeBottomLeft
 *  UIViewContentModeBottomRight
 *
 *  @param
 *  contentMode - supported mode is listed above.
 *  image       - image which needed to be rendered.
 *  rect        - destination rect.
 */
-(UIImage*)handleImagePlacementContentMode:(UIViewContentMode)contentMode
                                  forImage:(UIImage*)image
                                   forRect:(CGRect)rect
{
    CGRect imageRect = [self getImageRectForImageSize:image.size
                                          contentMode:contentMode
                                              forRect:rect];

    return [self getImage:image drawnOnRect:rect.size withImageRect:imageRect];
}

/**
 *  Calculate the image for some common content mode.
 *  This function actually acts as an helper for
 *  
 *  -(void) handleImagePlacementContentMode:(UIViewContentMode)contentMode
 *                                 forImage:(UIImage*)image
 *                                  forRect:(CGRect)rect
 *
 *  @param
 *  imageSize   - CGSize of the image
 *  contentMode - UIViewContentMode, according to which image rect will be sized
 *  rect        - CGRect, rect where the image is supposed to be drawn
 */
-(CGRect)getImageRectForImageSize:(CGSize)imageSize
                      contentMode:(UIViewContentMode)contentMode
                          forRect:(CGRect)rect
{
    CGRect imageDrawnRect = CGRectMake(0, 0, imageSize.width, imageSize.height);
    switch (contentMode) {
        case UIViewContentModeLeft:
            // center left
            // only need to modify y position of the rect to half way
            imageDrawnRect.origin.y = (CGRectGetHeight(rect) - CGRectGetHeight(imageDrawnRect)) / 2.0;
            break;
        case UIViewContentModeBottomLeft:
            //  left bottom position
            //  need to modify y in this case in full way
            imageDrawnRect.origin.y = (CGRectGetHeight(rect) - CGRectGetHeight(imageDrawnRect));
            break;
            /**
             *  only x related
             */
        case UIViewContentModeTop:
            // top center
            // only need to modify x position of the rect to half way
            imageDrawnRect.origin.x = (CGRectGetWidth(rect) - CGRectGetWidth(imageDrawnRect)) / 2.0;
            break;
        case UIViewContentModeTopRight:
            //  top right most position
            //  only need to modify x position of the rect to full way
            imageDrawnRect.origin.x = (CGRectGetWidth(rect) - CGRectGetWidth(imageDrawnRect));
            break;
            /**
             *  both x-y related changes
             */
        case UIViewContentModeCenter:
            //  center position
            //  need to modify x and y both half way
            imageDrawnRect.origin.x = (CGRectGetWidth(rect) - CGRectGetWidth(imageDrawnRect)) / 2.0;
            imageDrawnRect.origin.y = (CGRectGetHeight(rect) - CGRectGetHeight(imageDrawnRect)) / 2.0;
            break;
        case UIViewContentModeRight:
            //  center right position
            //  need to modify x and y both, but in this case
            //  modify x full way
            //  modify y half way
            imageDrawnRect.origin.x = (CGRectGetWidth(rect) - CGRectGetWidth(imageDrawnRect));
            imageDrawnRect.origin.y = (CGRectGetHeight(rect) - CGRectGetHeight(imageDrawnRect)) / 2.0;
            break;
        case UIViewContentModeBottom:
            //  center bottom position
            //  need to modify x and y both in this case
            //  modify x half way
            //  modify y full way
            imageDrawnRect.origin.x = (CGRectGetWidth(rect) - CGRectGetWidth(imageDrawnRect)) / 2.0;
            imageDrawnRect.origin.y = (CGRectGetHeight(rect) - CGRectGetHeight(imageDrawnRect));
            break;
        case UIViewContentModeBottomRight:
            //  right bottom position
            //  need to modify both x and y, both will be full way through
            imageDrawnRect.origin.x = (CGRectGetWidth(rect) - CGRectGetWidth(imageDrawnRect));
            imageDrawnRect.origin.y = (CGRectGetHeight(rect) - CGRectGetHeight(imageDrawnRect));
            break;
        default:
            break;
    }
    return imageDrawnRect;
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
+ (NSArray<NSString*> *)allPropertyNames
{
    unsigned count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    NSMutableArray<NSString*> *rv = [NSMutableArray array];
    
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
