//
//  AppDelegate.m
//  AnimationExamplesiPhone
//
//  Created by Eric Allam on 10/05/2014.

#import "AppDelegate.h"

#pragma mark - UIColor Additions

@interface UIColor (Additions)

+ (instancetype)backgroundColor;
+ (instancetype)foregroundColor;

@end

@implementation UIColor (Additions)

+ (instancetype)backgroundColor
{
    return [self colorWithRed:25.0/255.0 green:163.0/255.0 blue:177.0/255.0 alpha:1.0];
}

+ (instancetype)foregroundColor
{
    return [self colorWithRed:255.0/255.0 green:251.0/255.0 blue:224.0/255.0 alpha:1.0];
}

@end

#pragma mark - FinishingBehavior

// See http://www.objc.io/issue-12/interactive-animations.html for a discussion of this class
@interface FinishingBehavior : UIDynamicBehavior

@property (nonatomic) CGPoint targetPoint;
@property (nonatomic) CGPoint velocity;

- (instancetype) initWithItem:(id <UIDynamicItem>)item;

@end

@interface FinishingBehavior ()
@property (nonatomic, strong) id <UIDynamicItem> item;
@property (nonatomic, strong) UIAttachmentBehavior *attachmentBehavior;
@property (nonatomic, strong) UIDynamicItemBehavior *itemBehavior;
@end

@implementation FinishingBehavior

- (instancetype) initWithItem:(id <UIDynamicItem>)item;
{
    if (self = [super init]) {
        self.item = item;
        
        [self setup];
    }
    
    return self;
}

- (void)setup {
    UIAttachmentBehavior *attachmentBehavior = [[UIAttachmentBehavior alloc] initWithItem:self.item attachedToAnchor:CGPointZero];
    attachmentBehavior.frequency = 3.5;
    attachmentBehavior.damping = 0.6;
    attachmentBehavior.length = 0;
    [self addChildBehavior:attachmentBehavior];
    self.attachmentBehavior = attachmentBehavior;
    
    UIDynamicItemBehavior *itemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self.item]];
    itemBehavior.density = 100;
    itemBehavior.resistance = 25;
    [self addChildBehavior:itemBehavior];
    self.itemBehavior = itemBehavior;
}

- (void)setTargetPoint:(CGPoint)targetPoint
{
    _targetPoint = targetPoint;
    
    self.attachmentBehavior.anchorPoint = targetPoint;
}

- (void)setVelocity:(CGPoint)velocity
{
    _velocity = velocity;
    
    CGPoint currentVelocity = [self.itemBehavior linearVelocityForItem:self.item];
    CGPoint velocityDelta = CGPointMake(velocity.x - currentVelocity.x, velocity.y - currentVelocity.y);
    
    [self.itemBehavior addLinearVelocity:velocityDelta forItem:self.item];
}

@end

#pragma mark - CustomAnimatedTransition

@interface CustomAnimatedTransition : NSObject <UIViewControllerAnimatedTransitioning, UIViewControllerInteractiveTransitioning, UIGestureRecognizerDelegate, UIDynamicAnimatorDelegate>

@property (assign, nonatomic) BOOL reversed;
@property (weak, nonatomic) id<UIViewControllerContextTransitioning> context;
@property (assign, nonatomic) CGPoint initialViewCenter;
@property (assign, nonatomic) CGFloat percentComplete;
@property (assign, nonatomic) NSTimeInterval startingTime;
@property (strong, nonatomic) CADisplayLink *displayLink;
@property (strong, nonatomic) UIDynamicAnimator *animator;
@property (strong, nonatomic) FinishingBehavior *finishingBehavior;

@property (nonatomic) UIView *view;
@property (nonatomic) UIPanGestureRecognizer *gesture;
@end

@implementation CustomAnimatedTransition

