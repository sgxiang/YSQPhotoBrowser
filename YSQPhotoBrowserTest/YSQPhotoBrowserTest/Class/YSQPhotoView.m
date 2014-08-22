//
//  YSQPhotoVIew.m
//  YSQPhotoBrowserTest
//
//  Created by ysq on 14/8/22.
//  Copyright (c) 2014年 ysq. All rights reserved.
//

#import "YSQPhotoView.h"
#import <QuartzCore/QuartzCore.h>
#import <UIImageView+WebCache.h>
#import <AssetsLibrary/AssetsLibrary.h>

@implementation YSQPhotoView{
    UIImageView *_imageView;
    UILongPressGestureRecognizer *_longTouch;
}


- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setDelegate:self];
        [self setMaximumZoomScale:5.0];
        [self setShowsHorizontalScrollIndicator:NO];
        [self setShowsVerticalScrollIndicator:NO];
        
        _imageView = [[UIImageView alloc] initWithFrame:frame];
        [_imageView setContentMode:UIViewContentModeScaleAspectFit];
        [self addSubview:_imageView];
        
        _longTouch = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longTouch:)];
        _longTouch.minimumPressDuration = 0.5;
        _imageView.userInteractionEnabled = YES;
        [_imageView addGestureRecognizer:_longTouch];
        
        
    }
    return self;
}


#pragma mark- 保存图片

-(void)longTouch:(UILongPressGestureRecognizer *)sender{
    if (!_imageView.userInteractionEnabled) {
        return;
    }
    _imageView.userInteractionEnabled = NO;
    
    UIActionSheet *action = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"保存图片", nil];
    
    [action showInView:self];
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    _imageView.userInteractionEnabled = YES;
    
    if (buttonIndex==0) {
        
        ALAssetsLibrary* library = [[ALAssetsLibrary alloc]init];
        [library writeImageToSavedPhotosAlbum:_imageView.image.CGImage orientation:(ALAssetOrientation)_imageView.image.imageOrientation completionBlock:^(NSURL *assetURL, NSError *error) {
            if (!error) {
                [library assetForURL:assetURL resultBlock:^(ALAsset *asset ){
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"保存成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                    [alert show];
                }failureBlock:^(NSError *error ){
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"保存失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                    [alert show];
                }];
                
            }else{
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"保存失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
            }
        }];
        
    }
}


#pragma mark- 设置图片
- (void)setImage:(UIImage *)newImage {
    [_imageView setImage:newImage];
}

-(void)setImageWithUrlString:(NSString *)newImageUrlString{
    [_imageView sd_setImageWithURL:[NSURL URLWithString:newImageUrlString]];
}

#pragma mark- 刷新视图

- (void)layoutSubviews {
    [super layoutSubviews];
    
    //如果缩放了    设置为默认frame
    if ([self isZoomed] == NO && CGRectEqualToRect([self bounds], [_imageView frame]) == NO) {
        [_imageView setFrame:[self bounds]];
    }
}

#pragma mark- 返回是否缩放了

- (BOOL)isZoomed{
    // ! ( 缩放度 == 最小缩放度 )
    return !([self zoomScale] == [self minimumZoomScale]);
}


#pragma mark- zoom

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center {
    
    CGRect zoomRect;
    zoomRect.size.height = [self frame].size.height / scale;
    zoomRect.size.width  = [self frame].size.width  / scale;
    zoomRect.origin.x    = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y    = center.y - (zoomRect.size.height / 2.0);
    
    return zoomRect;
}

- (void)zoomToLocation:(CGPoint)location{
    float newScale;
    CGRect zoomRect;
    if ([self isZoomed]) {
        zoomRect = [self bounds];
    } else {
        newScale = [self maximumZoomScale];
        zoomRect = [self zoomRectForScale:newScale withCenter:location];
    }
    
    [self zoomToRect:zoomRect animated:YES];
}

//如果缩放了  -》    返回未缩放状态
- (void)turnOffZoom{
    if ([self isZoomed]) {
        [self zoomToLocation:CGPointZero];
    }
}


#pragma mark- 缩放和复原

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    
    if ([touch tapCount] == 2) {
        [self zoomToLocation:[touch locationInView:self]];
    }
}

#pragma mark- 缩放的视图

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    UIView *viewToZoom = _imageView;
    return viewToZoom;
}


@end
