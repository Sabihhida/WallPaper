//
//  NewsVideoCCV.m
//  dawood-bi-ios
//
//  Created by Cygnis Media on 22/03/2016.
//  Copyright © 2016 Cygnis Media, Inc. All rights reserved.
//

#import "NewsVideoCCV.h"
#import "NewsVideo.h"
#import "NSDate+TimeAgo.h"

@implementation NewsVideoCCV

-(void)awakeFromNib{

    if ( IDIOM != IPAD ){
        _videoContainerWidth.constant = width(self);
    }
   
}
-(void)setData:(NSObject*)newsVideo{
    
    if ([newsVideo isKindOfClass:[NewsVideo class]]){
        
        NewsVideo *newsVideoObj = (NewsVideo *)newsVideo;
        
        self.videoTitleLabel.text = newsVideoObj.videoTitle;
        
        NSDateFormatter *dateformat = [[NSDateFormatter alloc] init];
        [dateformat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        NSDate  *date = [dateformat dateFromString:[Utility convertDateIntoDeviceTimeZone:newsVideoObj.createdAt]];
        NSTimeInterval timeInterval = [date timeIntervalSinceReferenceDate];
        NSTimeInterval currentTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate];
        
        
        NSString *relativeDate = [NSString stringWithFormat:@"%@",[[NSDate dateWithTimeIntervalSinceNow:-(currentTimeInterval - timeInterval)] dateTimeAgo]];

        
        self.videodetailLabel.text = relativeDate ;
    
        self.videoTitleLabel.attributedText = [self paragraphSpacing:self.videoTitleLabel.font
                                                       withString:self.videoTitleLabel.text
                                                        withColor:self.videoTitleLabel.textColor withAligment:NSTextAlignmentLeft];
        self.webview.scrollView.scrollEnabled = NO;

        self.webview.delegate = self;
        [self.webview stopLoading];

        [self.webview loadHTMLString:@"" baseURL:nil];

        NSURL *urls = [NSURL URLWithString:[NSString stringWithFormat:@"%@&width=%f&height=%f", newsVideoObj.player,width(self), height(self.webview) ]];
        [[NSURLCache sharedURLCache] removeAllCachedResponses];
        NSMutableURLRequest *requestObj = [NSMutableURLRequest requestWithURL:urls];
        [requestObj setValue:[NSString stringWithFormat:@"Bearer: %@", [DataManager sharedManager].accessToken] forHTTPHeaderField:@"Authorization"];

        requestObj.cachePolicy = NSURLRequestReloadIgnoringCacheData;

        [self.webview loadRequest:requestObj];
    }
}

//- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
//{
//    webView.scalesPageToFit = YES;//set here
//    return YES;
//}
//-(void)webViewDidFinishLoad:(UIWebView *)webView{
//   
//   webView.scalesPageToFit = YES;
//    webView.contentMode = UIViewContentModeScaleAspectFit;
//    
//}

-(NSAttributedString*)paragraphSpacing:(UIFont*)font
                            withString:(NSString*)string withColor:(UIColor*)color withAligment:(NSTextAlignment)aligment{
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 6.0;
    paragraphStyle.alignment = aligment;
    return [[NSAttributedString alloc] initWithString:string                                                                                attributes:@{NSParagraphStyleAttributeName : paragraphStyle,
                                                                                                                                                         NSFontAttributeName: font,
                                                                                                                                                         NSForegroundColorAttributeName : color}];
}
-(void)stopVideo{
    [self.webview stringByEvaluatingJavaScriptFromString: @"player.pauseVideo();"];
}


-(IBAction)videoPressed:(id)sender{
//    CGRect videoFrame = self.videoContainer.frame ;
//    [self.delegate playVideo:videoFrame withURL:_newsVideo];
    
}

#pragma  mark -- UIWebViewDelegate


- (void)webViewDidStartLoad:(UIWebView *)webView{
    self.activityIndicator.hidden = NO;
    [self.activityIndicator startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self.activityIndicator stopAnimating];
    self.activityIndicator.hidden = YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:( NSError *)error{
    NSLog(@"%@",error);
    [self.activityIndicator stopAnimating];
    self.activityIndicator.hidden = YES;
}

@end
