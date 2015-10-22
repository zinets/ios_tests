//
//  DateHarborRefresh.m
//  Flirt
//
//  Created by Zinetz Victor on 2014.
//

#import "Pull2RefreshControl.h"
#warning эти инклуды потом можно убрать
#import "UIColor+MUIColor.h"
#import "UIView+Geometry.h"

typedef NS_ENUM(NSInteger, ControlState) {
    ControlStateHidden, // default
    ControlStatePreparing, // оттягиваем ДО критической точки
    ControlStateReady, // оттянули больше критической точки
    ControlStateWorking, // показываем обновление
};

@interface Pull2RefreshControl() {
    UIImageView * _activityIndicator, * _overlay;
    NSTimer * activityTimer;
}
@property (nonatomic, assign) ControlState state;
@property (nonatomic, strong) CALayer * pulseLayer;
@end

@implementation Pull2RefreshControl {
    
}

@synthesize showAnimated = _showAnimated;
@synthesize progress = _progress;

+(instancetype)instance {
    id v = [[self alloc] initWithFrame:CGRectZero];
    
    return v;
}

#define MIN_OFFSET  70.0f

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHex:0xe2e2e2];
        self.clipsToBounds = YES;
#warning использовать методы дизайнера
        _activityIndicator = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"p2r-empty"]];
        [self addSubview:_activityIndicator];
        
        _overlay = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"p2r-full"]];
        _overlay.clipsToBounds = YES;
        _overlay.contentMode = UIViewContentModeBottom;
        _overlay.height = 0;
        _overlay.bottom = _activityIndicator.height;
        [_activityIndicator addSubview:_overlay];
        
        _state = ControlStateHidden;
    }
    return self;
}

#pragma mark - set/getters

-(CALayer *)pulseLayer
{
    if (!_pulseLayer) {
        _pulseLayer = [CALayer layer];
        _pulseLayer.contentsScale = [UIScreen mainScreen].scale;
        _pulseLayer.opacity = 1;
#define PULSE_RADIUS 35.0f
        _pulseLayer.bounds = CGRectMake(0, 0, 2 * PULSE_RADIUS, 2 * PULSE_RADIUS);
        _pulseLayer.cornerRadius = PULSE_RADIUS;
        _pulseLayer.borderWidth = 5;
        _pulseLayer.borderColor = [[UIColor colorWithHex:0x5526a69a] CGColor];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
            CAAnimationGroup * animationGroup = [CAAnimationGroup animation];
            animationGroup.duration = 2;
            animationGroup.repeatCount = HUGE_VALF;
            
            CAMediaTimingFunction *defaultCurve = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
            animationGroup.timingFunction = defaultCurve;
            
            CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale.xy"];
            scaleAnimation.fromValue = @0.4;
            scaleAnimation.toValue = @1.0;
            scaleAnimation.duration = animationGroup.duration;
            
            CAKeyframeAnimation *opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
            opacityAnimation.duration = animationGroup.duration;
            opacityAnimation.values =   @[@0, @0.7, @1.0, @0.45, @0];
            opacityAnimation.keyTimes = @[@0, @0.1, @0.5, @0.8, @1];
            
            NSArray *animations = @[scaleAnimation, opacityAnimation];
            animationGroup.animations = animations;
            
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                [_pulseLayer addAnimation:animationGroup forKey:@"pulse"];
            });
        });
    }
    
    return _pulseLayer;
}

- (void)didMoveToSuperview;
{
    [super didMoveToSuperview];
    UIScrollView * owner = (id)self.superview;
    CGRect frm = (CGRect) {{0, owner.contentInset.top + owner.contentOffset.y}, {owner.bounds.size.width, 0}};
    self.frame = frm;
    [self beginObserveScrolls];
    self.state = ControlStateHidden;
}

-(void)removeFromSuperview {
    [self stopObserveScrolls];
    [super removeFromSuperview];
}

