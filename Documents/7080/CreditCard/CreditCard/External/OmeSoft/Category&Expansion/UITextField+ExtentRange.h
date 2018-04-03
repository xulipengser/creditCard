//
//  UITextField+ExtentRange.h
//  Hypnotist
//
//  Created by OMESOFT-05 on 15/12/7.
//  Copyright © 2015年 Omesoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (ExtentRange)
- (NSRange) selectedRange;
- (void) setSelectedRange:(NSRange) range;
@end
