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

#import "RSCotentModeHandler.h"

@implementation RSCotentModeHandler


/**
 *  Get an resized image according to the content mode in a given rect
 *
 *  @param
 *      image       -   which is needed to be resized according to content mode
 *      contentMode -   expected content mode for the image
 *      rect        -   designated rectangle for the image to be rendered
 */
+(UIImage*)getImageForUIImage:(UIImage*)image
                  contentMode:(UIViewContentMode)contentMode
                      forRect:(CGRect)rect
{
    switch (contentMode) {
            
            
        case UIViewContentModeScaleAspectFill : case UIViewContentModeScaleAspectFit:
            // contents scaled to fit with fixed aspect. remainder is transparent
            return [self handleAspectFillOrFitContentMode:contentMode forImage:image forRect:rect];
            
            //all center modes
        case UIViewContentModeCenter : case UIViewContentModeTop: case UIViewContentModeBottom:
            return [self handleAllCenterContentMode:contentMode forImage:image forRect:rect];
            
            //all left modes
        case UIViewContentModeLeft: case UIViewContentModeTopLeft: case UIViewContentModeBottomLeft:
            return [self handleAllLeftContentMode:contentMode forImage:image forRect:rect];
        
            //all right modes
        case UIViewContentModeRight: case UIViewContentModeTopRight: case UIViewContentModeBottomRight:
            return [self handleAllRightContentMode:contentMode forImage:image forRect:rect];
            
            //unchanged
        case UIViewContentModeRedraw: case UIViewContentModeScaleToFill:
            return image;
    }
}


#pragma mark private image content mode maintainer method
/**
 *  Handle the two major content mode in a separate function.
 *
 *  @param
 *      contentMode - supported mode is AspectFit or AspectFill.
 *      image       - image which needed to be rendered.
 *      rect        - destination rect.
 */
+(UIImage*)handleAspectFillOrFitContentMode:(UIViewContentMode)contentMode
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
 *  Handle all left type content modes like following
 *  - UIViewContentModeTopLeft
 *  - UIViewContentModeLeft
 *  - UIViewContentModeBottomLeft
 *
 *  @param
 *      contentMode -   specified content mode among the listed
 *      image       -   image which is about to be resized
 *      rect        -   container rect, where the image will be rendered
 */
+(UIImage*)handleAllLeftContentMode:(UIViewContentMode)contentMode
                           forImage:(UIImage*)image
                            forRect:(CGRect)rect
{
    CGRect imageDrawnRect = CGRectMake(0, 0, image.size.width, image.size.height);
    CGFloat fullHeight = (CGRectGetHeight(rect) - CGRectGetHeight(imageDrawnRect));
    switch (contentMode) {
        case UIViewContentModeLeft:
            // center left
            // only need to modify y position of the rect to half way
            imageDrawnRect.origin.y = fullHeight / 2.0;
            break;
        case UIViewContentModeBottomLeft:
            //  left bottom position
            //  need to modify y in this case in full way
            imageDrawnRect.origin.y = fullHeight;
            break;
//        case UIViewContentModeTopLeft:
//            //nothing to do
//            break;
        default:
            break;
    }
    
    return [self getImage:image drawnOnRect:rect.size withImageRect:imageDrawnRect];
}

/**
 *  Handle all center type content modes like following
 *  - UIViewContentModeTop
 *  - UIViewContentModeCenter
 *  - UIViewContentModeBottom
 *
 *  @param
 *      contentMode -   specified content mode among the listed
 *      image       -   image which is about to be resized
 *      rect        -   container rect, where the image will be rendered
 */
+(UIImage*)handleAllCenterContentMode:(UIViewContentMode)contentMode
                             forImage:(UIImage*)image
                              forRect:(CGRect)rect
{
    CGRect imageDrawnRect = CGRectMake(0, 0, image.size.width, image.size.height);
    CGFloat fullWidth   = (CGRectGetWidth(rect) - CGRectGetWidth(imageDrawnRect)),
            fullHeight  = (CGRectGetHeight(rect) - CGRectGetHeight(imageDrawnRect));
    switch (contentMode) {
        case UIViewContentModeTop:
            // top center
            // only need to modify x position of the rect to half way
            imageDrawnRect.origin.x = fullWidth / 2.0;
            break;
        case UIViewContentModeCenter:
            //  center position
            //  need to modify x and y both half way
            imageDrawnRect.origin.x = fullWidth / 2.0;
            imageDrawnRect.origin.y = fullHeight / 2.0;
            break;
        case UIViewContentModeBottom:
            //  center bottom position
            //  need to modify x and y both in this case
            //  modify x half way
            //  modify y full way
            imageDrawnRect.origin.x = fullWidth / 2.0;
            imageDrawnRect.origin.y = fullHeight;
            break;
        default:
            break;
    }
    
    return [self getImage:image drawnOnRect:rect.size withImageRect:imageDrawnRect];
}

/**
 *  Handle all right type content modes like following
 *  - UIViewContentModeTopRight
 *  - UIViewContentModeRight
 *  - UIViewContentModeBottomRight
 *
 *  @param
 *      contentMode -   specified content mode among the listed
 *      image       -   image which is about to be resized
 *      rect        -   container rect, where the image will be rendered
 */
+(UIImage*)handleAllRightContentMode:(UIViewContentMode)contentMode
                            forImage:(UIImage*)image
                             forRect:(CGRect)rect
{
    CGRect imageDrawnRect = CGRectMake(0, 0, image.size.width, image.size.height);
    CGFloat fullWidth   = (CGRectGetWidth(rect) - CGRectGetWidth(imageDrawnRect)),
            fullHeight  = (CGRectGetHeight(rect) - CGRectGetHeight(imageDrawnRect));
    switch (contentMode) {
        case UIViewContentModeTopRight:
            //  top right most position
            //  only need to modify x position of the rect to full way
            imageDrawnRect.origin.x = fullWidth;
            break;
        case UIViewContentModeRight:
            //  center right position
            //  need to modify x and y both, but in this case
            //  modify x full way
            //  modify y half way
            imageDrawnRect.origin.x = fullWidth;
            imageDrawnRect.origin.y = fullHeight / 2.0;
            break;
        case UIViewContentModeBottomRight:
            //  right bottom position
            //  need to modify both x and y, both will be full way through
            imageDrawnRect.origin.x = fullWidth;
            imageDrawnRect.origin.y = fullHeight;
            break;
        default:
            break;
    }
    return [self getImage:image drawnOnRect:rect.size withImageRect:imageDrawnRect];
}

/**
 *  Get an image drawn with a given canvas size and given image size
 *
 *  @param
 *      image       -   which will be resized
 *      canvasSize  -   whole size of the canvas
 *      imageRect   -   Rect of the image which define both size of the image and the position in the canvas
 */
+(UIImage*)getImage:(UIImage*)image
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

@end
