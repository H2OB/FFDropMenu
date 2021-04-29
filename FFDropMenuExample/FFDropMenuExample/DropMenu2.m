//
//  DropMenu2.m
//  FFDropMenuExample
//
//  Created by North on 2021/4/25.
//

#import "DropMenu2.h"

@interface DropMenu2 ()<UITableViewDelegate, UITableViewDataSource>

@property (retain, nonatomic) UITableView * tableView;

@end

@implementation DropMenu2

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setUpView];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder{
    
    self = [super initWithCoder:coder];
    
    if (self) {
        [self setUpView];
    }
    
    return self;
}

- (void)setUpView{
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, .1)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorInset = UIEdgeInsetsZero;
    [self addSubview:self.tableView];
    
}

- (void)setUpDropMenu{
    
    self.tableView.frame = CGRectMake(0, 0, self.containerWidth, [self menuHeight]);
    
    [self.tableView reloadData];
    
}


- (CGFloat)menuHeight{
    
    return 44.0 * 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.textLabel.text = @(indexPath.row).stringValue;
    
    return cell;
}


@end
