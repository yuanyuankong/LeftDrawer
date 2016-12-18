//
//  RootViewController.m
//  LeftDrawer
//
//  Created by 柴胡 on 16/12/15.
//  Copyright © 2016年 jyk. All rights reserved.
//

#import "RootViewController.h"
#import "LeftMenuView.h"

@interface RootViewController () <LeftMenuViewDelegate>
{
    UIButton *leftBtn;
}
@property (nonatomic, strong) LeftMenuView *menuView;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupNavView];
    if (self.menuView) {
        [self.menuView removeFromSuperview];
        self.menuView = nil;
    }
    self.menuView = [[LeftMenuView ShareManager] initWithContainerViewController:self];
    self.menuView.menuViewDelegate = self;
    
    //NSLog(@"----LeftMenuView0---- %@",self.menuView);
    [self.navigationController.view addSubview:self.menuView];
}

- (void)setupNavView{
    
    leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setFrame:CGRectMake(0, 0, 30, 30)];
    leftBtn.layer.cornerRadius =15;
    leftBtn.layer.masksToBounds = YES;
    
    leftBtn.layer.borderWidth = 1;
    leftBtn.layer.borderColor = [[UIColor colorWithRed:0.698 green:0.698 blue:0.698 alpha:1.0] CGColor];
//    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    //NSString  *str = @"http://imgsrc.baidu.com/forum/pic/item/e742fb3f8794a4c299b95cf90ef41bd5af6e3990.jpg";
//    NSString *str = [UICKeyChainStore stringForKey:@"1kf_avatar" service:ServiceKey];
//    [manager downloadImageWithURL:[NSURL URLWithString:str] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
//    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
//        [leftBtn setImage:image forState:UIControlStateNormal];
//    }];
    [leftBtn setImage:[UIImage imageNamed:@"dog.jpg"] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    [leftBtn addTarget:self action:@selector(OpenLeftMenuView) forControlEvents:UIControlEventTouchUpInside];
    
    // [self addRightBtn];
}

- (void)OpenLeftMenuView{
    
    NSLog(@"OpenLeftMenuView");
    
    if (self.menuView.isLeftViewHidden) {
        [self.menuView openLeftView];
    }
}

#pragma mark - LeftMenuViewDelegate
- (void)LeftMenuViewActionIndex:(NSMutableDictionary *)vType{
    NSString *key = [[vType allKeys] objectAtIndex:0];
    NSString *value = [[vType allValues] objectAtIndex:0];
    NSLog(@"%@ = %@", key, value);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
