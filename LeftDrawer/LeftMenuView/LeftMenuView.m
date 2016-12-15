//
//  AppDelegate.h
//  QQ侧滑菜单Demo
//
//  Created by MCL on 16/7/13.
//  Copyright © 2016年 CHLMA. All rights reserved.
//

#import "LeftMenuView.h"
#import "Header.h"

@interface LeftMenuView()<UIGestureRecognizerDelegate, UIActionSheetDelegate>
//required
@property (nonatomic, strong) UIViewController *ContainerVC;
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, assign) CGFloat width;
//自定义视图
@property (nonatomic, strong) UIView *topBlackView;
@property (nonatomic, strong) UIButton *headButton;
@property (nonatomic, strong) UIImageView *headImage;
@property (nonatomic, strong) UILabel *usrAccountLabel;
@property (nonatomic, strong) UILabel *VersionLabel;
@property (nonatomic, strong) UILabel *rightIconLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIButton *addButton;
@property (nonatomic, strong) UILabel *addDeviceNotify;
@property (nonatomic, assign) BOOL isswipright;
@end

@implementation LeftMenuView

NSInteger menuViewWith = 290;
//Objective-C中的单例
static LeftMenuView *menuView = nil;
+ (instancetype)ShareManager{
    
    LOG_METHOD;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        menuView = [[self alloc] initWithFrame:CGRectMake(- menuViewWith, 0, menuViewWith, ScreenHeight)];
    });
    return menuView;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    LOG_METHOD;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        menuView = [super allocWithZone:zone];
    });
    return menuView;
}

- (instancetype)initWithContainerViewController:(UIViewController *)containerVC{
    LOG_METHOD;
    if (self = [super init]) {
        self.width = ScreenWidth / 2;
        _ContainerVC = containerVC;
        self.isLeftViewHidden = YES;
        _maskView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _maskView.backgroundColor = [UIColor colorWithRed:0.5333 green:0.5333 blue:0.5333 alpha:1.0];
        _maskView.hidden = YES;
        [_ContainerVC.view addSubview:_maskView];
        [self addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
        [self addRecognizer];

    }
    
    return self;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"frame"]) {
        CGRect new = [change[@"new"] CGRectValue];
        CGFloat x = new.origin.x;
        if (x != - menuViewWith) {
            _maskView.hidden = NO;
            _maskView.alpha = (x + menuViewWith)/menuViewWith*0.5;
        }else
        {
            _maskView.hidden = YES;
        }
    }
}

#pragma mark - UIPanGestureRecognizer
-(void)addRecognizer{
    
    UIPanGestureRecognizer *pan=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(didPanEvent:)];
    pan.delegate = self;
    [_ContainerVC.view addGestureRecognizer:pan];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeLeftViewEvent:)];
    [_maskView addGestureRecognizer:tap];

}

-(void)closeLeftViewEvent:(UITapGestureRecognizer *)recognizer{
    
    [self closeLeftView];
}

-(void)didPanEvent:(UIPanGestureRecognizer *)recognizer{
    
    CGPoint translation = [recognizer translationInView:_ContainerVC.view];
    NSLog(@"translation.x == %f", translation.x);
    [recognizer setTranslation:CGPointZero inView:_ContainerVC.view];
    
   
    
    if(UIGestureRecognizerStateBegan == recognizer.state ||
       UIGestureRecognizerStateChanged == recognizer.state){
        
        if (translation.x > 0 ) {//SwipRight
            _isswipright = YES;
//            if (self.bounds.origin.x == 0) {
//                return;
//            }
//            CGFloat tempX = self.bounds.origin.x + translation.x;
//            if (tempX <= 0) {
//                
//                self.frame = CGRectMake(tempX, 0, menuViewWith, SCREEN_HEIGHT);
//                
//            }else{
//                
//                self.frame = CGRectMake(0, 0, menuViewWith, SCREEN_HEIGHT);
//            }
            
            
        }else if (translation.x < 0){//SwipLeft
//            
//            CGFloat tempX = self.bounds.origin.x + translation.x;
//            self.frame = CGRectMake(tempX, 0, menuViewWith, SCREEN_HEIGHT);
            _isswipright = NO;
        }
        
    }else{
        NSLog(@"shoushi ting zhi");
//
        NSLog(@"%i",_isswipright);
        
        if (_isswipright == YES) {
            if (self.bounds.origin.x >= - menuViewWith * 0.5) {
                
                [self openLeftView];
                
            }else{
                
                [self closeLeftView];
            }
        }
        else{
             [self closeLeftView];
        }

    }
}

