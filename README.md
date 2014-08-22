# YSQPhotoBrowserViewController


## Usage



```obj-c
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
```

## License

The MIT License

Copyright (c) 2010 ELC Technologies

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

