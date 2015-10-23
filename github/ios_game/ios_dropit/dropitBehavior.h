//
//  dropitBehavior.h
//  dropit
//
//  Created by wangdongfang on 14-9-18.
//  Copyright (c) 2014年 _. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface dropitBehavior : UIDynamicBehavior

-(void)addItem:(id<UIDynamicItem>)item;
-(void)removeItem:(id<UIDynamicItem>)item;

@end
