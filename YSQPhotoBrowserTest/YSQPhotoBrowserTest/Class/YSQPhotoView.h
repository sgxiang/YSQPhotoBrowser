//
//  YSQPhotoVIew.h
//  YSQPhotoBrowserTest
//
//  Created by ysq on 14/8/22.
//  Copyright (c) 2014年 ysq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YSQPhotoView : UIScrollView<UIScrollViewDelegate,UIActionSheetDelegate>

@property (nonatomic, assign) NSInteger index;

- (void)setImage:(UIImage *)newImage;
- (void)setImageWithUrlString:(NSString *)newImageUrlString;
- (void)turnOffZoom;

@end
