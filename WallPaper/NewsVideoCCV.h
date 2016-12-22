//
//  NewsVideoCCV.h
//  dawood-bi-ios
//
//  Created by Cygnis Media on 22/03/2016.
//  Copyright © 2016 Cygnis Media, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsVideo.h"


@protocol videoPressedDelegate <NSObject>

-(void)playVideo:(CGRect)frame withURL:(NewsVideo *)newsVideo;

@end
@interface NewsVideoCCV : UICollectionViewCell<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *videoTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *videodetailLabel;
@property (nonatomic, weak) IBOutlet UIView *videoContainer;

@property (weak, nonatomic) IBOutlet UIWebView *webview;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *videoContainerHeight;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *videoContainerWidth;

@property (nonatomic, assign) id<videoPressedDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic,strong) NewsVideo *newsVideo;

-(void)setData:(NSObject*)newsVideo;
-(void)stopVideo;
-(IBAction)videoPressed:(id)sender;


@end
