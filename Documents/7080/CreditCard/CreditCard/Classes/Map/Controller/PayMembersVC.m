//
//  PayMembersVC.m
//  CreditCard
//
//  Created by 廖智尧 on 2018/3/31.
//  Copyright © 2018年 廖智尧. All rights reserved.
//

#import "PayMembersVC.h"

@interface PayMembersVC ()

@end

@implementation PayMembersVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"会员支付";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)successAction:(NSString*)title{
    NSLog(@"a");
    if ([title isEqualToString:@"CloseView"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:UserInfoChangeNotification object:nil];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
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
