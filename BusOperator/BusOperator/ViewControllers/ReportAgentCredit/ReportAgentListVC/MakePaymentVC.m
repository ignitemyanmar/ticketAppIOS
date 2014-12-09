//
//  MakePaymentVC.m
//  BusOperator
//
//  Created by Macbook Pro on 10/28/14.
//  Copyright (c) 2014 Ignite Software Solution. All rights reserved.
//

#import "MakePaymentVC.h"
#import "DataFetcher.h"
#import "JDStatusBarNotification.h"

@interface MakePaymentVC ()

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lbltitlePrepaid;
@property (weak, nonatomic) IBOutlet UILabel *lblPrepaid;
@property (weak, nonatomic) IBOutlet UILabel *lbltitlePayamt;
@property (weak, nonatomic) IBOutlet UILabel *lblPayamt;
@property (weak, nonatomic) IBOutlet UIView *viewCkbxBg;
@property (weak, nonatomic) IBOutlet UILabel *lblCkBx;
@property (weak, nonatomic) IBOutlet UITextField *txtPayAmt;
@property (weak, nonatomic) IBOutlet UIButton *btnQuit;
@property (weak, nonatomic) IBOutlet UIButton *btnPay;
@property (assign, nonatomic) BOOL isChecked;
@property (weak, nonatomic) IBOutlet UIView *viewtxtLine;

- (IBAction)Quit:(id)sender;
- (IBAction)Pay:(id)sender;

@end

@implementation MakePaymentVC

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
    
//    _bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    
    _lblTitle.font = [UIFont fontWithName:@"Zawgyi-One" size:24.0f];
    _lblTitle.text = @"ေငြေပးေခ်ရန္";
    
    _lbltitlePrepaid.font = [UIFont fontWithName:@"Zawgyi-One" size:20.0f];
    _lbltitlePrepaid.text = @"ၾကိဳတင္ေငြပမာဏ =";
    
    _lbltitlePayamt.font = [UIFont fontWithName:@"Zawgyi-One" size:20.0f];
    _lbltitlePayamt.text = @"ေပးေခ်ရန္ပမာဏ =";
    
    _lblCkBx.font = [UIFont fontWithName:@"Zawgyi-One" size:20.0f];
    _lblCkBx.text = @"ၾကိဳတင္ေပးေငြမွေပးမည္";
    
    _btnQuit.titleLabel.font = [UIFont fontWithName:@"Zawgyi-One" size:24.0f];
    [_btnQuit setTitle:@"ထြက္မည္" forState:UIControlStateNormal];
    
    _btnPay.titleLabel.font = [UIFont fontWithName:@"Zawgyi-One" size:24.0f];
    [_btnPay setTitle:@"ေပးမည္" forState:UIControlStateNormal];
    
    _txtPayAmt.placeholder = @"ေပးမည့္ပမာဏထည့္ရန္";
    _txtPayAmt.font = [UIFont fontWithName:@"Zawgyi-One" size:20.0f];
    
    
    UIButton *btnChkCell = [UIButton buttonWithType:UIButtonTypeCustom];
    btnChkCell.frame = CGRectMake(0.0f, 0.0f, _viewCkbxBg.frame.size.width, _viewCkbxBg.frame.size.height);
    [btnChkCell setImage:[UIImage imageNamed:@"cb_glossy_off"] forState:UIControlStateNormal];
    [btnChkCell setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    [btnChkCell addTarget:self action:@selector(checkToPay:) forControlEvents:UIControlEventTouchUpInside];
    
    [_viewCkbxBg addSubview:btnChkCell];
    
    _isChecked = NO;
    
    _lblPrepaid.text = [NSString stringWithFormat:@"%d Ks",_prepaidamt];
    _lblPayamt.text = [NSString stringWithFormat:@"%ld Ks",_totalpayment];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishPostPayment:) name:@"finishPostPayment" object:nil];
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)finishPostPayment:(NSNotification*)noti
{
    [self JDStatusBarHidden:YES status:@"" duration:0];
    [self dismissViewControllerAnimated:YES completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadCreditList" object:nil];
    }];
}

- (void)checkToPay:(id)sender
{
    UIButton* btn = (UIButton*)sender;
    if (_isChecked) {
        [btn setImage:[UIImage imageNamed:@"cb_glossy_off"] forState:UIControlStateNormal];
        _isChecked = NO;
        _txtPayAmt.enabled = YES;
        _viewtxtLine.backgroundColor = [UIColor colorWithRed:0/255 green:122.0f/255 blue:255.0f/255 alpha:1];
        
        _lblPayamt.text = [NSString stringWithFormat:@"%ld Ks",_totalpayment];
        _lblPrepaid.text = [NSString stringWithFormat:@"%d Ks",_prepaidamt];
    }
    else {
        [btn setImage:[UIImage imageNamed:@"cb_glossy_on"] forState:UIControlStateNormal];
        _txtPayAmt.text = @"";
        _isChecked = YES;
        _txtPayAmt.enabled = NO;
        _viewtxtLine.backgroundColor = [UIColor lightGrayColor];
        
        NSNumber *strikeSize = [NSNumber numberWithInt:2];
        
        NSDictionary *strikeThroughAttribute = [NSDictionary dictionaryWithObject:strikeSize
                                                                           forKey:NSStrikethroughStyleAttributeName];
        
        NSAttributedString* strikeThroughText = [[NSAttributedString alloc] initWithString:_lblPayamt.text attributes:strikeThroughAttribute];
        
        _lblPayamt.attributedText = strikeThroughText;
        
        long newprepaid = _prepaidamt + _totalpayment;
        
        _lblPrepaid.text = [NSString stringWithFormat:@"%ld Ks", newprepaid];

    }
}

- (IBAction)Quit:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)Pay:(id)sender {
    NSString* payamt;
    if (_txtPayAmt.text.length > 0) {
        payamt = _txtPayAmt.text;
    } else payamt = @"0";
    NSDictionary* dict = @{@"agentid": @(_agentid), @"orderid": _strorderid, @"payamt": payamt};
    [self JDStatusBarHidden:NO status:@"Processing payment..." duration:0];
    DataFetcher* df = [DataFetcher new];
    [df postPayment:dict];
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
