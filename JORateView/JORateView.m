//
//  JORateView.m
//  liulianclient
//
//  Created by Joost💟Blair on 5/21/13.
//  Copyright (c) 2013 joojoo. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "JORateView.h"
@interface JORateView(/*Private Methods*/)
@property (nonatomic) CGSize margin;
@property (nonatomic) CGSize starSize;

@end
#pragma mark
@implementation JORateView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _starCount =5;
        _margin = CGSizeMake(3, 0);
        _starSize = CGSizeMake((self.bounds.size.width-_margin.width*4)/_starCount, 0);
        _starSize.height = _starSize.width;
        _margin.height = (self.bounds.size.height -_starSize.height)/2.0f;
        _emptyStarImage = [UIImage imageNamed:@"StarEmpty"];
        _fullStarImage = [UIImage imageNamed:@"StarFull"];
        _rating =0;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGLayerRef fullStarLayer = CGLayerCreateWithContext (ctx, _starSize, NULL);
    CGContextRef fctx = CGLayerGetContext(fullStarLayer);
    CGContextDrawImage(fctx, CGRectMake(0, 0, _starSize.width, _starSize.height), _fullStarImage.CGImage);
    CGLayerRef emptyStarLayer = CGLayerCreateWithContext(ctx, _starSize, NULL);
    CGContextRef ectx = CGLayerGetContext(emptyStarLayer);
    CGContextDrawImage(ectx, CGRectMake(0, 0, _starSize.width, _starSize.height), _emptyStarImage.CGImage);
    [[UIColor clearColor] setFill];
    CGContextFillRect(ctx, rect);
    CGRect starRct=CGRectMake(0, _margin.height, _starSize.width, _starSize.height);
    for (int i =0; i<_starCount; ++i)
    {
        if (i+1<=_rating)
        {
            CGContextDrawLayerInRect(ctx, starRct, fullStarLayer);
        }else
        {
            CGContextDrawLayerInRect(ctx, starRct, emptyStarLayer);
        }
        starRct.origin.x += _starSize.width+_margin.width;
    }
    
    //if there is a half star,it's time to draw it.
    float floor = floorf(_rating);
    float deltf = _rating - floor;
    
    if (deltf >0.01)
    {
        starRct.origin.x = floor * (_starSize.width+_margin.width);

        CGContextClipToRect(ctx,CGRectMake(starRct.origin.x, 0, _starSize.width*deltf, _starSize.height));
        CGContextDrawLayerInRect(ctx, starRct, fullStarLayer);
    }
    
}
- (void)setRating:(float)rating
{
    float t = rating <_starCount ? rating: _starCount-1;
    if (_rating != t )
    {
        _rating = t;
        [self setNeedsDisplay];
    }
}

@end
