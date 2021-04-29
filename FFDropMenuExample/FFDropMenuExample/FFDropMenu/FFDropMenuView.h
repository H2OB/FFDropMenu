//
//  FFDropMenuView.h
//  MobileInspection
//
//  Created by North on 2021/3/25.
//  Copyright © 2021 North. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FFDropMenu.h"

/// 下拉菜单视图
@interface FFDropMenuView : UIView

/// 阴影颜色
@property (retain,nonatomic) UIColor * shadowColor;

/// 动画时间  默认0.2秒
@property (assign,nonatomic) CGFloat duration;

/// 圆角半径  如果想改变之前的  请在显示之前显示
@property (assign, nonatomic) CGFloat radius;

/// 限制 可以输行数 也可以是高度
@property (retain, nonatomic) NSNumber * limit;

/// 最小取消高度 如果想改变之前的  请在显示之前显示
@property (assign, nonatomic) CGFloat cancelHeight;

#pragma mark - 初始化

/// 初始化
/// @param inView 所在视图
/// @param magin 菜单上下边距 edge的作用是上方下方有需要让开的按钮或tabbar
/// @param limit 限制可以是行数 也可以是高度
/// @param cancelHeight 最小取消高度
/// @param radius 圆角半径
- (instancetype)initInView:(UIView *)inView
                     spacing:(FFSpacing)spacing
                    limit:(NSNumber *)limit
              cancelHeight:(CGFloat)cancelHeight
                    radius:(CGFloat)radius;

/// 初始化
/// @param inView 所在视图
/// @param magin 菜单上下边距 edge的作用是上方下方有需要让开的按钮或tabbar
/// @param limit 限制可以是行数 也可以是高度
/// @param cancelHeight 最小取消高度
/// @param radius 圆角半径
+ (instancetype)initInView:(UIView *)inView
                     spacing:(FFSpacing)spacing
                    limit:(NSNumber *)limit
              cancelHeight:(CGFloat)cancelHeight
                    radius:(CGFloat)radius;


#pragma mark - 注册菜单

/// 注册自定义菜单
/// @param view 自定义菜单
/// @param identifier 菜单唯一标识
- (void)registerMenu:(UIView <FFDropMenuProtocol> *)view
                identifier:(NSString *)identifier;


#pragma mark - 显示菜单
- (void)showDropMenu:(NSString *)identifier
                      data:(id)data
                 selection:(id)selection
                completion:(FFDropMenuActionBlock)completion;



#pragma mark - 隐藏菜单
/// 隐藏
/// @param completion 完成回调
- (void)hideWithCompletion:(void(^)(void))completion;

@end

