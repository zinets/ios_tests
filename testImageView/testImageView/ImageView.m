//
//  ImageView.m
//

#import "ImageView.h"

@interface ImageView () <UIScrollViewDelegate, UIGestureRecognizerDelegate> {
    UIColor *intBgColor;
    BOOL pullDownReached;
}
@property (nonatomic, strong) UIImageView *imageSite;
@property (nonatomic) CGFloat pullDownLimit;
@end

@implementation ImageView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initComponents];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initComponents];
    }
    return self;
}

- (id)copyWithZone:(nullable NSZone *)zone {
    // делаю копию - фрейм как у источника
    ImageView *res = [[ImageView alloc] initWithFrame:self.frame];
    // затем картинка - в сеттере делаются расчеты
    res.image = self.image;
    // скорее всего у источника нет делегата, но
    res.pullDownDelegate = self.pullDownDelegate;
    // размер содержимого пересчитался, надо выровнять положение картинок на старте
    res.contentOffset = self.contentOffset;

    return res;
}

- (void)initComponents {
    self.clipsToBounds = YES;
    self.backgroundColor = [UIColor blackColor];

    self.delegate = self;
    self.pullDownLimit = 150;
    
    self.minimumZoomScale = 1;
    self.maximumZoomScale = 3;
    self.bounces = NO;
    self.bouncesZoom = NO;

    [self addSubview:self.imageSite];
    
#ifdef DEBUG
    self.layer.borderColor = [UIColor yellowColor].CGColor;
    self.layer.borderWidth = 2;
#endif
}

- (void)relayImage {
    if (_image) {
        CGSize imageSize = _image.size;
        CGFloat imageAR = imageSize.width / imageSize.height;
        
        CGSize thisSize = self.frame.size;
        CGFloat thisAR = thisSize.width / thisSize.height;
        CGRect rectToFit = self.bounds;
        
        if (self.zoomEnabled) {
            if (imageAR > thisAR) {
                rectToFit.origin.x = 0;
                rectToFit.size.width = thisSize.width;
                CGFloat k = thisSize.width / imageSize.width;
                CGFloat h = imageSize.height * k;
                rectToFit.size.height = h;
                rectToFit.origin.y = (thisSize.height - h) / 2;
            } else {
                rectToFit.size.height = thisSize.height;
                rectToFit.origin.y = 0;
                CGFloat k = thisSize.height / imageSize.height;
                CGFloat w = imageSize.width * k;
                rectToFit.size.width = w;
                rectToFit.origin.x = (thisSize.width - w) / 2;
            }
            self.contentSize = rectToFit.size;
        } else {
            if (thisAR > imageAR) {
                CGFloat k = thisSize.width / imageSize.width;
                rectToFit = (CGRect){{0, 0}, {thisSize.width, imageSize.height * k}};
            } else if (thisAR < imageAR) {
                CGFloat k = imageSize.height / thisSize.height;
                CGFloat w = imageSize.width / k;
                rectToFit = (CGRect){{(thisSize.width - w) / 2, 0}, {w, thisSize.height}};
            } else {
                
            }
            self.contentOffset = (CGPoint){-rectToFit.origin.x, -rectToFit.origin.y};
            self.contentSize = rectToFit.size;
            
            rectToFit.origin = CGPointZero;
        }
        self.imageSite.frame = rectToFit;
        self.imageSite.image = _image;
    }
}

#pragma mark - getters

-(UIImageView *)imageSite {
    if (!_imageSite) {
        _imageSite = [UIImageView new];
    }
    return _imageSite;
}

#pragma mark -

-(void)setImage:(UIImage *)image {
    BOOL canBeAnimated = _image != nil;
    _image = image;

    if (canBeAnimated) {
        CATransition *a = [CATransition animation];
        a.type = kCATransitionFade;
        [self.layer addAnimation:a forKey:@"imageLoading"];
    }
    [self relayImage];
}

-(void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    if (_image) {
        [self relayImage];
    }
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    intBgColor = backgroundColor;
    [super setBackgroundColor:intBgColor];
}

- (UIColor *)backgroundColor {
    return intBgColor;
}

