//
//  JElasticPullToRefreshLoadingViewCircle.m
//
//  Created by mifanJ on 16/4/6.
//  Copyright © 2016年 mifanJ. All rights reserved.
//

#import "JElasticPullToRefreshLoadingViewCircle.h"

static NSString *const RotationAnimation = @"RotationAnimation";

@interface JElasticPullToRefreshLoadingViewCircle ()

@property (strong, nonatomic) CAShapeLayer *shapeLayer;
@property (assign, nonatomic) CATransform3D identityTransform;

@property (strong, nonatomic)  UIImageView *grayHead;
@property (strong, nonatomic)  UIImageView *greenHead;
@property (strong, nonatomic)  CAShapeLayer *maskLayerUp;

@end

@implementation JElasticPullToRefreshLoadingViewCircle
@synthesize grayHead;
@synthesize greenHead;

//- (CAShapeLayer *)shapeLayer {
//    if (!_shapeLayer) {
//        _shapeLayer = [[CAShapeLayer alloc] init];
//    }
//    return _shapeLayer;
//}

//- (CATransform3D)identityTransform {
//    CATransform3D transform = CATransform3DIdentity;
//    transform.m34 = 1.0 / -500;
//    _identityTransform = CATransform3DRotate(transform, (-90.0 * M_PI / 180.0), 0, 0, 1.0);
//
//    return _identityTransform;
//}

- (instancetype)init {
    self = [super initWithFrame:CGRectZero];

    if (self) {
        
        grayHead = [[UIImageView alloc] initWithFrame:CGRectMake(-15, 2, 30, 20)];
        [self addSubview:grayHead];
        grayHead.image = [UIImage imageNamed:@"normal_logo1"];
        
        greenHead = [[UIImageView alloc] initWithFrame:CGRectMake(-15, 2, 30, 20)];
        [self addSubview:greenHead];
        greenHead.image = [UIImage imageNamed:@"select_logo1"];
        
        self.greenHead.layer.mask = [self greenHeadMaskLayer];
        
//        self.shapeLayer.lineWidth = 1.0;
//        self.shapeLayer.fillColor = [[UIColor clearColor] CGColor];
//        self.shapeLayer.strokeColor = [[self tintColor] CGColor];
//        self.shapeLayer.actions = @{@"strokeEnd":[NSNull null], @"transform":[NSNull null]};
//        self.shapeLayer.anchorPoint = CGPointMake(0.5, 0.5);
//        [self.layer addSublayer:self.shapeLayer];
    }

    return self;
}

- (CALayer *)greenHeadMaskLayer
{
    CALayer *mask = [CALayer layer];
    mask.frame = self.greenHead.bounds;
    
    self.maskLayerUp = [CAShapeLayer layer];
    self.maskLayerUp.bounds = CGRectMake(0, 0, 30.0f, 20.0f);
    
    self.maskLayerUp.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 30, 20) cornerRadius:0].CGPath;
    self.maskLayerUp.opacity = 0.8f;
    self.maskLayerUp.position = CGPointMake(15.0f, 10.0f);
    [mask addSublayer:self.maskLayerUp];
    
    return mask;
}

- (void)setPullProgress:(CGFloat)progress {
    [super setPullProgress:progress];

//    self.shapeLayer.strokeEnd = MIN(0.9 * progress, 0.9);
//    if (progress > 1.0) {
//        CGFloat degress = ((progress - 1.0) * 200.0);
//        self.shapeLayer.transform = CATransform3DRotate(self.identityTransform, (degress * M_PI / 180.0) , 0, 0, 1.0);
//    } else {
//        self.shapeLayer.transform = self.identityTransform;
//    }
    
    self.maskLayerUp.strokeEnd = MIN(progress, 1);
    if (progress > 1.0) {
//        CGFloat degress = ((progress - 1.0) * 200.0);
//        self.maskLayerUp.transform = CATransform3DRotate(self.identityTransform, (degress * M_PI / 180.0) , 0, 0, 1.0);
    } else {
//        self.maskLayerUp.transform = self.identityTransform;
//        self.maskLayerUp.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 30, 20) cornerRadius:0].CGPath;
        self.maskLayerUp.position = CGPointMake(15.0f - progress * 30, 10.0f);
    }

}

- (void)startAnimating {
    [super startAnimating];

    if ([self.maskLayerUp animationForKey:RotationAnimation]) {
        return;
    }
//    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
//    rotationAnimation.toValue = @(2.0 * M_PI + [[self.shapeLayer valueForKeyPath:@"transform.rotation.z"] doubleValue]);
//    rotationAnimation.duration = 1.0;
//    rotationAnimation.repeatCount = INFINITY;
//    rotationAnimation.removedOnCompletion = NO;
//    rotationAnimation.fillMode = kCAFillModeForwards;
//    [self.shapeLayer addAnimation:rotationAnimation forKey:RotationAnimation];
    
    CABasicAnimation *downAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    downAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(-15.0f, 10.0f)];
    downAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(15.0f, 10.0f)];
    downAnimation.duration = 1.0;
    downAnimation.repeatCount = INFINITY;
    [self.maskLayerUp addAnimation:downAnimation forKey:RotationAnimation];
    
}

- (void)stopLoading {
    [super stopLoading];

    [self.maskLayerUp removeAnimationForKey:RotationAnimation];
}

- (CGFloat)currentDegree {
    CGFloat degree = [[self.shapeLayer valueForKeyPath:@"transform.rotation.z"] doubleValue];
    return degree;
}

- (void)tintColorDidChange {
    [super tintColorDidChange];

//    self.shapeLayer.strokeColor = [UIColor redColor].CGColor;//self.tintColor.CGColor;
}

- (void)layoutSubviews {
    [super layoutSubviews];

//    self.shapeLayer.frame = self.bounds;
//
//    CGFloat inset = self.shapeLayer.lineWidth / 2.0;
//    self.shapeLayer.path = [[UIBezierPath bezierPathWithOvalInRect:CGRectInset(self.shapeLayer.bounds, inset, inset)] CGPath];
}

@end
