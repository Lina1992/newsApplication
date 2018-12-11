//
//  SingleNewsViewController.h
//  NewsApplication
//
//  Created by Галина  Муравьева on 11.12.2018.
//  Copyright © 2018 none. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface SingleNewsViewController : UIViewController <WKUIDelegate>
@property NSString *stringOfUrlToOpen;
@property (weak, nonatomic) IBOutlet WKWebView *webView;

@end

NS_ASSUME_NONNULL_END
