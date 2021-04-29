//
//  CustomMenu.m
//  FFDropMenuExample
//
//  Created by North on 2021/4/21.
//

#import "CustomMenu.h"

@interface CustomMenu ()

@property (assign, nonatomic) CGFloat currentHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headHeight;

@end

@implementation CustomMenu

- (void)setUpDropMenu{
    
    self.currentHeight = MIN(300, self.maxMenuHeight);
    
    if (self.forwardContainerHeight > self.currentHeight) {
        self.headHeight.constant = self.forwardContainerHeight - 50;
    }
    
    [self setNeedsUpdateConstraints];
    [self layoutIfNeeded];
    
    [UIView animateWithDuration:self.duration animations:^{
        self.headHeight.constant = self.currentHeight - 50;
        [self layoutIfNeeded];
    }];
    
}


- (CGFloat)menuHeight{
    return self.currentHeight;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    self.currentHeight = MIN(arc4random() % 400 + 150, self.maxMenuHeight);
    
    [UIView animateWithDuration:self.duration animations:^{
        self.headHeight.constant = self.currentHeight - 50;
        [self layoutIfNeeded];
    }];
    
    if (self.actionBlock)self.actionBlock(FFDropMenuActionChangeHeight, @(self.currentHeight));
}


@end
