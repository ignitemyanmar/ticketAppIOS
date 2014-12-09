//
//  CreateNewOperatorVC.m
//  BusOperator
//
//  Created by Macbook Pro on 6/12/14.
//  Copyright (c) 2014 Ignite Software Solution. All rights reserved.
//

#import "CreateNewOperatorVC.h"
#import "JDStatusBarNotification.h"
#import "DataFetcher.h"

@interface CreateNewOperatorVC ()

@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UITextField *txtOpName;
@property (strong, nonatomic) IBOutlet UITextField *txtOpAddress;
@property (strong, nonatomic) IBOutlet UITextField *txtOpPh;

- (IBAction)SaveNewOperator:(id)sender;

@end

@implementation CreateNewOperatorVC

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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishNewOperatorCreate:) name:@"finishNewOperatorCreate" object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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



- (void)finishNewOperatorCreate:(NSNotification*)noti
{
    NSString* str = (NSString*)noti.object;
    [self JDStatusBarHidden:NO status:str duration:5];
    _txtOpName.text = @"";
    _txtOpAddress.text = @"";
    _txtOpPh.text = @"";
}

- (IBAction)SaveNewOperator:(id)sender {
    
//    if (_txtOpName.text.length > 0 && _txtOpAddress.text.length > 0 && _txtOpPh.text.length > 0) {
//        [self JDStatusBarHidden:NO status:@"Saving..." duration:0];
//        DataFetcher* fetcher = [DataFetcher new];
//        [fetcher createNewOperator:_txtOpName.text withAddress:_txtOpAddress.text withPh:_txtOpPh.text withEmail:<#(NSString *)#> withPassword:<#(NSString *)#>];
//    }
}
@end