-(void)setProgress:(CGFloat)progress
{
    progress = MIN(1, progress);
    _progress = progress;
    switch (_state) {
        case ControlStateHidden:
            if (_progress > 0) {
                self.state = ControlStatePreparing;
            }
            break;
        case ControlStateReady:
            if (_progress < 1) {
                self.state = ControlStatePreparing;
            }
            break;
        case ControlStatePreparing: {
#define BOTTOM_INSET 6.0f
            CGFloat d = (1 - self.progress) * BOTTOM_INSET;
            _overlay.height = MAX(0, _activityIndicator.height * self.progress - d);
            _overlay.bottom = _activityIndicator.height;

            [UIView animateWithDuration:0.05 animations:^{
                _activityIndicator.centerX = self.bounds.size.width / 2;
                if (self.height < _activityIndicator.height + BOTTOM_INSET) {
                    _activityIndicator.bottom = self.height - BOTTOM_INSET;
                } else {
                    _activityIndicator.centerY = (self.height - BOTTOM_INSET) / 2;
                }
                
            }];

            break;
        }
        case ControlStateWorking:
        default:
            break;
    }
}

-(void)setState:(ControlState)state
{
    if (state != _state) {
        _state = state;
        switch (_state) {
            case ControlStateHidden: {
                UIScrollView * owner = (UIScrollView *)self.superview;
                [UIView animateWithDuration:0.35
                                 animations:^{
                                     UIEdgeInsets offset =  owner.contentInset;
                                     offset.top -= MIN_OFFSET;
                                     owner.contentInset = offset;
                                     owner.scrollIndicatorInsets = offset;
                                     owner.bounces = YES;
                                     
                                     CGRect frm = self.frame;
                                     frm.size.height = 0;
                                     self.frame = frm;
                                 } completion:^(BOOL finished) {
                                     _overlay.height = 0;
                                     
                                     [self.pulseLayer removeFromSuperlayer];
                                     [self.pulseLayer removeAnimationForKey:@"pulse"];
                                     self.pulseLayer = nil;
                                 }];
                break;
            }
            case ControlStateWorking: {
                [UIView animateWithDuration:0.2
                                 animations:^ {
                                     CGRect frm = self.frame;
                                     frm.origin.y = -MIN_OFFSET;
                                     frm.size.height = MIN_OFFSET;
                                     self.frame = frm;
                                     
                                     _activityIndicator.center = CGRectGetCenter(self.bounds);
                                     
                                     UIScrollView * owner = (UIScrollView *)self.superview;
                                     UIEdgeInsets offset =  owner.contentInset;
                                     offset.top += MIN_OFFSET;
                                     owner.contentInset = offset;
                                     owner.scrollIndicatorInsets = offset;
                                     owner.bounces = NO;
                                 } completion:^(BOOL finished) {
                                     self.pulseLayer.position = CGRectGetCenter(self.bounds);
                                     [self.layer insertSublayer:self.pulseLayer below:_activityIndicator.layer];
                                 }];
                break;
            }
                
            case ControlStatePreparing:
            case ControlStateReady:
                break;
            default:
                break;
        }
    }
}

#pragma mark -

-(void)beginObserveScrolls
{
    [self.superview addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
}

-(void)stopObserveScrolls
{
    [self.superview removeObserver:self forKeyPath:@"contentOffset"];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (self.state != ControlStateWorking) {
        UIScrollView * owner = (id)self.superview;
        CGFloat h = owner.contentOffset.y + owner.contentInset.top;
        if (h < 0) { // только pull вниз
            h = ABS(h);
            CGRect frm = (CGRect) {{0, -h}, {owner.bounds.size.width, h}};
            self.frame = frm;
            self.progress = h / MIN_OFFSET;
        } else {
            self.progress = 0;
        }
    }
}

#pragma mark - public

-(void)stopRefreshing
{
    self.state = ControlStateHidden;
}

-(void)startRefreshing
{
    if (self.state != ControlStateWorking) {
        self.state = ControlStateWorking;
    }
}

@end
