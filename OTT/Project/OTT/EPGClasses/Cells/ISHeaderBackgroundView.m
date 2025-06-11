//
//  ISReservationHeaderBackgroundView.m
//  iLumio Guest
//
//  Created by Michał Zaborowski on 20.09.2014.
//  Copyright (c) 2014 inspace.io. All rights reserved.
//

#import "ISHeaderBackgroundView.h"

@implementation ISHeaderBackgroundView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor =  [UIColor colorWithRed:20.0/255.0 green:20.0/255.0 blue:20.0/255.0 alpha:1.0];

    }
    return self;
}



@end
