//
//  InputPrepaidVC.m
//  BusOperator
//
//  Created by Macbook Pro on 10/20/14.
//  Copyright (c) 2014 Ignite Software Solution. All rights reserved.
//

#import "InputPrepaidVC.h"
#import "JDStatusBarNotification.h"
#import "DataFetcher.h"

@interface InputPrepaidVC ()

@property (weak, nonatomic) IBOutlet UILabel *lblTitleBox;
@property (weak, nonatomic) IBOutlet UILabel *lblAgent;
@property (weak, nonatomic) IBOutlet UITextField *txtCreditAmt;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
@property (weak, nonatomic) IBOutlet UIButton *btnSave;
@property (weak, nonatomic) IBOutlet UIView *bgview;

- (IBAction)Save:(id)sender;
- (IBAction)Cancel:(id)sender;


@end

@implementation InputPrepaidVC

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
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"BkgColor.png"]];
    
    self.bgview.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.85];
    
    _lblTitleBox.font = [UIFont fontWithName:@"Zawgyi-One" size:17.0f];
    _lblTitleBox.text = @"ၾကိဳတင္ ေငြသြင္းရန္";
    
    _lblAgent.font = [UIFont fontWithName:@"Zawgyi-One" size:16.0f];
    _lblAgent.text = _agentinfo[@"name"];
    
    _txtCreditAmt.font = [UIFont fontWithName:@"Zawgyi-One" size:16.0f];
    
    _btnCancel.titleLabel.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    [_btnCancel setTitle:@"ထြက္မည္" forState:UIControlStateNormal];
    
    _btnSave.titleLabel.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    [_btnSave setTitle:@"သိမ္းမည္" forState:UIControlStateNormal];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishPostPrepaid:) name:@"finishPostPrepaid" object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)finishPostPrepaid:(NSNotification*)notification
{
    [self JDStatusBarHidden:YES status:@"" duration:0];
    
    [self.navigationController popViewControllerAnimated:YES];
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

- (IBAction)Save:(id)sender {
    if (_txtCreditAmt.text.length > 0) {
        [self JDStatusBarHidden:NO status:@"Saving..." duration:0];
        
        NSDictionary* dict = @{@"agentid": _agentinfo[@"id"], @"deposit":[NSString stringWithFormat:@"%@",_txtCreditAmt.text]};
        DataFetcher* df = [DataFetcher new];
        [df postPrepaid:dict];
    }
}

- (IBAction)Cancel:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
