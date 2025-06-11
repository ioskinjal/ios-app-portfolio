//
//  ISFloatingOverlay.h
//  INSElectronicProgramGuideLayout
//
//  Created by Michał Zaborowski on 04.10.2014.
//  Copyright (c) 2014 inspace.io. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ISFloatingCellOverlay : UICollectionReusableView

- (void)setDate:(NSDate *)date;
@property (weak, nonatomic) IBOutlet UIImageView *bannerImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
