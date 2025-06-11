//
//  ISFloatingCell.m
//  INSElectronicProgramGuideLayout
//
//  Created by Michał Zaborowski on 18.12.2014.
//  Copyright (c) 2014 inspace.io. All rights reserved.
//

#import "ISFloatingCell.h"
//#import <UIColor+MLPFlatColors/UIColor+MLPFlatColors.h>

@implementation ISFloatingCell

+ (NSDateFormatter *)sharedTimeRowHeaderDateFormatter
{
    static dispatch_once_t once;
    static NSDateFormatter *_sharedTimeRowHeaderDateFormatter;
    dispatch_once(&once, ^ { _sharedTimeRowHeaderDateFormatter = [[NSDateFormatter alloc] init];
        _sharedTimeRowHeaderDateFormatter.dateFormat = @"hh:mm a";
    });
    return _sharedTimeRowHeaderDateFormatter;
}

- (void)awakeFromNib
{
    [super awakeFromNib];

//    UIColor *randomColor = [UIColor randomFlatLightColor];
    self.topBorderView.backgroundColor = [UIColor clearColor];
    self.leftBorderView.backgroundColor = [UIColor clearColor];

    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
    self.layer.shouldRasterize = YES;

    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.contentView.translatesAutoresizingMaskIntoConstraints = YES;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.backgroundColor = [UIColor clearColor];
}

- (void)setDate:(NSDate *)date setBgColor:(BOOL)status
{
    self.dateLabel.text = [[[self class] sharedTimeRowHeaderDateFormatter] stringFromDate:date];
    if (status) {
//        [self setNonPlayableBGColor];
    }
    [self setNeedsLayout];
}

- (void)setNonPlayableBGColor {
    self.contentView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.5];
}

@end
