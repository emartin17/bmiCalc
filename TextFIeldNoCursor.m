//
//  TextFIeldNoCursor.m
//  bmiCalc
//
//  Created by Eric Martin on 7/7/14.
//  Copyright (c) 2014 Martin Developments. All rights reserved.
//

#import "TextFIeldNoCursor.h"

@implementation TextFIeldNoCursor

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (CGRect)caretRectForPosition:(UITextPosition *)position
{
    return CGRectZero;
}

@end
