// Copyright 2014 Google Inc. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#import "CastInstructionsViewController.h"
#import "ChromecastDeviceController.h"
#import "TransitionDelegate.h"

static void (^displayFinishedBlock)();

static NSString * const kCastInstructionsViewController = @"castInstructionsViewController";
NSString *const kHasSeenChromecastOverlay = @"hasSeenChromecastOverlay";
@interface CastInstructionsViewController()

@property(nonatomic, strong)  UIImageView *focusImageView;
@property(nonatomic, strong)  UILabel *messageLabel;
@property(nonatomic, strong)  UIButton *okButton;
@property(nonatomic, assign)  CGPoint focusPoint;
@property(nonatomic, assign)  CGPoint focusPointInLandscape;
@property(nonatomic, assign)  BOOL isCustomHelper;
@end

@implementation CastInstructionsViewController

NSString *const kHasSeenTrendingLiveOverlay = @"hasSeenTrendingLiveOverlay";
NSString *const kHasSeenCatchupTVOverlay = @"hasSeenCatchupTVOverlay";
NSString *const kHasSeenStartoverOverlay = @"hasSeenStartoverOverlay";
NSString *const kHasSeenvideoQualityOverlay = @"hasSeenvideoQualityOverlay";
NSString *const kHasSeenScrubberOverlay = @"hasSeenScrubberOverlay";
static bool isVisible;

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        self.modalPresentationStyle = UIModalPresentationOverFullScreen;
    }
    return self;
}

+ (BOOL)hasSeenInstructions {
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  return [defaults boolForKey:kHasSeenChromecastOverlay];
}

+ (void)showIfFirstTimeOverViewController:(UIViewController *)viewController {
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

  // Only show it if we haven't seen it before
  if (![self hasSeenInstructions]) {
      
    CastInstructionsViewController *cvc = [[ChromecastDeviceController sharedInstance].storyboard
        instantiateViewControllerWithIdentifier:kCastInstructionsViewController];
      [cvc.focusImageView setHidden:YES];
      cvc.isCustomHelper = NO;
      [defaults setBool:true forKey:kHasSeenChromecastOverlay];
      [defaults synchronize];
    [viewController presentViewController:cvc animated:YES completion:^() {
      // once viewDidAppear is successfully called, mark this preference as viewed
        isVisible = YES;
    }];
  }
}

+(void)showHelperOverViewController:(UIViewController *)viewController atFocusPoint:(CGPoint)focusPoint focuspointInLandscape:(CGPoint)point withMessage:(NSString *)message didDismiss:(void (^)())blockName{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
//    if (!hasSeenHelperScreen ) {
//        if(![self hasSeenInstructions] && [ChromecastDeviceController sharedInstance].deviceScanner.devices.count > 0){
//            return;
//        }
            
            
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
           
//            CastInstructionsViewController *cvc = [[ChromecastDeviceController sharedInstance].storyboard instantiateViewControllerWithIdentifier:kCastInstructionsViewController];
            CastInstructionsViewController *cvc = [[CastInstructionsViewController alloc] init];
            
            TransitionDelegate *transitionController = [[TransitionDelegate alloc] init];
            [cvc setTransitioningDelegate:transitionController];
            cvc.modalPresentationStyle= UIModalPresentationCustom;
            [cvc.chromecastOkButton setHidden:YES];
            
            cvc.focusPoint = focusPoint;
            cvc.focusPointInLandscape = point;
            cvc.isCustomHelper = YES;
            cvc.overlayView.hidden = YES;
            
            [cvc.messageLabel setText:message];
            cvc.view.opaque = NO;
            cvc.view.backgroundColor = [UIColor clearColor];
            
            
            displayFinishedBlock = blockName;
            [viewController.view.window.rootViewController presentViewController:cvc animated:YES  completion:^() {
                isVisible = YES;
//                [defaults setBool:true forKey:key];
                [defaults synchronize];
            }];
        });
//    }
//    else{
//        if (displayFinishedBlock) {
//            displayFinishedBlock();
//        }
//        // YuppLog(@"Helper Seen already for key : %@",key);
//    }
}
-(UIImageView *)focusImageView{
    if (!_focusImageView) {
        UIImage *focusImage = [UIImage imageNamed:@"cling" ];
        _focusImageView = [[UIImageView alloc] initWithFrame:CGRectMake(208, -10, focusImage.size.width, focusImage.size.height)];
        [_focusImageView setImage:focusImage];
        [self.view addSubview:_focusImageView];
    }
    return _focusImageView;
}

-(UILabel *)messageLabel{
    if (!_messageLabel) {
        _messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(208, 200, self.view.frame.size.width - 40,300)];
        _messageLabel.center = self.view.center;
        _messageLabel.numberOfLines = 0;
        [_messageLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:25] ];
        [_messageLabel setTextColor:[UIColor whiteColor]];
        _messageLabel.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_messageLabel];
    }
    return _messageLabel;
}
-(UIButton *)okButton{
    if (!_okButton) {
        _okButton = [UIButton buttonWithType:UIButtonTypeCustom];
        CGRect totoalFrame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        [_okButton setFrame:CGRectMake(totoalFrame.size.width - 100, totoalFrame.size.height - 70, 80, 40)];
        [_okButton setTitle:@"Ok" forState:UIControlStateNormal];
        [_okButton setBackgroundColor:[UIColor redColor]];
        [_okButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_okButton addTarget:self action:@selector(dismissOverlay:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_okButton];
    }
    return _okButton;
}
- (void)viewDidLoad {
    [super viewDidLoad];
//    YuppLog(@"%s",__func__);
    self.title = @"Cast Instructions";
//    [NSString postScreen:self.title];
//    [NSString postCrashLytics:NSStringFromClass([self class])];
}

-(IBAction)dismissOverlay:(id)sender {
    isVisible = NO;
    [self setTransitioningDelegate:nil];
    
    if (displayFinishedBlock) {
        displayFinishedBlock();
    }
    
    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self dismissViewControllerAnimated:NO completion:nil];
}


