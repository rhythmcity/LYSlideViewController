//
//  ViewController.m
//  LYSlideViewController
//
//  Created by 李言 on 14/11/5.
//  Copyright (c) 2014年 ___李言___. All rights reserved.
//


#define NomalCenter         [UIScreen mainScreen].bounds.size.width/2
#define LeftHiddenCenter   -[UIScreen mainScreen].bounds.size.width/5
#define MainShowLeftCenter  [UIScreen mainScreen].bounds.size.width*6/5
#define CriticalValue       [UIScreen mainScreen].bounds.size.width*4/5
#define AutoSlideValue      [UIScreen mainScreen].bounds.size.width*2/5
#import "ViewController.h"

@interface ViewController ()
{
    
    UIImageView *imageview ;
    
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(instancetype)initWithLeftView:(UIViewController *)LeftView
                    andMainView:(UIViewController *)MainView
                   andRightView:(UIViewController *)RighView
             andBackgroundImage:(UIImage *)image;
{
    if(self){
       
        
        leftControl = LeftView;
        mainControl = MainView;
        righControl = RighView;
        
        UIImageView * imgview = [[UIImageView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        [imgview setImage:image];
        imageview.backgroundColor = [UIColor blackColor];
        imageview.opaque = NO;
        imageview =imgview;
        [self.view addSubview:imageview];
        
        //滑动手势
        UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
        [mainControl.view addGestureRecognizer:pan];
        
        
        //单击手势
        _sideslipTapGes= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handeTap:)];
        [_sideslipTapGes setNumberOfTapsRequired:1];
        
        [mainControl.view addGestureRecognizer:_sideslipTapGes];
        
        leftControl.view.hidden = YES;
        righControl.view.hidden = YES;
        leftControl.view.transform = CGAffineTransformScale(CGAffineTransformIdentity,0.80,0.80);
        leftControl.view.center = CGPointMake(LeftHiddenCenter, [UIScreen mainScreen].bounds.size.height/2);
        self.view.backgroundColor = [UIColor blackColor];
        [self.view addSubview:leftControl.view];
        [self.view addSubview:righControl.view];
        
        [self.view addSubview:mainControl.view];
        
    }
    return self;
}



#pragma mark - 滑动手势

//滑动手势
- (void) handlePan: (UIPanGestureRecognizer *)rec{
    
    CGPoint point = [rec translationInView:self.view];
    
    //CGPoint speed = [rec velocityInView: self.view];
    scalef = (point.x+scalef);
    
    //根据视图位置判断是左滑还是右边滑动
    NSLog(@"%f,,,,,%f",scalef,point.x);
    
    if (rec.view.frame.origin.x>=0){
        
        scalef = scalef>CriticalValue?CriticalValue:scalef;
        if (scalef <CriticalValue) {
            
            
            rec.view.center = CGPointMake(rec.view.center.x + point.x>MainShowLeftCenter?MainShowLeftCenter:rec.view.center.x + point.x,rec.view.center.y);
            
            rec.view.transform = CGAffineTransformScale(CGAffineTransformIdentity,(1-scalef/1280),(1-scalef/1280));
            [rec setTranslation:CGPointMake(0, 0) inView:self.view];
            
            leftControl.view.transform = CGAffineTransformScale(CGAffineTransformIdentity,0.8+scalef/1280,0.8+scalef/1280);
            
            leftControl.view.center = CGPointMake(leftControl.view.center.x + point.x>NomalCenter?NomalCenter:leftControl.view.center.x + point.x, [UIScreen mainScreen].bounds.size.height/2);
            
            righControl.view.hidden = YES;
            leftControl.view.hidden = NO;
            
            leftControl.view.alpha =scalef/140;
            
            imageview.alpha = scalef/140;
        }else{
            
            [self showLeftView];
        }
    }
    else
    {
        rec.view.center = CGPointMake(rec.view.center.x + point.x,rec.view.center.y);
        rec.view.transform = CGAffineTransformScale(CGAffineTransformIdentity,1+scalef/1000,1+scalef/1000);
        [rec setTranslation:CGPointMake(0, 0) inView:self.view];
        
        
        righControl.view.hidden = NO;
        leftControl.view.hidden = YES;
        
        righControl.view.alpha =-scalef/140;
        imageview.alpha = -scalef/140;
    }
    
    
    
    
    //手势结束后修正位置
    if (rec.state == UIGestureRecognizerStateEnded) {
        if (scalef>AutoSlideValue){
            [self showLeftView];
        }
        else if (scalef<-AutoSlideValue) {
            [self showRighView];        }
        else
        {
            [self showMainView];
            scalef = 0;
        }
    }
    
}


#pragma mark - 单击手势
-(void)handeTap:(UITapGestureRecognizer *)tap{
    
    if (tap.state == UIGestureRecognizerStateEnded) {
        
        [self showMainView];
        [UIView beginAnimations:nil context:nil];
        //        tap.view.transform = CGAffineTransformScale(CGAffineTransformIdentity,1.0,1.0);
        //        tap.view.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2,[UIScreen mainScreen].bounds.size.height/2);
        [UIView commitAnimations];
        scalef = 0;
        
    }
    
}

#pragma mark - 修改视图位置
//恢复位置
-(void)showMainView{
    [UIView beginAnimations:nil context:nil];
    mainControl.view.transform = CGAffineTransformScale(CGAffineTransformIdentity,1.0,1.0);
    mainControl.view.center = CGPointMake(NomalCenter,[UIScreen mainScreen].bounds.size.height/2);
    leftControl.view.transform = CGAffineTransformScale(CGAffineTransformIdentity,0.80,0.80);
    leftControl.view.center = CGPointMake(LeftHiddenCenter, [UIScreen mainScreen].bounds.size.height/2);
    [UIView commitAnimations];
}

//显示左视图
-(void)showLeftView{
    [UIView beginAnimations:nil context:nil];
    mainControl.view.transform = CGAffineTransformScale(CGAffineTransformIdentity,0.8,0.8);
    mainControl.view.center = CGPointMake(MainShowLeftCenter,[UIScreen mainScreen].bounds.size.height/2);
    
    leftControl.view.transform = CGAffineTransformScale(CGAffineTransformIdentity,1,1);
    leftControl.view.center = CGPointMake(NomalCenter, [UIScreen mainScreen].bounds.size.height/2);
    [UIView commitAnimations];
    
}

//显示右视图
-(void)showRighView{
    [UIView beginAnimations:nil context:nil];
    mainControl.view.transform = CGAffineTransformScale(CGAffineTransformIdentity,0.8,0.8);
    mainControl.view.center = CGPointMake(LeftHiddenCenter,[UIScreen mainScreen].bounds.size.height/2);
    
    leftControl.view.hidden = YES;
    [UIView commitAnimations];
}


@end
