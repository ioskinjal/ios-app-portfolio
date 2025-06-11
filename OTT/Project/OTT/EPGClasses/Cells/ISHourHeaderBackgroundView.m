//
//  ISHourHeaderBackgroundView.m
//  INSElectronicProgramGuideLayout
//
//  Created by Michał Zaborowski on 05.10.2014.
//  Copyright (c) 2014 inspace.io. All rights reserved.
//

#import "ISHourHeaderBackgroundView.h"

@implementation ISHourHeaderBackgroundView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
#warning Check the colour code for each tenant
        self.backgroundColor = [UIColor colorWithRed:41.0/255.0 green:41.0/255.0 blue:41.0/255.0 alpha:1.0];
//        self.layer.shadowColor = [UIColor blackColor].CGColor;
//        self.layer.shadowOpacity = 1.0;
//        self.layer.shadowOffset = CGSizeMake(0.0, -2.0);
//        self.layer.shadowRadius = 8.0;
//        self.layer.rasterizationScale = [UIScreen mainScreen].scale;
//        self.layer.shouldRasterize = YES;
    }
    return self;
}

@end
