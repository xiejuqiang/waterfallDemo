//
//  WaterFallViewController.m
//  waterfallDemo
//
//  Created by apple on 13-9-5.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "WaterFallViewController.h"
#import "TMQuiltView.h"
#import "EGOImageView.h"

#import "TMPhotoQuiltViewCell.h"

#import "SVPullToRefresh.h"

@interface WaterFallViewController ()<TMQuiltViewDataSource,TMQuiltViewDelegate>
{
	TMQuiltView *qtmquitView;
    NSArray *imageArr;
}
@property (nonatomic, retain) NSMutableArray *images;
@end

@implementation WaterFallViewController
@synthesize images = _images;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        imageArr = [[NSArray alloc] initWithObjects:@"http://wenwen.soso.com/p/20100824/20100824210025-103805082.jpg",
                                                @"http://wenwen.soso.com/p/20100824/20100824202423-733803671.jpg",
                                                @"http://wenwen.soso.com/p/20100824/20100824210140-41408210.jpg",
                                                @"http://wenwen.soso.com/p/20100824/20100824202559-1565870612.jpg",
                                                @"http://tupian.qqjay.com/u/2012/0929/4_10109_6.jpg",
                                                @"http://img1.comic.zongheng.com/comic/image/2009/1/samosekayi/240_240/20090217033140052800.jpg",
                                                @"http://wenwen.soso.com/p/20100830/20100830093536-1336553941.jpg",
                                                @"http://img1.gtimg.com/blog/pics/21575/21575890.jpg",
                                                @"http://wenwen.soso.com/p/20090810/20090810172858-1555696962.jpg",
                                                @"http://photocdn.sohu.com/20051102/Img240645990.jpg",
                                                @"http://img1.gtimg.com/blog/pics/21575/21575792.jpg",
                                                @"http://tupian.qqjay.com/u/2012/0929/4_10109_3.jpg",nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    qtmquitView = [[TMQuiltView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
	qtmquitView.delegate = self;
	qtmquitView.dataSource = self;
//	qtmquitView.backgroundColor = [UIColor grayColor];
	[self.view addSubview:qtmquitView];
    
    
    [qtmquitView addInfiniteScrollingWithActionHandler:^{
        [self insertRowAtBottom];
    }];
    
    [qtmquitView reloadData];
}

- (void)insertRowAtBottom
{
    [self getNextPageView];
     
}

//加载调用的方法
-(void)getNextPageView
{
//	for(int i = 0; i < 10; i++) {
//		[_images addObject:[NSString stringWithFormat:@"%d.jpeg", i % 10 + 1]];
//	}
    [qtmquitView.infiniteScrollingView stopAnimating];
    [_images addObjectsFromArray:imageArr];
	[qtmquitView reloadData];
   
}

- (NSMutableArray *)images
{
    if (!_images)
	{
        NSMutableArray *imageNames = [NSMutableArray array];
        for(int i = 0; i < 10; i++) {
            [imageNames addObject:[NSString stringWithFormat:@"%d.jpeg", i % 10 + 1]];
        }
        _images = [[NSMutableArray alloc] initWithArray:imageArr];
//        _images = [imageNames retain];
    }
    return _images;
}

- (UIImage *)imageAtIndexPath:(NSIndexPath *)indexPath {
    EGOImageView *imgView = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"8"]];
    imgView.imageURL = [[NSURL alloc] initWithString:[self.images objectAtIndex:indexPath.row]];
    return imgView.image;
}

- (NSInteger)quiltViewNumberOfCells:(TMQuiltView *)TMQuiltView {
    return [self.images count];
}

- (TMQuiltViewCell *)quiltView:(TMQuiltView *)quiltView cellAtIndexPath:(NSIndexPath *)indexPath {
    TMPhotoQuiltViewCell *cell = (TMPhotoQuiltViewCell *)[quiltView dequeueReusableCellWithReuseIdentifier:@"PhotoCell"];
    if (!cell) {
        cell = [[[TMPhotoQuiltViewCell alloc] initWithReuseIdentifier:@"PhotoCell"] autorelease];
    }
    
//    cell.photoView.image = [self imageAtIndexPath:indexPath];
    NSString *strImg = [self.images objectAtIndex:indexPath.row];
    NSURL *url = [[NSURL alloc ] initWithString:strImg];
    cell.photoView.imageURL = url;
    cell.titleLabel.text = [NSString stringWithFormat:@"%d", indexPath.row];
//    [cell layoutSubviewsFunction];
    return cell;
}

#pragma mark - TMQuiltViewDelegate

- (NSInteger)quiltViewNumberOfColumns:(TMQuiltView *)quiltView {
	
    
    if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft
        || [[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeRight)
	{
        return 3;
    } else {
        return 2;
    }
}

- (CGFloat)quiltView:(TMQuiltView *)quiltView heightForCellAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%f",[self imageAtIndexPath:indexPath].size.height);
    return [self imageAtIndexPath:indexPath].size.height;
}

- (void)quiltView:(TMQuiltView *)quiltView didSelectCellAtIndexPath:(NSIndexPath *)indexPath
{
	NSLog(@"index:%d",indexPath.row);
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
