//
//  LeftView.h
//  隐藏的侧栏
//
//  Created by iosDev on 16/10/24.
//  Copyright © 2016年 iosDev. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LeftViewDelegate <NSObject>
/**
 点击侧边栏按钮调用方法(必写)

 @param selectedIndex 按钮tag
 */
@required
- (void)didClickChildButton:(int)selectedIndex;

@end

@interface LeftView : UIView

@property(nonatomic, strong) NSArray *itemArray;
@property(nonatomic, strong) id <LeftViewDelegate>delegate;

@end

@interface TabButton : UIButton

@end
