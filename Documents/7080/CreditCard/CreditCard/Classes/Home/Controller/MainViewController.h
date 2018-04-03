//
//  MainViewController.h
//  CreditCard
//
//  Created by 廖智尧 on 2018/2/9.
//  Copyright © 2018年 廖智尧. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MyHeaderView;
@class MyFooterView;

@interface MainViewController : UIViewController
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

//@property (weak, nonatomic) IBOutlet MyHeaderView *headerView;
//@property (weak, nonatomic) IBOutlet MyFooterView *footerView;

@end
