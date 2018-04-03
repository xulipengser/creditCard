//
//  MapVC.h
//  StarCityUnion
//
//  Created by 廖智尧 on 2017/11/25.
//  Copyright © 2017年 廖智尧. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NBLWebViewController.h"

@interface MapVC : NBLWebViewController
@property (nonatomic) NSInteger type;
@property(nonatomic, strong) NSString *userID;
@end
