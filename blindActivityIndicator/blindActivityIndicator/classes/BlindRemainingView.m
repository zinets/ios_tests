//
//  BlindRemainingView.m
//  blindActivityIndicator
//
//  Created by Victor Zinets on 11/7/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

#import "BlindRemainingView.h"

@interface BlindRemainingView ()
@property (nonatomic) NSTimeInterval remainingTime;

@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) CAShapeLayer *lineLayer;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation BlindRemainingView

- (void)commonInit {
    [self addSubview:self.timeLabel];
    
    _overallTime = 5 * 60;
    _lineWidth = 4;
    _lineSpace = 3;
    _lineColor = [UIColor greenColor];
    
    [self.layer addSublayer:self.lineLayer];
    [self setNeedsLayout];
    
    self.remainingTime = 0;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self commonInit];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    [self updateLineLayer];
}

#pragma mark - getters

-(UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _timeLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        
        _timeLabel.font = [UIFont systemFontOfSize:16 weight:(UIFontWeightSemibold)];
        _timeLabel.textColor = [UIColor whiteColor];
    }
    return  _timeLabel;
}

- (void)setOverallTime:(NSTimeInterval)overallTime {
    _overallTime = MAX(0, overallTime);
    self.remainingTime = _overallTime;
}

-(void)setRemainingTime:(NSTimeInterval)remainingTime {
    _remainingTime = MIN(remainingTime, self.overallTime);
    [self updateRemaining];
}

-(void)setTextRemainVisible:(BOOL)textRemainVisible {
    _textRemainVisible = textRemainVisible;
    self.timeLabel.hidden = !_textRemainVisible;
}

-(CAShapeLayer *)lineLayer {
    if (!_lineLayer) {
        _lineLayer = [CAShapeLayer new];
        _lineLayer.lineWidth = self.lineWidth;
        _lineLayer.strokeStart = 0;
        _lineLayer.strokeEnd = 0.6;
        _lineLayer.strokeColor = self.lineColor.CGColor;
        _lineLayer.fillColor = [UIColor clearColor].CGColor;
        _lineLayer.lineCap = kCALineCapRound;
        
        CATransform3D transform = CATransform3DIdentity;
        transform = CATransform3DScale(transform, -1, 1, 1);
        transform = CATransform3DRotate(transform, M_PI_2, 0, 0, 1);
        _lineLayer.transform = transform;
    }
    return _lineLayer;
}

-(void)setEmbeddedView:(UIView *)embeddedView {
    [_embeddedView removeFromSuperview];
    _embeddedView = embeddedView;
    [self insertSubview:_embeddedView belowSubview:self.timeLabel];    
    
    [self setNeedsLayout];
}

-(void)setLineColor:(UIColor *)lineColor {
    _lineColor = lineColor;
    _lineLayer.strokeColor = _lineColor.CGColor;
}

-(void)setLineWidth:(CGFloat)lineWidth {
    _lineWidth = lineWidth;
    _lineLayer.lineWidth = _lineWidth;
}

#pragma mark - internal

- (void)updateLineLayer {
    CGFloat w = MIN(self.bounds.size.width, self.bounds.size.height) - self.lineWidth; // линия не должна вылезать за боундс контрола, так что срезаю пол-линии
    self.lineLayer.frame = (CGRect){0, 0, w, w};
    UIBezierPath *linePath = [UIBezierPath bezierPathWithOvalInRect:self.lineLayer.bounds];
    self.lineLayer.path = linePath.CGPath;
    
    self.lineLayer.position = (CGPoint){self.bounds.size.width / 2, self.bounds.size.height / 2};
    
    w -= self.lineWidth + self.lineSpace * 2;
    self.embeddedView.frame = (CGRect){0, 0, w, w};
    self.embeddedView.center = (CGPoint){self.bounds.size.width / 2, self.bounds.size.height / 2};
    self.embeddedView.layer.cornerRadius = w / 2;
    self.embeddedView.clipsToBounds = YES;
}

- (void)updateRemaining{
    CGFloat k = _overallTime == 0 ? 0 : (_remainingTime / _overallTime);    
    self.lineLayer.strokeEnd = k;
    if (self.textRemainVisible) {
        _timeLabel.text = self.formattedRemainingTime;
    }
}

-(NSString *)formattedRemainingTime {
    NSInteger ti = (NSInteger)self.remainingTime;
    NSInteger seconds = ti % 60;
    NSInteger minutes = (ti / 60) % 60;
    NSInteger hours = (ti / 3600);
    NSString *time = nil;
    if (hours > 0) {
        time = [NSString stringWithFormat:@"%02li:%02li:%02li", (long)hours, (long)minutes, (long)seconds];
    } else {
        time = [NSString stringWithFormat:@"%02li:%02li", (long)minutes, (long)seconds];
    }
    return time;
}

#pragma mark - timer

- (void)stopTimer {
    [self.timer invalidate];
    _timer = nil;
    _remainingTime = self.overallTime;
}

- (void)pauseTimer {
    [self.timer invalidate];
    _timer = nil;
}

- (void)startTimer {
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
    }
}

- (void)timerFired:(NSTimer *)sender {
    if (--self.remainingTime == 0) {
        [self stopTimer];
        if ([self.delegate respondsToSelector:@selector(remainingDidEnd:)]) {
            [self.delegate remainingDidEnd:self];
        }
    }    
}

#pragma mark -

- (void)prepareForInterfaceBuilder {
    [super prepareForInterfaceBuilder];
    
    self.overallTime = 40;
    self.remainingTime = 25;
    
    UILabel *fakeView = [UILabel new];
    fakeView.backgroundColor = [UIColor greenColor];
    fakeView.numberOfLines = 0;
    fakeView.textAlignment = NSTextAlignmentCenter;
    fakeView.text = @"Embedded \n\n\n view";
    self.embeddedView = fakeView;
    
    self.timeLabel.text = @"05:57";
}

@end
