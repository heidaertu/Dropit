//
//  dropitViewController.m
//  dropit
//
//  Created by wangdongfang on 14-9-18.
//  Copyright (c) 2014年 _. All rights reserved.
//

#import "dropitViewController.h"
#import "dropitBehavior.h"

@interface dropitViewController () <UIDynamicAnimatorDelegate> // saying that we have implemented the protol.
@property (weak, nonatomic) IBOutlet UIView *gameView; //the top view in which the game put
@property (strong,nonatomic)UIDynamicAnimator* animator;
@property (strong,nonatomic)dropitBehavior* dropitBehaviors;
@end

@implementation dropitViewController

static const CGSize DROP_SIZE = {40,40};

-(void)dynamicAnimatorDidPause:(UIDynamicAnimator *)animator
{
    [self removeCompletedRows];
}

-(BOOL)removeCompletedRows
{
    NSMutableArray * dropsToRemove = [[NSMutableArray alloc]init];
    
    for(int y = self.gameView.bounds.size.height - DROP_SIZE.height/2;y>0;y-=DROP_SIZE.height)
    {
        BOOL  isRowCompleted = YES;
        NSMutableArray* dropFound = [[NSMutableArray alloc]init];
        for(int x = self.gameView.bounds.size.width - DROP_SIZE.width/2;x>0;x-=DROP_SIZE.width)
        {
            UIView * hitView = [self.gameView hitTest:CGPointMake(x, y) withEvent:NULL];
            if([hitView superview]==self.gameView)
            {
                [dropFound addObject:hitView];
                NSLog(@"add one");
            }
            else
            {
                isRowCompleted = NO;
                break;
            }
        }
        if(![dropFound count])break;
        if(isRowCompleted){[dropsToRemove addObjectsFromArray:dropFound];}
    }
    if([dropsToRemove count])
    {
        for(UIView* drop in dropsToRemove)
        {
            [self.dropitBehaviors removeItem:drop]; /* remove the drops which going to blow up from the animator. so they won't affect from the animator. */
        }
        [self animateRemovingDrops:dropsToRemove];
    }
    return NO;
}
-(void)animateRemovingDrops:(NSArray*)dropsToRemove /* blow up the drops which filled in a row. */
{
    [UIView animateWithDuration:0.5 // second
                     animations:^{
                         for(UIView* drop in dropsToRemove)
                         {
                             int x = (arc4random()% (int)self.gameView.bounds.size.width*5) - (int)self.gameView.bounds.size.width*2;
                             // x from -2* self.gameView.bounds.size.width to 2* self.gameView.bounds.size.width
                             
                             int y = self.gameView.bounds.size.height;
                             
                             drop.center = CGPointMake(x, -y); /* change the center will automatically animate*/
                         }
                     } completion:^(BOOL finished){
                         [dropsToRemove makeObjectsPerformSelector:@selector(removeFromSuperview)];
                     }];
}
-(UIDynamicAnimator*)animator
{
    if(!_animator)
    {
        _animator = [[UIDynamicAnimator alloc]initWithReferenceView:self.gameView];
        _animator.delegate = self;
    }
    return _animator;
}
-(dropitBehavior*)dropitBehaviors
{
    if(!_dropitBehaviors)
    {
        _dropitBehaviors = [[dropitBehavior alloc]init]; /* in the init function, add sub-behavior into the group of behaviors */
        [self.animator addBehavior:_dropitBehaviors]; /* add the behaviors into animator */
    }
    return _dropitBehaviors;
}
- (IBAction)tap:(UITapGestureRecognizer *)sender {
    [self drop];
}
-(void)drop /*creat the drop-rectangle-view.*/
{
    /*create the frame of the drop-rectangle. */
    CGRect frame;
    frame.origin = CGPointZero;
    frame.size = DROP_SIZE;
    int x = (arc4random()% (int)self.gameView.bounds.size.width )/ DROP_SIZE.width;
    frame.origin.x = x * DROP_SIZE.width;
    
    /*create the view of the drop-rectangle. */
    UIView* dropView = [[UIView alloc]initWithFrame:frame];
    dropView.backgroundColor = [self randomColor];
    
    dropView.layer.borderColor = [UIColor blackColor].CGColor;
    dropView.layer.borderWidth = 0.5f;
    
    /*add the view of the drop-rectangle into the top view. */
    [self.gameView addSubview:dropView];
    [self.dropitBehaviors addItem:dropView]; /* add the item into the group of behaviors */
   
}
-(UIColor*)randomColor
{
    int color = arc4random()%5;
    switch(color)
    {
        case 0: return [UIColor yellowColor];break;
        case 1: return [UIColor greenColor];break;
        case 2:return [UIColor blueColor];break;
        case 3:return [UIColor purpleColor];break;
        case 4:return [UIColor orangeColor];break;
    }
    return [UIColor yellowColor];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}
@end
