//
//  FFDropMenuView.m
//  MobileInspection
//
//  Created by North on 2021/3/25.
//  Copyright © 2021 North. All rights reserved.
//

#import "FFDropMenuView.h"


@interface FFDropMenuView ()

/// 父视图
@property (weak, nonatomic) UIView * inView;

/// 上下间距
@property (assign, nonatomic) FFSpacing  spacing;

/// 内容容器
@property (retain, nonatomic) UIView * containerView;

/// 内容容器
@property (retain, nonatomic) CAShapeLayer * maskLayer;

/// 自定义菜单map
@property (retain, nonatomic) NSMutableDictionary <NSString *,UIView <FFDropMenuProtocol> * > * menuMap;

/// 父视图
@property (weak, nonatomic) UIView <FFDropMenuProtocol> * currentMenu;

///上一次显示的菜单高度
@property (assign ,nonatomic) CGFloat menuHeight;

@end


@implementation FFDropMenuView

#pragma mark - 初始化

- (instancetype)initInView:(UIView *)inView
                     spacing:(FFSpacing)spacing
                     limit:(NSNumber *)limit
              cancelHeight:(CGFloat)cancelHeight
                    radius:(CGFloat)radius{
    
    self = [super initWithFrame:CGRectZero];
    
    if (self) {
        
        self.inView = inView;
        self.spacing = spacing;
        self.limit = limit;
        self.cancelHeight = cancelHeight;
        self.radius = radius;
        
        [self setUpConfig];
        
        [self setUpMenu];
    }
    
    return self;
    
}

+ (instancetype)initInView:(UIView *)inView
                     spacing:(FFSpacing)spacing
                     limit:(NSNumber *)limit
              cancelHeight:(CGFloat)cancelHeight
                    radius:(CGFloat)radius{
    
    return [[self alloc] initInView:inView spacing:spacing limit:limit cancelHeight:cancelHeight radius:radius];
    
}



/// 默认配置
- (void)setUpConfig{
    
    self.menuMap = @{}.mutableCopy;
    self.duration = 0.2;
    self.shadowColor = [UIColor.blackColor colorWithAlphaComponent:.15];
    
}

/// 设置菜单视图
- (void)setUpMenu{
    
    self.containerView = [[UIView alloc] initWithFrame:CGRectZero];
    [self addSubview:self.containerView];
    
    self.maskLayer = [CAShapeLayer layer];
    self.containerView.layer.mask = self.maskLayer;
    
    
    }

#pragma mark - setter

- (void)setShadowColor:(UIColor *)shadowColor{
    _shadowColor = shadowColor;
    self.backgroundColor = shadowColor;
}

- (void)setRadius:(CGFloat)radius{
    _radius = radius;
    self.maskLayer.path = [self generateMaskPathWithHeight:self.menuHeight].CGPath;
}

#pragma mark - 注册

- (void)registerMenu:(UIView<FFDropMenuProtocol> *)view
                identifier:(NSString *)identifier{
    
    [self.menuMap setValue:view forKey:identifier];
    [self.containerView addSubview:view];
    
}

#pragma mark - 显示

