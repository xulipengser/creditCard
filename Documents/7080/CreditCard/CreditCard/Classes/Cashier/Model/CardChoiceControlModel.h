//
//  CardChoiceControlModel.h
//  CreditCard
//
//  Created by cass on 2018/3/24.
//  Copyright © 2018年 廖智尧. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CardChoiceControlModel : NSObject
@property (nonatomic) CardType cardType;
@property (nonatomic, strong) NSString *cardTitle;
@property (nonatomic, strong) NSString *cardName;
@property (nonatomic, strong) NSString *cardNumber;
@property (nonatomic, strong) NSString *cardImageUrl;
@end
