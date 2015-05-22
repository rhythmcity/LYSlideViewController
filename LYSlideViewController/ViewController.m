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
#define SCREENWIDTH         [UIScreen mainScreen].bounds.size.width
#define PROPORTION          0.8
#define MAXDISTANCE         0.8
#import "ViewController.h"

@interface ViewController ()
{
    
    UIImageView *imageview ;
    UIScreenEdgePanGestureRecognizer * _screenEdgePan;
    UIPanGestureRecognizer *_pan;
    
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
        _screenEdgePan = [[UIScreenEdgePanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
        _screenEdgePan.edges = UIRectEdgeLeft;
        [mainControl.view addGestureRecognizer:_screenEdgePan];
        
        
        _pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        _pan.enabled  = NO;
        [mainControl.view addGestureRecognizer:_pan];
        
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
    
    scalef = (point.x+scalef);
    
    //根据视图位置判断是左滑还是右边滑动
    
    if (rec.view.frame.origin.x>=0){
        
        scalef = scalef>CriticalValue?CriticalValue:scalef;
        if (scalef <CriticalValue) {
            
            CGFloat pro = -scalef/SCREENWIDTH;
            pro*= 1-PROPORTION;
            pro/= MAXDISTANCE + PROPORTION/2-0.5;
            pro += 1;
            if (pro <= PROPORTION) {
                return;
            }
    
            rec.view.center = CGPointMake(self.view.center.x + scalef>MainShowLeftCenter?MainShowLeftCenter:self.view.center.x + scalef,rec.view.center.y);
            
            rec.view.transform = CGAffineTransformScale(CGAffineTransformIdentity,pro,pro);
            
            
            [rec setTranslation:CGPointMake(0, 0) inView:self.view];
            
            
            CGFloat leftPro = 1-pro +PROPORTION;

            leftControl.view.transform = CGAffineTransformScale(CGAffineTransformIdentity,leftPro,leftPro);
            
            leftControl.view.center = CGPointMake(LeftHiddenCenter + scalef>NomalCenter?NomalCenter:LeftHiddenCenter + scalef, [UIScreen mainScreen].bounds.size.height/2);
            
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
        
        leftControl.view.transform = CGAffineTransformScale(CGAffineTransformIdentity,1,1);
        leftControl.view.center = CGPointMake(NomalCenter, [UIScreen mainScreen].bounds.size.height/2);
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
    _pan.enabled = NO;
    [UIView beginAnimations:nil context:nil];
    mainControl.view.transform = CGAffineTransformScale(CGAffineTransformIdentity,1.0,1.0);
    mainControl.view.center = CGPointMake(NomalCenter,[UIScreen mainScreen].bounds.size.height/2);
    leftControl.view.transform = CGAffineTransformScale(CGAffineTransformIdentity,0.80,0.80);
    leftControl.view.center = CGPointMake(LeftHiddenCenter, [UIScreen mainScreen].bounds.size.height/2);
    [UIView commitAnimations];
}

//显示左视图
-(void)showLeftView{
    _pan.enabled = YES;
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