- (instancetype) init {
    
    if (self = [super init]) {
        _reversed = NO;
    }
    
    return self;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.5;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer;
{
    CGPoint location = [gestureRecognizer locationInView:self.context.containerView];
    
    CALayer *presentationLayer = self.view.layer.presentationLayer;
    
    if ([presentationLayer hitTest:location])
    {
        return YES;
    }else{
        return NO;
    }
}

- (void)tick:(CADisplayLink *)link
{
    NSTimeInterval elapedTime = link.timestamp - self.startingTime;
    NSTimeInterval duration = 0.5;
    
    self.percentComplete = MIN(1.0, elapedTime / duration);
    
    [self.context updateInteractiveTransition:self.percentComplete];
}

- (void)didPan:(UIPanGestureRecognizer *)gesture
{
    switch (gesture.state) {
        case UIGestureRecognizerStatePossible:
            break;
        case UIGestureRecognizerStateBegan: {
            CALayer *layer = self.view.layer.presentationLayer ?: self.view.layer;
            self.view.center = layer.position;
            [self.view.layer removeAllAnimations];
            
            
            self.initialViewCenter = self.view.center;
            
            [self.animator removeAllBehaviors];
            
            break;
        }
        case UIGestureRecognizerStateChanged:{
            CGPoint translation = [gesture translationInView:gesture.view];
            
            CGPoint centerTranslated = self.initialViewCenter;
            centerTranslated.x += translation.x;
            centerTranslated.y += translation.y;
            
            self.view.center = centerTranslated;
            
            CGFloat percentComplete = MAX(MIN(self.view.center.y / 284, 1.0), 0.0);
            
            if (self.reversed) percentComplete = 1.0f - percentComplete;
            
            [self.context updateInteractiveTransition:percentComplete];
            
            break;
        }
        case UIGestureRecognizerStateEnded:{
            
            CGPoint velocity = [gesture velocityInView:gesture.view];
            CGPoint location = [gesture locationInView:gesture.view];
            
            static const CGFloat kTransitionGestureVelocityThreshold = 50.0f;
            static const CGFloat kTransitionGestureLocationThreshold = 284.0f;
            
            BOOL shouldFinish;
            
            if (ABS(velocity.y) > kTransitionGestureVelocityThreshold) {
                shouldFinish = velocity.y > 0;
            } else {
                shouldFinish = location.y > kTransitionGestureLocationThreshold;
                
            }
            
            if (self.reversed) shouldFinish = !shouldFinish;
            
            if (shouldFinish) {
                [self.context finishInteractiveTransition];
            } else {
                [self.context cancelInteractiveTransition];
            }
            
            CGPoint finishCenter;
            
            if (shouldFinish) {
                if (self.reversed) {
                    finishCenter = CGPointMake(self.context.containerView.center.x, -100);
                }else{
                    finishCenter = self.context.containerView.center;
                }
            }else{
                if (self.reversed) {
                    finishCenter = self.context.containerView.center;
                }else{
                    finishCenter = CGPointMake(self.context.containerView.center.x, -100);
                }
            }
            
            if (shouldFinish) {
                [self.context finishInteractiveTransition];
            }else{
                [self.context cancelInteractiveTransition];
            }
            
            self.finishingBehavior = [[FinishingBehavior alloc] initWithItem:self.view];
            self.finishingBehavior.targetPoint = finishCenter;
            
            if (!CGPointEqualToPoint(velocity, CGPointZero)) {
                self.finishingBehavior.velocity = velocity;
            }
            
            __weak typeof(self) weakSelf = self;
            
            self.finishingBehavior.action = ^{
                if (!CGRectIntersectsRect(gesture.view.frame, weakSelf.view.frame)) {
                    [weakSelf.animator removeAllBehaviors];
                }
            };
            
            [self.animator addBehavior:self.finishingBehavior];
            
            break;
        }
        case UIGestureRecognizerStateCancelled:
            break;
        case UIGestureRecognizerStateFailed:
            break;
        default:
            break;
    }
}

- (void)dynamicAnimatorDidPause:(UIDynamicAnimator *)animator
{
    [self.animator removeAllBehaviors];
    
    for (UIGestureRecognizer *gesture in [[self.context containerView] gestureRecognizers]) {
        [gesture.view removeGestureRecognizer:gesture];
    }
    
    [self.context completeTransition:![self.context transitionWasCancelled]];
}

- (void)startInteractiveTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    self.context = transitionContext;
    
    UIView *fromView = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view;
    UIView *toView = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view;
    UIView *container = [transitionContext containerView];
    
    if (!self.reversed) {
        self.view = toView;
    }else{
        self.view = fromView;
    }
    
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:container];
    self.animator.delegate = self;
    
    UIPanGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPan:)];
    [container addGestureRecognizer:gesture];
    gesture.delegate = self;
    
    self.startingTime = CACurrentMediaTime();
    
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(tick:)];
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    
    if (!self.reversed) {
        self.view.bounds = CGRectMake(0, 0, 280, 180);
        self.view.center = CGPointMake(container.center.x, -90);
        
        [container addSubview:self.view];
        
        [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionAllowUserInteraction animations:^{
            
            self.view.center = container.center;
            
        } completion:^(BOOL finished) {
            [self.displayLink invalidate];
            
            if (finished){
                [gesture.view removeGestureRecognizer:gesture];
                
                [transitionContext finishInteractiveTransition];
                [transitionContext completeTransition:YES];
            }
            
            
        }];
    }else{
        [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionAllowUserInteraction animations:^{
            
            self.view.center = CGPointMake(container.center.x, -90);
            
        } completion:^(BOOL finished) {
            [self.displayLink invalidate];
            
            if (finished){
                [gesture.view removeGestureRecognizer:gesture];
                
                [transitionContext finishInteractiveTransition];
                [transitionContext completeTransition:YES];
            }
        }];
    }
}


@end

#pragma mark - DetailVC (Transition Delegate)

@interface DetailVC : UIViewController <UIViewControllerTransitioningDelegate>
@property (nonatomic, strong) CustomAnimatedTransition *transition;
@end

@implementation DetailVC

- (void)viewDidLoad
{
    self.view.backgroundColor = [UIColor foregroundColor];
    self.view.layer.cornerRadius = 10.0f;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    [self.view addGestureRecognizer:tapGesture];
}

- (void)tapped:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    self.transition = CustomAnimatedTransition.new;
    
    return self.transition;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    self.transition.reversed = YES;
    
    return self.transition;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id<UIViewControllerAnimatedTransitioning>)animator
{
    return (id<UIViewControllerInteractiveTransitioning>)animator;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator
{
    return (id<UIViewControllerInteractiveTransitioning>)animator;
}



@end

#pragma mark - RootVC

@interface RootVC : UIViewController

@end

@implementation RootVC

- (void)viewDidLoad
{
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    DetailVC *detailVC = [DetailVC new];
    detailVC.modalPresentationStyle = UIModalPresentationCustom;
    detailVC.transitioningDelegate = detailVC;
    
    [self presentViewController:detailVC animated:YES completion:nil];
}

@end

#pragma mark - AppDelegate

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor backgroundColor];
    self.window.rootViewController = [RootVC new];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
