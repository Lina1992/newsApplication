//
//  NewsTableView.m
//  NewsApplication
//
//  Created by Галина  Муравьева on 11.12.2018.
//  Copyright © 2018 none. All rights reserved.
//

#import "NewsTableView.h"
#import "NewsTableViewCell.h"
#import "SingleNewsViewController.h"
@interface NewsTableView ()
@property (nonatomic) UIProgressView *progressView;
@property  UIRefreshControl *refresh;
@end
@implementation NewsTableView
{
    NSURL *urlForNews;
    NSURLSession *sessionForNews;
    NSInteger page;
    BOOL isEnd;
    NSTimer *progressTimer;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        page=0;
        self.dataSource=self;
        self.delegate=self;
        self.scrollEnabled = YES;
        self.showsVerticalScrollIndicator = YES;
        self.userInteractionEnabled = YES;
        self.arrayWithNewsResords=[[NSMutableArray alloc] init];
        [self reloadData];
        isEnd=NO;
        
        self.refresh = [[UIRefreshControl alloc] init];
        self.refresh.tintColor=[UIColor blackColor];
        [self.refresh addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:self.refresh];
    }
    return self;
}
-(IBAction)handleRefresh:(id)sender{
    
    [self.refresh beginRefreshing];
    NSLog(@"IS refreshing");
    [ self.arrayWithNewsResords removeAllObjects];
    page=0;
    isEnd=NO;
    [self reloadDataForCells];
}
-(void)reloadDataForCells
{
    [self endLoading:NO];
    page=page+1;
    urlForNews=[NSURL URLWithString:[NSString stringWithFormat:@"https://newsapi.org/v2/top-headlines?country=ru&apiKey=cc04b535269a4e5895682e8f45a52aa7&pageSize=20&page=%li",(long)page]];
    [sessionForNews invalidateAndCancel];
    sessionForNews=nil;
    dispatch_queue_t concurrentQueue = dispatch_queue_create("com.my.backgroundQueue", NULL);
    dispatch_async(concurrentQueue, ^{
        
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        self->sessionForNews = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:self delegateQueue:nil];
        NSURLSessionDownloadTask *downloadTask = [self->sessionForNews downloadTaskWithURL:self->urlForNews];
        [downloadTask resume];
    });
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)URL {
    NSStringEncoding encoding;
    NSError *error;
    NSString *responseString =[NSString stringWithContentsOfURL:URL usedEncoding:&encoding error:&error];
    if (responseString!=nil && ![responseString isEqualToString:@" "] && error == nil)
    {
        NSError *error=nil;

        NSData *data=[responseString dataUsingEncoding:NSUTF8StringEncoding];
//        NSString *htmlSTR = [[NSString alloc] initWithData:data
//                                                  encoding:NSWindowsCP1252StringEncoding];
//        NSData *data2 = [htmlSTR dataUsingEncoding:NSWindowsCP1252StringEncoding];
        if(data!=nil)
        {
            NSMutableDictionary *allrecords = [NSJSONSerialization JSONObjectWithData:data options:nil error:&error];
            NSLog(@"ERROR=%@",error);
            NSMutableArray *arrOfArticles=[[NSMutableArray alloc] init];
            arrOfArticles=allrecords[@"articles"];
           
            if(![arrOfArticles isKindOfClass:[NSNull class]] && arrOfArticles!=nil)
            {
                 NSLog(@"результат запроса на выдачу = %lu",(unsigned long)arrOfArticles.count);
                if(allrecords[@"totalResults"]!=nil && ![allrecords[@"totalResults"] isKindOfClass:[NSNull class]])
                {
                     NSLog(@"результат запроса на выдачу totalResults = %@",allrecords[@"totalResults"]);
                    NSInteger totalResults=[allrecords[@"totalResults"] integerValue];
                    if(totalResults==self.arrayWithNewsResords.count+arrOfArticles.count)
                        isEnd=YES;
                }
                
                //составляем массив индексов
                NSMutableArray *indexPathsArray=[[NSMutableArray alloc]init];
                int newNumberOfRows=(int)self.arrayWithNewsResords.count+(int)arrOfArticles.count;
                for(int i=(int)self.arrayWithNewsResords.count;i<newNumberOfRows;i++)
                {
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                    [indexPathsArray addObject:indexPath];
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    BOOL needReload=NO;
                    if(self.arrayWithNewsResords.count==0)
                        needReload=YES;
                    [self.arrayWithNewsResords addObjectsFromArray:arrOfArticles];
                    if(!needReload)
                        [self insertRowsAtIndexPaths:indexPathsArray withRowAnimation:UITableViewRowAnimationFade];
                    else
                        [self reloadData];
                });
            }
            else
            {
                NSLog(@"error 1");
                //show error alert here
            }
        }
        else
        {
            NSLog(@"error 2");
            //show error alert here
        }
        
    }
    else
    {
        NSLog(@"error 3");
      //show error alert here
    }
 
    [sessionForNews invalidateAndCancel];
    sessionForNews=nil;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self endLoading:YES];
    });
    
}
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error{
    if(error!=nil && ![error isKindOfClass:[NSNull class]] && error.code!=-999)
    {
       //show error alert here
    }
    sessionForNews=nil;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self endLoading:YES];
    });
}
-(void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(NSError *)error
{
    if(error!=nil && ![error isKindOfClass:[NSNull class]])
    {
       //show error alert here
    }
    sessionForNews=nil;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self endLoading:YES];
    });
}
-(void)endLoading:(BOOL)isEnded
{
    if(isEnded)
    {
        [self.refresh endRefreshing];

        if (progressTimer != nil) {
            [progressTimer invalidate];
            progressTimer = nil;

        }
        if (!progressTimer)
        {
            progressTimer = [NSTimer scheduledTimerWithTimeInterval:0.05f target:self selector:@selector(updateProgressBarFast) userInfo:nil repeats:YES];
            [[NSRunLoop mainRunLoop] addTimer:progressTimer forMode:NSRunLoopCommonModes];
        }
        
       
    }
    else
    {
        [self.progressView removeFromSuperview];
        self.progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        CGFloat statusBarHeight=[UIApplication sharedApplication].statusBarFrame.size.height;
        self.progressView.frame=CGRectMake(0, statusBarHeight+45, self.frame.size.width, self.progressView.frame.size.height);
        NSLog(@"self.progressView.frame=%@",NSStringFromCGRect(self.progressView.frame));
        [self.superview addSubview:self.progressView];
        [self.superview  bringSubviewToFront:self.progressView];
        
        if (progressTimer != nil) {
            [progressTimer invalidate];
            progressTimer = nil;
        }
        if (!progressTimer)
        {
            progressTimer = [NSTimer scheduledTimerWithTimeInterval:0.05f target:self selector:@selector(updateProgressBar) userInfo:nil repeats:YES];
            [[NSRunLoop mainRunLoop] addTimer:progressTimer forMode:NSRunLoopCommonModes];
        }
       
    }
}
- (void)updateProgressBar {
    float step=0.0008333;//1/1200
    float newProgress = [self.progressView progress] + step;
    [self.progressView setProgress:newProgress animated:YES];
    if(newProgress>=1.0)
    {
        [self.progressView removeFromSuperview];
        if (progressTimer != nil) {
            [progressTimer invalidate];
            progressTimer = nil;
        }
    }
}
- (void)updateProgressBarFast {
    float step=0.05;//1/1200
    float newProgress = [self.progressView progress] + step;
    [self.progressView setProgress:newProgress animated:YES];
    if(newProgress>=1.0)
    {
        [self.progressView removeFromSuperview];
        if (progressTimer != nil) {
            [progressTimer invalidate];
            progressTimer = nil;
        }
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayWithNewsResords.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier=@"NewsTableViewCellId";
    NewsTableViewCell *cell=(NewsTableViewCell *)[self dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath ];
    if(cell == nil) {
        cell = [[NewsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    @try {
        cell.dictionaryWithSingleRecordNews=self.arrayWithNewsResords[indexPath.row];
    } @catch (NSException *exception) {
        NSLog(@"here is some proplem with [dictionaryWithSingleRecordNews objectAtIndex:]  exception=%@",exception);
    }
    if(indexPath.row % 2)
        cell.backgroundColor=[UIColor colorWithRed:240.0f/255.0f
                                             green:240.0f/255.0f
                                              blue:240.0f/255.0f
                                             alpha:1.0f];
    else
        cell.backgroundColor=[UIColor whiteColor];
    [cell redrawCell];
    if(sessionForNews==nil && !isEnd && indexPath.row>self.arrayWithNewsResords.count-3)
    {
        [self reloadDataForCells];
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height=40;
    NewsTableViewCell* cell=[[NewsTableViewCell alloc] init];
    cell.frame=CGRectMake(0, 0, self.frame.size.width, 20);//необходима ширина для определении высоты
    @try {
        cell.dictionaryWithSingleRecordNews=self.arrayWithNewsResords[indexPath.row];
    } @catch (NSException *exception) {
        NSLog(@"here is some proplem with [dictionaryWithSingleRecordNews objectAtIndex:] in heightForRowAtIndexPath  exception=%@",exception);
    }
    height=MAX(height, [cell getHeight]);
    return height;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    NSLog(@"cell was select open new viewontroller");
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SingleNewsViewController * singleNewsView=[sb instantiateViewControllerWithIdentifier:@"SingleNewsViewController"];
    NSString *urlString=[self urlStringFromIndex:indexPath.row];

    if(urlString.length>0)//еще необходимо дописать проверку ссылка ли это
    {
        singleNewsView.stringOfUrlToOpen=urlString;
        UIViewController *vc = [self parentViewController];
        NSLog(@"parentViewController=%@",vc);
        if(vc.navigationController)
            [vc.navigationController pushViewController:singleNewsView animated:YES];
        else
        {
            [vc.navigationController presentViewController:singleNewsView animated:YES completion:nil];
            NSLog(@"Alert!!! need back batton on singleNewsView if presented");
        }
    }
    else
    {
        //error alert here
    }
   
}
-(NSString *)urlStringFromIndex:(NSInteger)index
{
    NSString *urlString=@"";
    if([self.arrayWithNewsResords objectAtIndex:index]!=nil && ![[self.arrayWithNewsResords objectAtIndex:index] isKindOfClass:[NSNull class]])
    {
        if([[self.arrayWithNewsResords objectAtIndex:index] valueForKey:@"url"]!=nil && ![[[self.arrayWithNewsResords objectAtIndex:index] valueForKey:@"url"] isKindOfClass:[NSNull class]])
        {
            urlString=[NSString stringWithFormat:@"%@",[[self.arrayWithNewsResords objectAtIndex:index] valueForKey:@"url"]];
        }
    }
    return urlString;
}
- (UIViewController *)parentViewController {
    UIResponder *responder = self;
    while ([responder isKindOfClass:[UIView class]])
        responder = [responder nextResponder];
    return (UIViewController *)responder;
}
@end
