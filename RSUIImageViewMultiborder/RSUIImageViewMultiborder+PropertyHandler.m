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

#import "RSUIImageViewMultiborder+PropertyHandler.h"
//#import <objc/objc-runtime.h>     //this header is only available to simulator SDK
#import <objc/runtime.h>

@implementation RSUIImageViewMultiborder (PropertyHandler)

static NSArray <NSString*>  *borderColorPropertyNames;
static NSArray <NSString*>  *borderWidthPropertyNames;

/**
 *  Get all border color properties extracted from class
 *  @runtime
 */
+(NSArray <NSString*>*)getBorderColorPropertyNames
{
    return borderColorPropertyNames;
}

/**
 *  Get all border width properties extracted from class
 *  @runtime
 */
+(NSArray <NSString*>*) getBorderWidthPropertyNames
{
    return borderWidthPropertyNames;
}

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