-(void)focusAtPoint:(CGPoint )point{
    
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithRoundedRect:self.view.bounds cornerRadius:0];
    int innerRadius = 90;
    
    
    
    CGPoint innerPoint = CGPointMake(point.x - (innerRadius/2), point.y - (innerRadius/2));
    [self drawCircleWithRadius:innerRadius frame:CGRectMake(innerPoint.x, innerPoint.y, innerRadius, innerRadius) inPath:circlePath];
    
    CAShapeLayer *fillLayer = [CAShapeLayer layer];
    fillLayer.path = circlePath.CGPath;
    fillLayer.fillRule = kCAFillRuleEvenOdd;
    fillLayer.fillColor = [UIColor blackColor].CGColor;
    fillLayer.opacity = 0.8;
    fillLayer.name = @"fillLayer";
    [self.view.layer addSublayer:fillLayer];
    
    
    [self.view bringSubviewToFront:self.messageLabel];
    [self.view bringSubviewToFront:self.okButton];
    [self.view bringSubviewToFront:self.focusImageView];
    
    self.focusImageView.center = point;
    [self.chromeCastFocusImageView setHidden:YES];
    [self.airplayNavigationBar setHidden:YES];
    [self.airplayMessageLabel setHidden:YES];
    [self.messageLabel sizeToFit];
    [self.chromecastOkButton setHidden:YES];
    [self.grayLayoutView setBackgroundColor:[UIColor clearColor]];
    [self.grayLayoutView setAlpha:1];
    
    CGRect messageLabelFrame = self.messageLabel.frame;
    CGPoint screenCenter = CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2);
    if (point.y > screenCenter.y) {
        //display label above focusImage
        messageLabelFrame.origin.y = point.y - (self.focusImageView.frame.size.height/2) - self.messageLabel.frame.size.height - 10;
    }
    else{
        messageLabelFrame.origin.y = point.y + (self.focusImageView.frame.size.height/2) + 10;
        
    }
    [self.messageLabel setFrame:messageLabelFrame];
}
- (void) viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.view layoutIfNeeded];
    if (self.isCustomHelper) {
        
        //Delete previous layers
        CALayer *fillLayer, *circleLayer;
        for (CALayer *layer in self.view.layer.sublayers) {
            if (!fillLayer) {
                if ([layer.name isEqualToString:@"fillLayer"]) {
                    fillLayer = layer;
                }
            }
            if (!circleLayer) {
                if ([layer.name isEqualToString:@"circleLayer"]) {
                    circleLayer = layer;
                }
            }
            if ((fillLayer != nil) & (circleLayer != nil)) {
                break;
            }
        }
        if (fillLayer){
            [fillLayer removeFromSuperlayer];
        }
        if (circleLayer){
            [circleLayer removeFromSuperlayer];
        }
        
        
        _okButton = nil;
        if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))
        {
            [self focusAtPoint:self.focusPointInLandscape];
        }
        else{
            [self focusAtPoint:self.focusPoint];
        }
    }
}
-(void)drawCircleWithRadius:(int)radius frame:(CGRect)frame inPath:(UIBezierPath *)path{
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithRoundedRect:frame cornerRadius:radius];
    [path appendPath:circlePath];
    [path setUsesEvenOddFillRule:YES];
    
    
    CAShapeLayer *circleLayer = [[CAShapeLayer alloc] init];
    [circleLayer setPath:circlePath.CGPath];
    [circleLayer setFillColor:[UIColor clearColor].CGColor];
    [circleLayer setName:@"circleLayer"];
    [circleLayer setLineWidth:2];
    [self.view.layer addSublayer:circleLayer];
    
}

+(BOOL)hasSeenCatchupOverLay{
    return [self boolValueForKey:kHasSeenCatchupTVOverlay];
}
+(BOOL)hasSeenTrendingLiveOverLay{
    return [self boolValueForKey:kHasSeenTrendingLiveOverlay];
}
+(BOOL)hasSeenStaroverOverLay{
    return [self boolValueForKey:kHasSeenStartoverOverlay];
}
+(BOOL)hasSeenVideoQualityOverLay{
    return [self boolValueForKey:kHasSeenvideoQualityOverlay];
}
+(BOOL)hasSeenScrubberOverLay{
    return [self boolValueForKey:kHasSeenScrubberOverlay];
}

+(BOOL)boolValueForKey:(NSString *)key{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults boolForKey:key];
}

+(BOOL)isHelperVisible{
    return isVisible;
}

+ (CGSize)screenSize {
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    if ((NSFoundationVersionNumber <= NSFoundationVersionNumber_iOS_7_1) && UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
        screenSize = CGSizeMake(screenSize.height, screenSize.width);
    }
    return screenSize;
}

@end

