//
//  YSQPhotoBrowserViewController.m
//  YSQPhotoBrowserTest
//
//  Created by ysq on 14/8/22.
//  Copyright (c) 2014年 ysq. All rights reserved.
//

#import "YSQPhotoBrowserViewController.h"
#import "YSQPhotoView.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface YSQPhotoBrowserViewController ()<UIScrollViewDelegate>

@end

@implementation YSQPhotoBrowserViewController{

    UIScrollView *_photoScrollView;
    NSMutableArray *_imageViews;
    
    NSInteger _currentIndex;
    
    void(^_finish)(void);
    
}


-(id)initWithPhotos:(NSMutableArray *)photos selectIndex:(NSInteger)selectIndex finish:(void (^)(void))finish{
    if (self=[super init]) {
        self.photos = photos;
        self.selectIndex = selectIndex;
        _finish = finish;
    }
    return self;
}


- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    self.title = @"预览";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    _imageViews = [[NSMutableArray alloc]initWithCapacity:[self.photos count]];
    
    CGRect scrollFrame = [self frameForPagingScrollView];
    _photoScrollView = [[UIScrollView alloc] initWithFrame:scrollFrame];
    _photoScrollView.backgroundColor = [UIColor clearColor];
    _photoScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	_photoScrollView.pagingEnabled = YES;
	_photoScrollView.delegate = self;
    _photoScrollView.autoresizesSubviews = YES;
	_photoScrollView.showsHorizontalScrollIndicator = NO;
	_photoScrollView.showsVerticalScrollIndicator = NO;
	[self.view addSubview:_photoScrollView];
    
    [self setScrollViewContentSize];
    
    for (int i=0; i < [self.photos count]; i++) {
        [_imageViews addObject:[NSNull null]];
    }
    
    
    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = left;
    
    if(!self.isView){
        UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(deleteCurrentPhoto)];
        self.navigationItem.rightBarButtonItem = right;
    }
    
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    [self scrollToIndex:self.selectIndex];
    [self setScrollViewContentSize];
    [self setCurrentIndex:self.selectIndex];

}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}



-(void)back{
    if (_finish) {
        _finish();
    }
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)scrollToIndex:(NSInteger)index
{
    CGRect frame = _photoScrollView.frame;
    frame.origin.x = frame.size.width * index;
    frame.origin.y = 0;
    [_photoScrollView scrollRectToVisible:frame animated:NO];
}


#define PADDING  20

- (CGRect)frameForPagingScrollView
{
    CGRect frame = [[UIScreen mainScreen] bounds];
    frame.origin.x -= PADDING;
    frame.size.width += (2 * PADDING);
    return frame;
}



- (void)setCurrentIndex:(NSInteger)newIndex
{
    _currentIndex = newIndex;
    
    [self loadPhoto:_currentIndex];
    [self loadPhoto:_currentIndex + 1];
    [self loadPhoto:_currentIndex - 1];
    [self unloadPhoto:_currentIndex + 2];
    [self unloadPhoto:_currentIndex - 2];
    
}


- (void)loadPhoto:(NSInteger)index
{
    if (index < 0 || index >= [self.photos count]) {
        return;
    }
    
    id currentPhotoView = [_imageViews objectAtIndex:index];
    if (NO == [currentPhotoView isKindOfClass:[YSQPhotoView class]]) {
        
        CGRect frame = [self frameForPageAtIndex:index];
        YSQPhotoView *photoView = [[YSQPhotoView alloc] initWithFrame:frame];
        [photoView setIndex:index];
        [photoView setBackgroundColor:[UIColor clearColor]];
        
        if ([self.photos[index] isKindOfClass:[UIImage class]]) {
            UIImage *image = self.photos[index];
            [photoView setImage:image];
        }else if ([self.photos[index] isKindOfClass:[ALAsset class]]){
            UIImage *image = [UIImage imageWithCGImage:((ALAsset *)self.photos[index]).defaultRepresentation.fullScreenImage];
            [photoView setImage:image];
        }else if ([self.photos[index] isKindOfClass:[NSString class]]){
            [photoView setImageWithUrlString:self.photos[index]];
        }
        
        [_photoScrollView addSubview:photoView];
        [_imageViews replaceObjectAtIndex:index withObject:photoView];
        
    } else {
        [currentPhotoView turnOffZoom];
    }
    
}

- (void)unloadPhoto:(NSInteger)index
{
    if (index < 0 || index >= [self.photos count]) {
        return;
    }
    
    id currentPhotoView = _imageViews[index];
    if ([currentPhotoView isKindOfClass:[YSQPhotoView class]]) {
        [currentPhotoView removeFromSuperview];
        [_imageViews replaceObjectAtIndex:index withObject:[NSNull null]];
    }
    
}


- (CGRect)frameForPageAtIndex:(NSUInteger)index
{
    CGRect bounds = [_photoScrollView bounds];
    CGRect pageFrame = bounds;
    pageFrame.size.width -= (2 * PADDING);
    pageFrame.origin.x = (bounds.size.width * index) + PADDING;
    return pageFrame;
}






#pragma mark- 设置scrollView内容体范围

- (void)setScrollViewContentSize
{
    NSInteger pageCount = [self.photos count];
    if (pageCount == 0) {
        pageCount = 1;
    }
    
    CGSize size = CGSizeMake(_photoScrollView.frame.size.width * pageCount,
                             _photoScrollView.frame.size.height / 2);   // Cut in half to prevent horizontal scrolling.
    [_photoScrollView setContentSize:size];
}



- (void)deleteCurrentPhoto{
    
    NSInteger photoIndexToDelete = _currentIndex;
    [self unloadPhoto:photoIndexToDelete];
    [self unloadPhoto:photoIndexToDelete+1];
    
    [self.photos removeObjectAtIndex:photoIndexToDelete];
    
    if ([self.photos count] == 0) {
        if (_finish) {
            _finish();
        }
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        NSInteger nextIndex = photoIndexToDelete;
        if (nextIndex == [self.photos count]) {
            nextIndex -= 1;
        }
        [self setCurrentIndex:nextIndex];
        [self setScrollViewContentSize];
    }
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat pageWidth = scrollView.frame.size.width;
    float fractionalPage = scrollView.contentOffset.x / pageWidth;
    NSInteger page = floor(fractionalPage);
	if (page != _currentIndex) {
		[self setCurrentIndex:page];
	}
}


@end
