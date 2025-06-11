//
//  ISReservationDayColumnHeader.h
//  iLumio Guest
//
//  Created by Michał Zaborowski on 20.09.2014.
//  Copyright (c) 2014 inspace.io. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ISSectionHeader : UICollectionReusableView
@property (nonatomic, weak) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UIImageView *channelImgView;
@property (weak, nonatomic) IBOutlet UIButton *channelBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *channelImgViewWidthConstraint;

@end
