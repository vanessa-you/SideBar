//
//  MainTabBarController.m
//  隐藏的侧栏
//
//  Created by iosDev on 16/10/24.
//  Copyright © 2016年 iosDev. All rights reserved.
//

#import "MainTabBarController.h"
#import "OneViewController.h"
#import "TwoViewController.h"
#import "ThreeViewController.h"
#import "FourViewController.h"
#import "LeftView.h"

// 侧边栏的宽度
#define LEFT_WIDTH 100

@interface MainTabBarController ()<LeftViewDelegate>

@property(nonatomic, strong) LeftView *lefeView;
@property(nonatomic, strong) UIView *bgView;
@property (assign, nonatomic,getter=isHidden)  BOOL hidden;
// tabBar 的标题+图片字典数组
@property(nonatomic, strong) NSMutableArray *tabItems;

@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // init child vc
    NSMutableArray *array = [NSMutableArray array];
    OneViewController *onevc = [[OneViewController alloc] init];
    TwoViewController *twovc = [[TwoViewController alloc] init];
    ThreeViewController *threevc = [[ThreeViewController alloc] init];
    FourViewController *fourvc = [[FourViewController alloc] init];
    
    [self setUpChildViewController:onevc array:array title:@"话题" imageName:@"tabbar_topic" selectImageName:@"tabbar_topic_selected"];
    [self setUpChildViewController:twovc array:array title:@"材料" imageName:@"tabbar_material" selectImageName:@"tabbar_material_selected"];
    [self setUpChildViewController:threevc array:array title:@"表单" imageName:@"tabbar_form" selectImageName:@"tabbar_form_selected"];
    [self setUpChildViewController:fourvc array:array title:@"更多" imageName:@"tabbar_more" selectImageName:@"tabbar_more_selected"];
    
    self.viewControllers = array;
    self.selectedIndex = 0;
    self.hidden = YES;
    
    // ori tabbar set nil ......
    [self setValue:nil forKeyPath:@"tabBar"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)setUpChildViewController:(UIViewController *)viewController array:(NSMutableArray *)array title:(NSString *)title imageName:(NSString *)imageName selectImageName:(NSString *)selectImageName
{
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:viewController];
    viewController.view.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1.0];
    viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"item.png"] style:UIBarButtonItemStylePlain target:self action:@selector(tabHiddenOrShow)];
    [array addObject:navVC];
    
    NSDictionary *dict = @{@"title":title,
                           @"image":imageName,
                           @"selectImage":selectImageName
                           };
    [self.tabItems addObject:dict];
}

- (void)tabHiddenOrShow
{
    [self.tabBarController.tabBar setHidden:YES];
    self.hidden = !self.isHidden;
    
    if (self.lefeView == nil) {
        self.lefeView = [[LeftView alloc] initWithFrame:CGRectMake(-LEFT_WIDTH, 0, LEFT_WIDTH, [UIScreen mainScreen].bounds.size.height)];
        self.lefeView.delegate = self;
        self.lefeView.itemArray = self.tabItems;
        [[UIApplication sharedApplication].keyWindow addSubview:self.lefeView];
    }
    if (self.bgView == nil) {
        self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        self.bgView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.5];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
        [self.bgView addGestureRecognizer:tap];
    }
    
    CGRect leftFrame = self.lefeView.frame;
    if (self.isHidden == YES) {
        leftFrame.origin.x = -LEFT_WIDTH;
        [self.bgView removeFromSuperview];
    } else {
        [[UIApplication sharedApplication].keyWindow insertSubview:self.bgView belowSubview:self.lefeView];
        leftFrame.origin.x = 0;
    }
    [UIView animateWithDuration:0.5 animations:^{
        self.lefeView.frame = leftFrame;
        [self.view setNeedsLayout];
    }];
}

- (void)tapClick:(UITapGestureRecognizer *)tap
{
    [self tabHiddenOrShow];
}


#pragma mark - LeftViewDelegate
-(void)didClickChildButton:(int)selectedIndex
{
    self.selectedIndex = selectedIndex;
    [self tabHiddenOrShow];
}


#pragma mark - set & get
-(NSMutableArray *)tabItems
{
    if (_tabItems == nil) {
        _tabItems = [NSMutableArray array];
    }
    return _tabItems;
}

@end
