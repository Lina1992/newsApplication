//
//  NewsTableView.h
//  NewsApplication
//
//  Created by Галина  Муравьева on 11.12.2018.
//  Copyright © 2018 none. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NewsTableView : UITableView <UITableViewDelegate,UITableViewDataSource,NSURLSessionDelegate,NSURLConnectionDataDelegate>
-(void)reloadDataForCells;
@property NSMutableArray *arrayWithNewsResords;
@end

NS_ASSUME_NONNULL_END