-(void)setZoomEnabled:(BOOL)zoomEnabled {
    _zoomEnabled = zoomEnabled;
    self.bounces = self.alwaysBounceVertical = _zoomEnabled;

    self.imageSite.transform = CGAffineTransformIdentity;
    [self relayImage];
}

- (void)setPullDownDelegate:(id <ControlPullDownProtocol>)pullDownDelegate {
    _pullDownDelegate = pullDownDelegate;
    if (_pullDownDelegate) {
        self.pullDownLimit = _pullDownDelegate.pullDownLimit;
    }
}

#pragma mark - scroller

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    CGRect imageSiteFrame = self.imageSite.frame;
    CGPoint pt = scrollView.contentOffset;
    
    if (self.imageSite.bounds.size.height < self.bounds.size.height) {
        // пока размер меньше размера скроллера - при зуме орижин вью, которое зумим не меняется - меняю его вручную
        imageSiteFrame.origin.y = MAX(0, (self.frame.size.height - imageSiteFrame.size.height) / 2);
    } else {
        // если размер вью, которое зумим, больше - включается скрол за счет зума
        imageSiteFrame.origin.y = 0;
    }
    
    if (self.imageSite.bounds.size.width < self.bounds.size.width) {
        imageSiteFrame.origin.x = MAX(0, (self.frame.size.width - imageSiteFrame.size.width) / 2);
    } else {
        imageSiteFrame.origin.x = 0;
    }
    
    self.imageSite.frame = imageSiteFrame;
    self.contentOffset = pt;
    self.alwaysBounceVertical = _zoomEnabled && (self.zoomScale == 1);
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView {
    return NO;
}

- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    if (self.zoomEnabled) {
        return self.imageSite;
    } else {
        return nil;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.zoomEnabled &&
            scrollView.contentOffset.y > 0 &&
            scrollView.contentSize.height <= self.imageSite.bounds.size.height) {
        CGPoint pt = scrollView.contentOffset;
        pt.y = 0;
        scrollView.contentOffset = pt;
    } else if (!pullDownReached && self.zoomEnabled &&
            scrollView.contentOffset.y < 0 && self.zoomScale == 1) {
        CGFloat alpha = 1 - ABS(scrollView.contentOffset.y / self.pullDownLimit);
        [super setBackgroundColor:[intBgColor colorWithAlphaComponent:alpha + 0.2]];
        // вот какая хрень: сейчас скролвью "оттянут" вниз; если не просто тянуть вниз пальцем, а "махнуть" - то а) вью поедет вниз б) скролвью потянет вью вверх и получится небольшое дергание
        // а если я возьму и перекладу вью "наверх"? и пусть скроллер (без содержимого) едет себе назад, вью поедет вниз по другому вью :)
        // но это пц как нехорошо, надо быть увереным, что этот контрол тут же разрушиться и не будет использоваться повторно
        if (self.pullDownDelegate &&
                ABS(scrollView.contentOffset.y) >= self.pullDownLimit) {
            pullDownReached = YES;

            CGRect frm = [self convertRect:self.imageSite.frame toView:self.superview];
            [self.superview addSubview:self.imageSite];
            self.imageSite.frame = frm;

            [UIView animateWithDuration:0.3
                                  delay:0
                                options:UIViewAnimationOptionCurveEaseIn
                             animations:^{
                                 self.imageSite.transform = CGAffineTransformTranslate(self.imageSite.transform, 0, self.bounds.size.height - self.imageSite.frame.origin.y);
                                 self.backgroundColor = [UIColor clearColor];
                             } completion:^(BOOL finished) {
                        [self addSubview:self.imageSite]; // ну или так все восстановить - но надо где-то восстановить и трансформ, а когда? после удаления видимо в методе делегата с вью; но если удаление - то и смысла в общем наверное нету ж?
                        [self.pullDownDelegate controlReachedPullDownLimit:self];
                        // и кроме того - а если в методе делегата будет анимация? тогда тут еще она не закончится
                        self.imageSite.transform = CGAffineTransformIdentity;
            }];
        }
    }
}

@end