/**
 *  关闭左视图
 */
- (void)closeLeftView{
    
    NSLog(@"closeLeftView");
    [UIView animateWithDuration:0.3 animations:^{
        
        self.frame = CGRectMake(- menuViewWith, 0, menuViewWith, ScreenHeight);
        self.isLeftViewHidden = YES;
        _maskView.hidden = YES;
    }];
    
}

- (void)openLeftView{
    
    //头像Button
    [_headImage setImage:[UIImage imageNamed:@"dog.jpg"]];
    //账户名称
    _usrAccountLabel.text = @"名称";
    //[self addSubview:_usrAccountLabel];
    
    NSLog(@"openLeftView");
    [UIView animateWithDuration:0.3 animations:^{
        
        self.frame = CGRectMake(0, 0, menuViewWith, ScreenHeight);
        self.isLeftViewHidden = NO;
    } completion:^(BOOL finished) {
        
        _maskView.hidden = NO;
        _maskView.alpha = 0.5;
    }];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    if ([otherGestureRecognizer.view isKindOfClass:[UITableView class]]) {
        
        return NO;
    }
    
    return YES;
}

#pragma mark - Private
-(instancetype)initWithFrame:(CGRect)frame{
    LOG_METHOD;
    if (self=[super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
        //背景view
        _topBlackView = [[UIView alloc] init];
       // _topBlackView.image = [UIImage imageNamed:@"leftmenu_topbg.jpg"];
        _topBlackView.backgroundColor = [UIColor whiteColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeHeaderImage)];
        [_topBlackView addGestureRecognizer:tap];
        [self addSubview:_topBlackView];
        
        //头像Button
        _headButton = [[UIButton alloc]init];
        _headButton.userInteractionEnabled = NO;
       // [_headButton addTarget:self action:@selector(changeHeaderImage) forControlEvents:UIControlEventTouchUpInside];
//        _headImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"leftmenu_topbg.jpg"]];
//        NSString *str = [UICKeyChainStore stringForKey:@"1kf_avatar" service:ServiceKey];
//        [_headImage sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"leftmenu_topbg.jpg"]];
        _headImage.layer.cornerRadius = 44;
        _headImage.layer.masksToBounds = YES;
        _headImage.layer.borderWidth = 1;
        _headImage.layer.borderColor = [[UIColor colorWithRed:0.6667 green:0.6667 blue:0.6667 alpha:1.0] CGColor];
        [self addSubview:_headButton];
        
        //账户名称
        _usrAccountLabel = [[UILabel alloc]init];
        _usrAccountLabel.text = @"昵称";
        _usrAccountLabel.textColor = [UIColor blackColor];
        _usrAccountLabel.font = [UIFont systemFontOfSize:15];
        _usrAccountLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_usrAccountLabel];
        
        
        //版本
        _VersionLabel = [[UILabel alloc]init];
        _VersionLabel.text = [NSString stringWithFormat:@"1.0.0"];
        _VersionLabel.textColor = [UIColor blackColor];
        _VersionLabel.font = [UIFont systemFontOfSize:15];
        _VersionLabel.textAlignment = NSTextAlignmentLeft;
        _VersionLabel.numberOfLines = 0;
        [self addSubview:_VersionLabel];
        
        //右边箭头
//        _rightIconLabel = [[UILabel alloc]init];
//        _rightIconLabel.font = [UIFont fontWithName:imagefont1 size:18];
//        _rightIconLabel.text = @"\U0000e807";
//        _rightIconLabel.textColor = RGBCOLOR(187, 190, 199);
////        _rightIconLabel.font = [UIFont systemFontOfSize:22];
//        _rightIconLabel.textAlignment = NSTextAlignmentRight;
//        [self addSubview:_rightIconLabel];
//        
        
        
        //线条
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = RGBCOLOR(61, 60, 68);
        [self addSubview:_lineView];
        //添加“+”按钮
        _addButton = [[UIButton alloc]init];
        [_addButton setImage:[UIImage imageNamed:@"leftmenu_add_nor"] forState:UIControlStateNormal];
        [_addButton setImage:[UIImage imageNamed:@"leftmenu_add_press"] forState:UIControlStateHighlighted];
        [_addButton setTitle:@"Add Button" forState:UIControlStateNormal];
        [_addButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [_addButton setTitleColor:RGBCOLOR(187, 190, 199) forState:UIControlStateNormal];
        [_addButton addTarget:self action:@selector(AddAction) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:_addButton];
        //tableview
        _menuTableView = [[LeftMenuTableView alloc]init];
        _menuTableView.backgroundColor = [UIColor whiteColor];
        __block LeftMenuView *blockSelf = self;
        _menuTableView.menuActionBlock = ^(NSMutableDictionary *name){
            
            if (blockSelf.menuViewDelegate) {
                [blockSelf.menuViewDelegate LeftMenuViewActionIndex:name];
            }
        };
        [self addSubview:_menuTableView];
        
        
    }
    //注册通知观察者（接受通知，将记录跳转界面的值从主控制器传过来）
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(UpdateUserData:) name:@"UpdateUserData" object:nil];
    return  self ;
}

