//
//  ViewController.m
//  NewsApplication
//
//  Created by Галина  Муравьева on 11.12.2018.
//  Copyright © 2018 none. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSLog(@"lets start");
    [self.tableView reloadData];
    [self.tableView  reloadDataForCells];
    
    self.title = @"News";
    [self.navigationController.navigationBar setTitleTextAttributes:@{
                                                    NSFontAttributeName: [UIFont boldSystemFontOfSize:28.0f],
                                                    NSForegroundColorAttributeName: [UIColor blackColor]
                                                                       }];
    
    self.navigationItem.backBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@""
                                     style:UIBarButtonItemStylePlain
                                    target:nil
                                    action:nil];
    self.navigationItem.backBarButtonItem.tintColor=[UIColor blackColor];
}


@end
