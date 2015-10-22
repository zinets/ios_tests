//
//  WBPull2Refresh.m
//  testP2R
//
//  Created by Zinetz Victor on 23.06.14.
//  Copyright (c) 2014 Cupid plc. All rights reserved.
//

#import "WBPull2Refresh.h"

#warning remove if designer used
#import "UIColor+MUIColor.h"

typedef NS_ENUM(NSInteger, ControlState) {
    ControlStateHidden, // default
    ControlStatePreparing, // оттягиваем ДО критической точки
    ControlStateReady, // оттянули больше критической точки
    ControlStateWorking, // показываем обновление
};

@interface WBPull2Refresh() {
    UIImageView * _activityIndicator;
    NSTimer * activityTimer;
    UIView * _bgView;
}
@property (nonatomic, assign) ControlState state;
@end

@implementation WBPull2Refresh {
    
}

+(instancetype)refreshIndicator {
#warning size!
    id v = [[self alloc] initWithFrame:CGRectMake(0, 0, 320, 0)];
    
    return v;
}

#define STEP_HEIGHT 40.0f
#define REFRESH_STEPS_NUM   2
#define STEPS       5
#define TIMER_FPS   20.0f
#define MIN_OFFSET  (STEP_HEIGHT * 2)

static const int colors[STEPS] = {0xe65d8bce, 0xcc5d8bce, 0xb35d8bce, 0x995d8bce, 0x805d8bce};

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHex:0xfcfcfc];
        self.clipsToBounds = YES;
        
        [self drawBg];
        
        _bgView = [[UIView alloc] initWithFrame:self.bounds];
        _bgView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _bgView.backgroundColor = [UIColor colorWithHex:colors[0]];
        _bgView.alpha = 0;
        [self addSubview:_bgView];

        _activityIndicator = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self addSubview:_activityIndicator];
        
        _state = ControlStateHidden;
    }
    return self;
}

#pragma mark - set/getters

- (void)didMoveToSuperview;
{
    [super didMoveToSuperview];
    UIScrollView * owner = (id)self.superview;
    CGRect frm = (CGRect) {{0, owner.contentInset.top + owner.contentOffset.y}, {owner.bounds.size.width, 0}};
    self.frame = frm;
    [self beginObserveScrolls];
}

-(void)setProgress:(CGFloat)progress
{
    if (progress != _progress) {
        _progress = progress;
        switch (_state) {
            case ControlStateHidden:
                if (_progress > 0) {
                    self.state = ControlStatePreparing;
                }
                break;
            case ControlStatePreparing: {
                [activityTimer invalidate];
                
                if (_activityIndicator.bounds.size.height < self.bounds.size.height) {
                    _activityIndicator.center = (CGPoint){self.bounds.size.width / 2, self.bounds.size.height / 2};
                    _activityIndicator.alpha = 1;
                } else {
                    _activityIndicator.center = (CGPoint){self.bounds.size.width / 2, _activityIndicator.bounds.size.height / 2};
                    CGFloat d = _activityIndicator.bounds.size.height;
                    CGFloat h = 1 - (d - self.bounds.size.height) / d;
                    _activityIndicator.alpha = h;
                }
                
                if (_progress < 1) {
                    CGFloat a = 2 * M_PI * _progress;
                    CGAffineTransform transform = CGAffineTransformMakeRotation(a);
                    _activityIndicator.transform = transform;
                } else {
                    self.state = ControlStateReady;
                }
            }
                break;
            case ControlStateReady:
                if (_progress < 1) {
                    self.state = ControlStatePreparing;
                }
                break;
            case ControlStateWorking:
                break;
            default:
                break;
        }
    }
}

-(void)setState:(ControlState)state
{
    if (state != _state) {
        _state = state;
        switch (_state) {
            case ControlStateHidden: {
                [activityTimer invalidate];
                
                UIScrollView * owner = (UIScrollView *)self.superview;
                [UIView animateWithDuration:0.35
                                 animations:^
                 {
                     UIEdgeInsets offset =  owner.contentInset;
                     offset.top -= REFRESH_STEPS_NUM * STEP_HEIGHT;
                     owner.contentInset = offset;
                     owner.scrollIndicatorInsets = offset;
                     owner.bounces = YES;
                     
                     CGRect frm = self.frame;
                     frm.size.height = 0;
                     self.frame = frm;
                     
                     _bgView.alpha = 0;
                 } completion:^(BOOL finished) {
                     
                 }];
            }
                break;
            case ControlStatePreparing:
                if (_progress < 1) {
                    CGFloat a = 2 * M_PI * _progress;
                    CGAffineTransform transform = CGAffineTransformMakeRotation(a);
                    [UIView animateWithDuration:0.15
                                     animations:^{
                                         _activityIndicator.transform = transform;
                                     }];
                }
                break;
            case ControlStateReady:
                [activityTimer invalidate];
                activityTimer = [NSTimer timerWithTimeInterval:1.0 / TIMER_FPS target:self selector:@selector(onTimerFired:) userInfo:nil repeats:YES];
                [[NSRunLoop currentRunLoop] addTimer:activityTimer forMode:UITrackingRunLoopMode];
                [[NSRunLoop currentRunLoop] addTimer:activityTimer forMode:NSRunLoopCommonModes];
                break;
            case ControlStateWorking: {
                [UIView animateWithDuration:0.35
                                 animations:^
                 {
                     CGRect frm = self.frame;
                     frm.origin.y = -REFRESH_STEPS_NUM * STEP_HEIGHT;
                     frm.size.height = REFRESH_STEPS_NUM * STEP_HEIGHT;
                     self.frame = frm;
                     
                     _activityIndicator.center = (CGPoint){self.bounds.size.width / 2, self.bounds.size.height / 2};
                     
                     UIScrollView * owner = (UIScrollView *)self.superview;
                     UIEdgeInsets offset =  owner.contentInset;
                     offset.top += REFRESH_STEPS_NUM * STEP_HEIGHT;
                     owner.contentInset = offset;
                     owner.scrollIndicatorInsets = offset;
                     owner.bounces = NO;
                     _bgView.alpha = 1;
                 }];
            }
                break;
            default:
                break;
        }
    }
}

-(void)setActivityImage:(UIImage *)activityImage
{
    _activityIndicator.image = activityImage;
    [_activityIndicator sizeToFit];
}

-(UIImage *)activityImage
{
    return _activityIndicator.image;
}

#pragma mark -

-(void)beginObserveScrolls
{
    [self addObserver:self
           forKeyPath:@"superview.contentOffset"
              options:NSKeyValueObservingOptionNew
              context:nil];
}

-(void)stopObserveScrolls
{
    [self removeObserver:self forKeyPath:@"superview.contentOffset"];
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

-(void)onTimerFired:(id)sender
{
    CGAffineTransform transform = CGAffineTransformRotate(_activityIndicator.transform, M_PI / TIMER_FPS);
    _activityIndicator.transform = transform;
}

#pragma mark - overrides

// фон закрашивается полосками таким тупняковым методом, потому что иначе глюки с анимацией изменения фрейма
-(void)drawBg
{
    CGRect r = (CGRect){CGPointZero, {self.bounds.size.width, STEP_HEIGHT}};
    for (int x = 0; x < STEPS; x++) {
        UIView * b = [[UIView alloc] initWithFrame:r];
        b.backgroundColor = [UIColor colorWithHex:colors[x]];
        [self addSubview:b];
        
        r = CGRectOffset(r, 0, STEP_HEIGHT);
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