- (void)layoutSubviews{
    
    CGRect rect = CGRectMake(20, 44, 88, 88);
    _headButton.frame = rect;
    _headImage.frame = CGRectMake(0, 0, 88, 88);
    [_headButton addSubview:_headImage];
    CGFloat marginX = 0;
    _usrAccountLabel.frame = CGRectMake(115, CGRectGetMaxY(_headButton.frame) + marginX-80, self.width/2, 22);
    _VersionLabel.frame = CGRectMake(115, CGRectGetMaxY(_headButton.frame) + marginX-48, self.width/2, 44);
    _rightIconLabel.frame = CGRectMake(self.width-32, CGRectGetMaxY(_headButton.frame) /2+10, 22, 22);
    
    _lineView.frame = CGRectMake(marginX, CGRectGetMaxY(_headButton.frame)+30, self.width - marginX * 2, 0.5);
    _topBlackView.frame = CGRectMake(0, 0, self.width, CGRectGetMaxY(_lineView.frame));
    CGFloat addBtnW = 30;
    _addButton.frame = CGRectMake(marginX, ScreenWidth - 25 - addBtnW, self.width - marginX * 2, addBtnW);
    [_addButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, addBtnW)];
    [_addButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    CGFloat tablView_top = CGRectGetMaxY(_lineView.frame) + marginX;
    CGFloat tableView_Bottom = CGRectGetMaxY(_addButton.frame)+42;
    _menuTableView.frame = CGRectMake(marginX, tablView_top, self.width - marginX * 2, tableView_Bottom - tablView_top);
}

- (void)UpdateUserData:(NSNotification *)notify{
    
    NSLog(@"UpdateUserData");
}

- (void)changeHeaderImage{
    
   // NSLog(@"changeHeaderImage");
//    HeadViewController *head = [[HeadViewController alloc] init];
//    [_ContainerVC.navigationController pushViewController:head animated:true];
//    [self closeLeftView];
}

- (void)AddAction{

    NSLog(@"AddAction");
    if (_menuViewDelegate) {
        [_menuViewDelegate LeftMenuViewActionIndex:nil];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self removeObserver:self forKeyPath:@"frame"];
}

@end
