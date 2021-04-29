//
//  DropMenu2.h
//  FFDropMenuExample
//
//  Created by North on 2021/4/25.
//

#import <UIKit/UIKit.h>
#import "FFDropMenu.h"

@interface DropMenu2 : UIView <FFDropMenuProtocol>

///最大高度
@property (assign, nonatomic) CGFloat maxMenuHeight;

///容器宽度
@property (assign, nonatomic) CGFloat containerWidth;

/// 数据
@property (retain, nonatomic) id data;

/// 选中 如果需要选中回填需要实现
@property (retain, nonatomic) id selection;

/// 动画时间  当子视图需要动画需要实现
@property (assign,nonatomic) CGFloat duration;

/// 高度限制 可以是行数也可以是高度
@property (assign, nonatomic) NSNumber * limit;

///容器之前大小
@property (assign, nonatomic) CGSize forwardContainerHeight;

/// 完成回调
@property (copy, nonatomic) FFDropMenuActionBlock actionBlock;


/// 设置下拉菜单
- (void)setUpDropMenu;

/// 获取自定义菜单高度
- (CGFloat)menuHeight;

@end

