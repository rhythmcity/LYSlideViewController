//
//  ViewController.h
//  LYSlideViewController
//
//  Created by 李言 on 14/11/5.
//  Copyright (c) 2014年 ___李言___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController{

    UIViewController * leftControl;
    UIViewController * mainControl;
    UIViewController * righControl;
    
    UIImageView * imgBackground;
    
    CGFloat scalef; //实际滑动距离


}




@property (strong) UITapGestureRecognizer *sideslipTapGes;

//初始化
-(instancetype)initWithLeftView:(UIViewController *)LeftView
                    andMainView:(UIViewController *)MainView
                   andRightView:(UIViewController *)RighView
             andBackgroundImage:(UIImage *)image;


//恢复位置
-(void)showMainView;

//显示左视图
-(void)showLeftView;

//显示右视图
-(void)showRighView;



@end

