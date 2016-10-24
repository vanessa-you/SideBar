//
//  LeftView.m
//  隐藏的侧栏
//
//  Created by iosDev on 16/10/24.
//  Copyright © 2016年 iosDev. All rights reserved.
//

#import "LeftView.h"

#define VIEW_WIDTH self.bounds.size.width
#define VIEW_HEIGHT self.bounds.size.height

@interface LeftView()

@property(nonatomic, strong) UIButton *selectedButton;

@end

@implementation LeftView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}

- (void)setUp
{
    self.backgroundColor = [UIColor whiteColor];
}

- (void)setItemArray:(NSArray *)itemArray
{
    _itemArray = itemArray;
    int n = 0;
    for (NSDictionary *dict in itemArray) {
        TabButton *button = [TabButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:dict[@"title"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:dict[@"image"]] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:dict[@"selectImage"]] forState:UIControlStateSelected];
        button.tag = 999 + n;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        // 默认第一个按钮点击,跟tabbarController默认选中的控制器index一致
        if (n == 0) {// 0
            self.selectedButton = button;
            self.selectedButton.selected = YES;
        }
        n ++;
    }
}

- (void)buttonClick:(UIButton *)button
{
    int tag = (int)button.tag - 999;
    NSLog(@"点击了%d个按钮",tag);
    if ([self.delegate respondsToSelector:@selector(didClickChildButton:)]) {
        [self.delegate didClickChildButton:tag];
        self.selectedButton.selected = NO;
        self.selectedButton = button;
        self.selectedButton.selected = YES;
    }
}

-(void)layoutSubviews
{
    CGFloat height = [UIScreen mainScreen].bounds.size.height / 4;
    
    for (UIView *child in self.subviews) {
        Class class = NSClassFromString(@"UIButton");
        if ([child isKindOfClass:class]) {
            int tag = (int)child.tag - 999;
            child.frame = CGRectMake(0, height * tag, VIEW_WIDTH, height);
        }
    }
}

@end

#pragma mark - 自定义tabBar按钮
@implementation TabButton

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.imageView.frame = CGRectMake(0, VIEW_HEIGHT * 0.1, VIEW_WIDTH, VIEW_HEIGHT * 0.5);
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.titleLabel.frame = CGRectMake(0, VIEW_HEIGHT * 0.6, VIEW_WIDTH, VIEW_HEIGHT * 0.2);
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    
}

@end

