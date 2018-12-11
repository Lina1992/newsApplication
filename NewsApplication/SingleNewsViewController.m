//
//  SingleNewsViewController.m
//  NewsApplication
//
//  Created by Галина  Муравьева on 11.12.2018.
//  Copyright © 2018 none. All rights reserved.
//

#import "SingleNewsViewController.h"

@interface SingleNewsViewController ()
@property (nonatomic) UIProgressView *progressView;
@end

@implementation SingleNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURL *url = [NSURL URLWithString:self.stringOfUrlToOpen];
    NSLog(@"self.stringOfUrlToOpen=%@",self.stringOfUrlToOpen);
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];
    self.progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    self.progressView.frame=CGRectMake(0, self.navigationController.navigationBar.frame.size.height+self.navigationController.navigationBar.frame.origin.y, self.view.frame.size.width, self.progressView.frame.size.height);
  //  NSLog(@"self.progressView.frame=%@",NSStringFromCGRect(self.progressView.frame));
    [self.webView addSubview:self.progressView];
    
    [self.webView  loadRequest:request];

    // необходимо организовать делегат для проверки открылась ли ссылка и существует ли она вообщн
}
- (void)dealloc {
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(estimatedProgress))] && object == self.webView) {
       // NSLog(@"self.webView.estimatedProgress=%f",self.webView.estimatedProgress);
        [self.progressView setAlpha:1.0f];
        [self.progressView setProgress:self.webView.estimatedProgress animated:YES];
        
        if(self.webView.estimatedProgress >= 0.9f) {
            [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
                [self.progressView setAlpha:0.0f];
            } completion:^(BOOL finished) {
                [self.progressView setProgress:0.0f animated:NO];
            }];
        }
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