- (void)showDropMenu:(NSString *)identifier
                      data:(id)data
                 selection:(id)selection
                completion:(FFDropMenuActionBlock)completion{
    
    
    // 如果未展开
    if (!self.superview) {
        
        self.frame = CGRectMake(0, self.spacing.top, CGRectGetWidth(self.inView.bounds), CGRectGetHeight(self.inView.bounds) - self.spacing.top - self.spacing.bottom);
        [self.inView addSubview:self];
        
        self.containerView.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), 0);
        self.maskLayer.path = [self generateMaskPathWithHeight:0].CGPath;
    }
    
    // 隐藏其他菜单
    
    [self.menuMap enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, UIView <FFDropMenuProtocol> * _Nonnull obj, BOOL * _Nonnull stop) {
        
        obj.hidden = ![key isEqualToString:identifier];
        
    }];
    
    
    self.currentMenu = [self.menuMap valueForKey:identifier];
    
    //最大能显示的菜单高度
    CGFloat maxMenuHeight = CGRectGetHeight(self.inView.bounds) - self.spacing.top - self.spacing.bottom - self.cancelHeight;
    
    self.currentMenu.maxMenuHeight = maxMenuHeight;
    self.currentMenu.data = data;
    self.currentMenu.containerWidth = CGRectGetWidth(self.containerView.bounds);
    self.currentMenu.actionBlock = ^(FFDropMenuAction action, id result) {
        
        if (action == FFDropMenuActionChangeHeight) {
            
            [self animationWithMenuHeight:[result floatValue]];
            
        } else {
            
            if (completion)completion(action,selection);
            [self hideWithCompletion:nil];
        }
        
    };
    
    if ([self.currentMenu respondsToSelector:@selector(setSelection:)]) {
        self.currentMenu.selection = selection;
    }
    
    if ([self.currentMenu respondsToSelector:@selector(setLimit:)]) {
        self.currentMenu.limit = self.limit;
    }
    
    if ([self.currentMenu respondsToSelector:@selector(setDuration:)]) {
        self.currentMenu.duration = self.duration;
    }
    
    if ([self.currentMenu respondsToSelector:@selector(setForwardContainerHeight:)]) {
        self.currentMenu.forwardContainerHeight = CGRectGetHeight(self.containerView.bounds);
    }
    
    [self.currentMenu setUpDropMenu];
    
    CGFloat newMenuHeight = MIN(maxMenuHeight, [self.currentMenu menuHeight]);
    
    [self animationWithMenuHeight:newMenuHeight];
    
}

- (void)animationWithMenuHeight:(CGFloat)newMenuHeight{
    
    /* 是否立刻修改
     如果新的高度小于以前的高度是 立即修改会没有动画效果
     */
    BOOL changeHeightNow = self.menuHeight <= newMenuHeight;
    
    CGFloat menuHeight = changeHeightNow ? newMenuHeight : self.menuHeight;
    
    //调整容器大小
    self.containerView.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), menuHeight);
    //调整菜单大小
    self.currentMenu.frame = self.containerView.bounds;
    
    [self maskPathAnimationWith:[self generateMaskPathWithHeight:newMenuHeight]];
    
    [self maskBackgroundColorAnmationWith:self.shadowColor];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        self.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:.15];
        self.maskLayer.path = [self generateMaskPathWithHeight:newMenuHeight].CGPath;
        self.menuHeight = newMenuHeight;
        
        if (!changeHeightNow) {
            
            self.containerView.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), newMenuHeight);
            self.currentMenu.frame = self.containerView.bounds;
        }
        
    });
}


#pragma mark - 隐藏
- (void)hideWithCompletion:(void(^)(void))completion{
    
    [self maskPathAnimationWith:[self generateMaskPathWithHeight:0]];
    
    [self maskBackgroundColorAnmationWith:UIColor.clearColor];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        self.backgroundColor = UIColor.clearColor;
        self.maskLayer.path = [self generateMaskPathWithHeight:0].CGPath;
        self.menuHeight = 0;
        [self removeFromSuperview];
        
        if (completion)completion();
    });
    
}


- (UIBezierPath *)generateMaskPathWithHeight:(CGFloat)height{
    
    CGRect rect = self.containerView.bounds;
    rect.size.height = height;
    
    return [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(self.radius, self.radius)];
}

- (void)maskPathAnimationWith:(UIBezierPath *)path{
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
    animation.removedOnCompletion = NO;
    animation.duration = self.duration;
    animation.fillMode = kCAFillModeForwards;
    animation.toValue = (__bridge id _Nullable)path.CGPath;
    [self.maskLayer addAnimation:animation forKey:@"path"];
    
}

- (void)maskBackgroundColorAnmationWith:(UIColor *)color{
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
    animation.removedOnCompletion = NO;
    animation.duration = self.duration;
    animation.fillMode = kCAFillModeForwards;
    animation.toValue = (__bridge id _Nullable)color.CGColor;
    [self.layer addAnimation:animation forKey:@"backgroundColor"];
}


- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    UITouch * touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    if (!CGRectContainsPoint(self.containerView.frame, point)) {
        
        id reslut = nil;
        
        if ([self.currentMenu respondsToSelector:@selector(setLimit:)]) {
            reslut = self.currentMenu.selection;
        }
        
        if (self.currentMenu.actionBlock) {
            self.currentMenu.actionBlock(FFDropMenuActionCancel, reslut);
        }
        
    }
    
}


@end


