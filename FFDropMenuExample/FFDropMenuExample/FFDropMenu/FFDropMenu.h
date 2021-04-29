//
//  FFDropMenu.h
//  MobileInspection
//
//  Created by North on 2021/3/25.
//  Copyright © 2021 North. All rights reserved.
//

#ifndef FFDropMenu_h
#define FFDropMenu_h

#pragma mark - 枚举

///菜单行为
typedef NS_ENUM(NSUInteger, FFDropMenuAction) {
    
    FFDropMenuActionCancel,          // 取消
    FFDropMenuActionCompletion,      // 完成
    FFDropMenuActionChangeHeight     // 改变高度
};

#pragma mark - 结构体

///上下间距结构体
struct  FFSpacing {
    CGFloat top, bottom;
};

typedef struct CG_BOXABLE FFSpacing FFSpacing;

CG_INLINE FFSpacing FFSpacingMake(CGFloat top, CGFloat bottom) {
    
    FFSpacing magin;
    magin.top = top;
    magin.bottom = bottom;
    return magin;
}


#pragma mark - 块
///选中回调块
typedef void(^FFDropMenuActionBlock) (FFDropMenuAction action,id result);


#pragma mark - 协议

/// 自定义菜单协议
@protocol FFDropMenuProtocol <NSObject>

@required

///最大高度
@property (assign, nonatomic) CGFloat maxMenuHeight;

///容器宽度
@property (assign, nonatomic) CGFloat containerWidth;

/// 数据
@property (retain, nonatomic) id data;

/// 完成回调
@property (copy, nonatomic) FFDropMenuActionBlock actionBlock;


/// 设置下拉菜单
- (void)setUpDropMenu;

/// 获取自定义菜单高度
- (CGFloat)menuHeight;

@optional

/// 选中 如果需要选中回填需要实现
@property (retain, nonatomic) id selection;

/// 动画时间  当子视图需要动画需要实现
@property (assign,nonatomic) CGFloat duration;

/// 高度限制 可以是行数也可以是高度
@property (assign, nonatomic) NSNumber * limit;

/// 显示本菜单之前的容器高度
@property (assign, nonatomic) CGFloat forwardContainerHeight;

@end

#endif /* FFDropMenu_h */
