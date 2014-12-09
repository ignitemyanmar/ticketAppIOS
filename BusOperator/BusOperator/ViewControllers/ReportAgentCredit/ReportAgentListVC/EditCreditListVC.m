//
//  EditCreditListVC.m
//  BusOperator
//
//  Created by Macbook Pro on 10/24/14.
//  Copyright (c) 2014 Ignite Software Solution. All rights reserved.
//

#import "EditCreditListVC.h"
#import "ChangeBusGateVC.h"
#import "DataFetcher.h"
#import "JDStatusBarNotification.h"

@interface EditCreditListVC ()

@property (weak, nonatomic) IBOutlet UIButton *btnCancelOrder;
@property (weak, nonatomic) IBOutlet UIButton *btnChangeBusGate;
@property (weak, nonatomic) IBOutlet UIButton *btnQuit;
@property (weak, nonatomic) IBOutlet UIView *bgView;

- (IBAction)CancelOrder:(id)sender;
- (IBAction)ChangeBusGate:(id)sender;
- (IBAction)Quit:(id)sender;

@end

@implementation EditCreditListVC

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
    
    _btnCancelOrder.titleLabel.font = [UIFont fontWithName:@"Zawgyi-One" size:24.0f];
    [_btnCancelOrder setTitle:@"Order ဖ်က္ရန္" forState:UIControlStateNormal];
    
    _btnChangeBusGate.titleLabel.font = [UIFont fontWithName:@"Zawgyi-One" size:24.0f];
    [_btnChangeBusGate setTitle:@"ဂိတ္ခြဲခ်ိန္းရန္" forState:UIControlStateNormal];
    
    _btnQuit.titleLabel.font = [UIFont fontWithName:@"Zawgyi-One" size:24.0f];
    [_btnQuit setTitle:@"ထြက္မည္" forState:UIControlStateNormal];
    
//    _bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissallview:) name:@"dismissallview" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishPostDeleteOrder:) name:@"finishPostDeleteOrder" object:nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    ChangeBusGateVC* nextvc = [segue destinationViewController];
    nextvc.order_id = _order_id;
}

- (void)finishPostDeleteOrder:(NSNotification*)noti
{
    [self JDStatusBarHidden:YES status:@"" duration:0];
    [self Quit:nil];
}

- (void)dismissallview:(NSNotification*)noti
{
    [self Quit:nil];
}

- (IBAction)CancelOrder:(id)sender {
    [self JDStatusBarHidden:NO status:@"Deleting..." duration:0];
    DataFetcher* df = [DataFetcher new];
    [df postDeleteOrder:_order_id];
}

- (IBAction)ChangeBusGate:(id)sender {
}

- (IBAction)Quit:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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

@end
