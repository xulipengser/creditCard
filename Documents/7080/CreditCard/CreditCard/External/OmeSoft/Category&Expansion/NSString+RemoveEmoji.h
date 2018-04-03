//
//  NSString+RemoveEmoji.h
//  Hypnotist
//
//  Created by 彭俊华 on 15/2/12.
//
//

#import <Foundation/Foundation.h>

@interface NSString (NSString_RemoveEmoji)
- (BOOL)isIncludingEmoji;
- (instancetype)removedEmojiString;
@end
