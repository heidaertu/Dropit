//
//  dropitBehaviro.m
//  dropit
//
//  Created by wangdongfang on 14-9-18.
//  Copyright (c) 2014年 _. All rights reserved.
//

#import "dropitBehavior.h"

@interface dropitBehavior()
@property (strong,nonatomic)UIGravityBehavior* gravity;
@property (strong,nonatomic)UICollisionBehavior* collider;
@property (strong,nonatomic)UIDynamicItemBehavior * animationOptions;
@end

@implementation dropitBehavior



-(UIGravityBehavior*)gravity
{
    if(!_gravity)
    {
        _gravity = [[UIGravityBehavior alloc]init];
        _gravity.magnitude = 1.0;
    }
    return _gravity;
}
-(UICollisionBehavior*)collider
{
    if(!_collider)
    {
        _collider = [[UICollisionBehavior alloc]init];
        _collider.translatesReferenceBoundsIntoBoundary=YES;
    }
    return _collider;
}
-(UIDynamicItemBehavior*) animationOptions
{
    if(!_animationOptions)
    {
        _animationOptions = [[UIDynamicItemBehavior alloc]init];
        _animationOptions.allowsRotation = NO; /* do not allow the item rotate when they collide */
    }
    return _animationOptions;
}
-(void)addItem:(id<UIDynamicItem>)item /* add item into the behavior */
{
    [self.gravity addItem:item];
    [self.collider addItem:item];
    [self.animationOptions addItem:item];
}
-(void)removeItem:(id<UIDynamicItem>)item
{
    [self.gravity removeItem:item];
    [self.collider removeItem:item];
    [self.animationOptions removeItem:item];
}

-(instancetype)init
{
    self = [super init];
    [self addChildBehavior:self.gravity];  /* add sub-behavior */
    [self addChildBehavior:self.collider];
    [self addChildBehavior:self.animationOptions];
    return self;
}
@end
