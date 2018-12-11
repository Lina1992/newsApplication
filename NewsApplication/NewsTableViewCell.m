//
//  NewsTableViewCell.m
//  NewsApplication
//
//  Created by Галина  Муравьева on 11.12.2018.
//  Copyright © 2018 none. All rights reserved.
//

#import "NewsTableViewCell.h"

@implementation NewsTableViewCell
{
}
UIFont *mainNewsLabelFont;
UIFont *newsLabelFont;
CGFloat distanceToBoard=30.0f;
CGFloat distanceBetwinElements=15.0f;
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        newsLabelFont=[UIFont systemFontOfSize:18.0f];
        mainNewsLabelFont=[UIFont boldSystemFontOfSize:21.0f];
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
-(void)redrawCell
{
    
    self.mainNewsLabel.text=[self getMainNewsLabelText];
    self.mainNewsLabel.font=mainNewsLabelFont;
    
    self.newsLabel.text=[self getNewsLabelText];
    self.newsLabel.font=newsLabelFont;
    
    [self setFrames];
    
}
-(NSString *)getMainNewsLabelText
{
    NSString *mainNewsLabelText=@"";
    if(![self.dictionaryWithSingleRecordNews isKindOfClass:[NSNull class]] && self.dictionaryWithSingleRecordNews!=nil)
    {
        if(![[self.dictionaryWithSingleRecordNews valueForKey:@"title"] isKindOfClass:[NSNull class]] && [self.dictionaryWithSingleRecordNews valueForKey:@"title"]!=nil)
            mainNewsLabelText=[NSString stringWithFormat:@"%@",[self.dictionaryWithSingleRecordNews valueForKey:@"title"]];
    }
    return mainNewsLabelText;
}
-(NSString *)getNewsLabelText
{
    NSString *getNewsLabelText=@"";
    if(![self.dictionaryWithSingleRecordNews isKindOfClass:[NSNull class]] && self.dictionaryWithSingleRecordNews!=nil)
    {
        if(![[self.dictionaryWithSingleRecordNews valueForKey:@"description"] isKindOfClass:[NSNull class]] && [self.dictionaryWithSingleRecordNews valueForKey:@"description"]!=nil)
            getNewsLabelText=[NSString stringWithFormat:@"%@",[self.dictionaryWithSingleRecordNews valueForKey:@"description"]];
    }
    return getNewsLabelText;
}
-(void)setFrames
{
    CGFloat y=distanceToBoard;
    CGFloat w=self.contentView.frame.size.width-(distanceToBoard*2);
    if([self getMainNewsLabelText].length>0)
    {
        self.mainNewsLabel.frame=CGRectMake(distanceToBoard, y, w, [self getMainNewsLabelHeight]);
        y=y+self.mainNewsLabel.frame.size.height+distanceBetwinElements;
    }
    
    self.newsLabel.frame=CGRectMake(distanceToBoard, y, w, [self getNewsLabelHeight]);
}
-(CGFloat)getMainNewsLabelHeight
{
    NSString *string=[self getMainNewsLabelText];
    return [self getHeightOfString:string withFont:mainNewsLabelFont];
}
-(CGFloat)getNewsLabelHeight
{
    NSString *string=[self getNewsLabelText];
    return [self getHeightOfString:string withFont:newsLabelFont];
}
-(CGFloat)getHeightOfString:(NSString *)string withFont:(UIFont *)font
{
    CGSize labelSize=CGSizeMake(self.frame.size.width-(distanceToBoard*2), MAXFLOAT);
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineBreakMode:NSLineBreakByWordWrapping];
    NSDictionary *attributes = @{NSFontAttributeName : font, NSParagraphStyleAttributeName : paragraphStyle};
    CGRect stringRect=CGRectZero;
    @try {
        stringRect=[string boundingRectWithSize:labelSize
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:attributes
                                        context:nil];
    } @catch (NSException *exception) {
        NSLog(@"some problem with stringsize in getHeightOfString exception= %@",exception);
    }
    
    return stringRect.size.height;
}
-(CGFloat)getHeight
{
    CGFloat a=[self getMainNewsLabelHeight];
    CGFloat b=[self getNewsLabelHeight];
    CGFloat c=a+b;
    c=c+(distanceToBoard*2);
    if(a>0 && b>0)
        c=c+distanceBetwinElements;
    
    return c;
}
@end
