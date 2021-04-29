//
//  ViewController.m
//  FFDropMenuExample
//
//  Created by North on 2021/4/20.
//

#import "ViewController.h"
#import "FFDropMenuView.h"
#import "CustomMenu.h"
#import "DropMenu2.h"
@interface ViewController ()

@property (retain, nonatomic) FFDropMenuView * dropMenu;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dropMenu = [FFDropMenuView initInView:self.view spacing:FFSpacingMake(230, 0) limit:@(5) cancelHeight:100 radius:10];
    self.dropMenu.duration = .2;
    CustomMenu * customMenu = [[UINib nibWithNibName:@"CustomMenu" bundle:[NSBundle mainBundle]] instantiateWithOwner:self options:nil].firstObject;
    [self.dropMenu registerMenu:customMenu identifier:@"customMenu"];
    
    
    DropMenu2 * dropMenu2 = [[DropMenu2 alloc] init];
    [self.dropMenu registerMenu:dropMenu2 identifier:@"dropMenu2"];
    
}

- (IBAction)butn1Action:(id)sender {
    
    self.dropMenu.radius = 0;
    [self.dropMenu showDropMenu:@"customMenu" data:nil selection:nil completion:^(FFDropMenuAction action, id result) {
        
    }];
    
}
- (IBAction)butn2Action:(id)sender {
    self.dropMenu.radius = 10;
    [self.dropMenu showDropMenu:@"dropMenu2" data:nil selection:nil completion:^(FFDropMenuAction action, id result) {
        
    }];
    
}
- (IBAction)butn3Action:(id)sender {
    self.dropMenu.radius = 20;
    [self.dropMenu showDropMenu:@"customMenu" data:nil selection:nil completion:^(FFDropMenuAction action, id result) {
        
    }];
    
}
- (IBAction)customBtnAction:(id)sender {
    self.dropMenu.radius = 0;
    [self.dropMenu showDropMenu:@"customMenu" data:nil selection:nil completion:^(FFDropMenuAction action, id result) {
        
    }];
}


@end
