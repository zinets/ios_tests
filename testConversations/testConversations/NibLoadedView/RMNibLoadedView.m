//
//  RMNibLoadedView.m
//  Pods
//
//  Created by pm on 02.09.16.
//
//

#import "RMNibLoadedView.h"
#import "RMCachingNibLoader.h"

@interface RMNibLoadedView ()

@property(nonatomic) BOOL needReload;
@property(nonatomic,strong) NSNumber* nibViewIndexNumber;

@end

@implementation RMNibLoadedView

- (instancetype)init {
    return  [self initWithFrame:CGRectZero];
}
- (instancetype)initWithFrame:(CGRect)frame
             reloadingFromNib:(BOOL)reloadingFromNib {
    self = [super initWithFrame:frame];
    if (self && reloadingFromNib) {
        self.needReload = reloadingFromNib;
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    BOOL reloadFromNib = YES;
#if TARGET_INTERFACE_BUILDER
    reloadFromNib = NO;
#endif
    return [self initWithFrame:frame
              reloadingFromNib:reloadFromNib];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.needReload = YES;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
                      nibName:(NSString *)nibName
                 nibViewIndex:(NSInteger)nibViewIndex
                     inBundle:(NSBundle *)bundle
                      options:(NSDictionary *)options {
   self = [self initWithFrame:frame
             reloadingFromNib:NO];
   if (self) {
      self.nibName = nibName;
      self.nibViewIndex = nibViewIndex;
      self.nibBundle = bundle;
      self.nibOptions = options;
       
      [self commonInit];
   }
   return self;
}

- (void)prepareForInterfaceBuilder {
   [super prepareForInterfaceBuilder];
   self.needReload = YES;
   [self reloadNibView];
}

- (void)awakeFromNib {
   [super awakeFromNib];
    if (self.needReload) {
        [self commonInit];
    }
    [self reloadNibView];
    [self.nibView awakeFromNib];
}

- (void)setNibView:(UIView *)nibView {
   if (_nibView) {
      [_nibView removeFromSuperview];
   }
   _nibView = nibView;
}

- (void)commonInit {
    [self reloadNibView];
}

- (NSInteger)nibViewIndex {
    return self.nibViewIndexNumber.integerValue;
}

- (void)setNibViewIndex:(NSInteger)nibViewIndex {
    self.nibViewIndexNumber = @(nibViewIndex);
}

- (void)setNibViewIndexNumber:(NSNumber *)nibViewIndexNumber {
    if ([_nibViewIndexNumber isEqual: nibViewIndexNumber]) {
            return;
    }
    _nibViewIndexNumber = nibViewIndexNumber;
    self.needReload = YES;
    [self reloadNibView];
}

- (void)setNibName:(NSString *)nibName {
    if ([_nibName isEqualToString:nibName]) {
        return;
    }
   _nibName = nibName;
   self.needReload = YES;
   [self reloadNibView];
}

- (NSBundle *)nibBundle {
   if (!_nibBundle) {
      _nibBundle = [NSBundle bundleForClass:self.class];
   }
   return _nibBundle;
}

- (void)reloadNibView {
   if (self.needReload) {
      UIView *nibView = [RMCachingNibLoader loadViewFromNibNamed:self.nibName
                                                        inBundle:self.nibBundle
                                                         atIndex:self.nibViewIndex
                                                         options:self.nibOptions
                                                      loaderView:self];
      nibView.frame = self.bounds;
      nibView.translatesAutoresizingMaskIntoConstraints = YES;
      nibView.autoresizingMask =
      (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
      [self addSubview:nibView];
      self.nibView = nibView;
      self.needReload = NO;
   }
}

@end
