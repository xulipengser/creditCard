//
//  ViewControllerEx.m
//  CreditCard
//
//  Created by 廖智尧 on 2018/3/28.
//  Copyright © 2018年 廖智尧. All rights reserved.
//

#import "ViewControllerEx.h"

@implementation UIViewController(MethodChange)

+(void)load{
    Method otherMethod = class_getInstanceMethod([UIViewController class], @selector(viewWillAppear:));
    Method myMethod = class_getInstanceMethod([UIViewController class], @selector(MyViewWillAppear:));
    method_exchangeImplementations(otherMethod, myMethod);
}

- (void)MyViewWillAppear:(BOOL)animated{
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:NULL action:NULL];
    [self MyViewWillAppear:animated];
}

@end
