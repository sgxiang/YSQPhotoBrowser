//
//  ViewController.m
//  YSQPhotoBrowserTest
//
//  Created by ysq on 14/8/22.
//  Copyright (c) 2014年 ysq. All rights reserved.
//

#import "ViewController.h"
#import "YSQPhotoBrowserViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageOne;

@property (weak, nonatomic) IBOutlet UIImageView *imageTwo;
@property (weak, nonatomic) IBOutlet UIImageView *imageThree;

@property(nonatomic,strong) NSMutableArray *photos;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.photos = [NSMutableArray arrayWithCapacity:3];
    [self.photos addObject:self.imageOne.image];
    [self.photos addObject:self.imageTwo.image];
    [self.photos addObject:self.imageThree.image];

    UITapGestureRecognizer *tapOne = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewImage:)];
    [self.imageOne addGestureRecognizer:tapOne];
    UITapGestureRecognizer *tapTwo = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewImage:)];
    [self.imageTwo addGestureRecognizer:tapTwo];
    UITapGestureRecognizer *tapThree = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewImage:)];
    [self.imageThree addGestureRecognizer:tapThree];
    
}

-(void)viewImage:(UITapGestureRecognizer *)sender{
    
    NSInteger tag = sender.view.tag;
    __weak ViewController *that = self;
    YSQPhotoBrowserViewController *browser = [[YSQPhotoBrowserViewController alloc]initWithPhotos:self.photos selectIndex:tag finish:^{
        [that reloadImage];
    }];
    [self.navigationController pushViewController:browser animated:YES];
    
}

-(void)reloadImage{
    NSInteger count = [self.photos count];
    self.imageOne.image = count>0?self.photos[0]:nil;
    self.imageTwo.image = count>1?self.photos[1]:nil;
    self.imageThree.image = count>2?self.photos[2]:nil;
}

@end
