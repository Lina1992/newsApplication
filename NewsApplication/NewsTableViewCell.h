//
//  NewsTableViewCell.h
//  NewsApplication
//
//  Created by Галина  Муравьева on 11.12.2018.
//  Copyright © 2018 none. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NewsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *mainNewsLabel;
@property (weak, nonatomic) IBOutlet UILabel *newsLabel;
@property NSDictionary *dictionaryWithSingleRecordNews;
-(void)redrawCell;
-(CGFloat)getHeight;
@end

NS_ASSUME_NONNULL_END
