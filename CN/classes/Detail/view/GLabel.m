//
//  GLabel.m
//  CN
//
//  Created by AlfieL on 14-6-3.
//  Copyright (c) 2014年 cubeTC. All rights reserved.
//

#import "GLabel.h"

@implementation GLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}


- (void)drawTextInRect:(CGRect)rect
{
    if (self.characterSpacing)
    {
        // Drawing code
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGFloat size = self.font.pointSize;
        
        CGContextSelectFont (context, [self.font.fontName UTF8String], size, kCGEncodingMacRoman);
        CGContextSetCharacterSpacing (context, self.characterSpacing);
        CGContextSetTextDrawingMode (context, kCGTextFill);
        
        // Rotate text to not be upside down
        CGAffineTransform xform = CGAffineTransformMake(1.0, 0.0, 0.0, -1.0, 0.0, 0.0);
        CGContextSetTextMatrix(context, xform);
        const char *cStr = [self.text UTF8String];
        CGContextShowTextAtPoint (context, rect.origin.x, rect.origin.y + size, cStr, strlen(cStr));
    }
    else
    {
        // no character spacing provided so do normal drawing
        [super drawTextInRect:rect];
    }
}
@end
