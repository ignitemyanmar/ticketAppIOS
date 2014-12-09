//
//  CreateNewCityVC.m
//  BusOperator
//
//  Created by Macbook Pro on 6/12/14.
//  Copyright (c) 2014 Ignite Software Solution. All rights reserved.
//

#import "CreateNewCityVC.h"
#import "JDStatusBarNotification.h"
#import "DataFetcher.h"

@interface CreateNewCityVC ()

@property (strong, nonatomic) IBOutlet UITextField *txtCity;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;

- (IBAction)SaveNewCity:(id)sender;

@end

@implementation CreateNewCityVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishNewCityCreate:) name:@"finishNewCityCreate" object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)finishNewCityCreate:(NSNotification*)noti
{
//    [self JDStatusBarHidden:YES status:@"" duration:0];
    NSString* str = (NSString*)noti.object;
    [self JDStatusBarHidden:NO status:str duration:5];
    _txtCity.text = @"";
}

- (void) JDStatusBarHidden:(BOOL)hidden status:(NSString *)status duration:(NSTimeInterval)interval
{
    if(hidden) {
        [JDStatusBarNotification dismiss];
    } else {
        [JDStatusBarNotification addStyleNamed:@"StatusBarStyle" prepare:^JDStatusBarStyle *(JDStatusBarStyle *style) {
            style.barColor = [UIColor colorWithRed:251.0/255.0 green:143.0/255.0 blue:27.0/255.0 alpha:1.0];
            style.textColor = [UIColor whiteColor];
            return style;
        }];
        if(interval != 0) {
            [JDStatusBarNotification showWithStatus:status dismissAfter:interval styleName:@"StatusBarStyle"];
        } else {
            [JDStatusBarNotification showWithStatus:status styleName:@"StatusBarStyle"];
            [JDStatusBarNotification showActivityIndicator:YES indicatorStyle:UIActivityIndicatorViewStyleGray];
        }
    }
}

- (IBAction)SaveNewCity:(id)sender {
    if (_txtCity.text.length > 0) {
        [self JDStatusBarHidden:NO status:@"Saving..." duration:0];
        DataFetcher* fetcher = [DataFetcher new];
        [fetcher createNewCityWithName:_txtCity.text];
    }
    
}
@end
