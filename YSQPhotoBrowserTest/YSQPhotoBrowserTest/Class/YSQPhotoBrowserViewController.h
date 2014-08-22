//
//  YSQPhotoBrowserViewController.h
//  YSQPhotoBrowserTest
//
//  Created by ysq on 14/8/22.
//  Copyright (c) 2014年 ysq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YSQPhotoBrowserViewController : UIViewController

@property(nonatomic,strong)NSMutableArray *photos;
@property(nonatomic,assign)NSInteger selectIndex;


@property(nonatomic,assign)BOOL isView;

-(id)initWithPhotos:(NSMutableArray *)photos selectIndex:(NSInteger)selectIndex finish:(void(^)(void))finish;



@end
