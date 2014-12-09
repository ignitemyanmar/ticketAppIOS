//
//  LoginVC.m
//  BusOperator
//
//  Created by Macbook Pro on 5/15/14.
//  Copyright (c) 2014 Ignite Software Solution. All rights reserved.
//

#import "LoginVC.h"
#import "HomeSelectVC.h"
#import "DataFetcher.h"
#import "SelectOperatorVC.h"
#import "JDStatusBarNotification.h"
#import "AppDelegate.h"
#import "Reachability.h"

@interface LoginVC ()

@property (strong, nonatomic) Reachability* reachability;
@property (nonatomic) BOOL reachable;

@property (strong, nonatomic) IBOutlet UIView *bkgView;
@property (strong, nonatomic) IBOutlet UITextField *txtUsername;
@property (strong, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtip;

- (IBAction)Login:(id)sender;
- (IBAction)Register:(id)sender;
- (IBAction)Changeip:(id)sender;

@end

@implementation LoginVC

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
    
    [self addDashedBorder:_bkgView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishDownloadingToken:) name:@"finishDownloadingToken" object:nil];
    
    NSString* ipstr = [[NSUserDefaults standardUserDefaults] objectForKey:@"ip"];
    if (ipstr.length > 0) {
        _txtip.text = ipstr;
    }
    
    
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

-(void)addDashedBorder:(UIView*)view
{
    //border definitions
    CGFloat cornerRadius = 0;
    CGFloat borderWidth = 1;
    NSInteger dashPattern1 = 4;
    NSInteger dashPattern2 = 4;
    UIColor *lineColor = [UIColor blackColor];
    
    //drawing
    CGRect frame = view.bounds;
    
    CAShapeLayer *_shapeLayer = [CAShapeLayer layer];
    
    //creating a path
    CGMutablePathRef path = CGPathCreateMutable();
    
    //drawing a border around a view
    CGPathMoveToPoint(path, NULL, 0, frame.size.height - cornerRadius);
    CGPathAddLineToPoint(path, NULL, 0, cornerRadius);
    CGPathAddArc(path, NULL, cornerRadius, cornerRadius, cornerRadius, M_PI, -M_PI_2, NO);
    CGPathAddLineToPoint(path, NULL, frame.size.width - cornerRadius, 0);
    CGPathAddArc(path, NULL, frame.size.width - cornerRadius, cornerRadius, cornerRadius, -M_PI_2, 0, NO);
    CGPathAddLineToPoint(path, NULL, frame.size.width, frame.size.height - cornerRadius);
    CGPathAddArc(path, NULL, frame.size.width - cornerRadius, frame.size.height - cornerRadius, cornerRadius, 0, M_PI_2, NO);
    CGPathAddLineToPoint(path, NULL, cornerRadius, frame.size.height);
    CGPathAddArc(path, NULL, cornerRadius, frame.size.height - cornerRadius, cornerRadius, M_PI_2, M_PI, NO);
    
    //path is set as the _shapeLayer object's path
    _shapeLayer.path = path;
    CGPathRelease(path);
    
    _shapeLayer.backgroundColor = [[UIColor clearColor] CGColor];
    _shapeLayer.frame = frame;
    _shapeLayer.masksToBounds = NO;
    [_shapeLayer setValue:[NSNumber numberWithBool:NO] forKey:@"isCircle"];
    _shapeLayer.fillColor = [[UIColor clearColor] CGColor];
    _shapeLayer.strokeColor = [lineColor CGColor];
    _shapeLayer.lineWidth = borderWidth;
    _shapeLayer.lineDashPattern = [NSArray arrayWithObjects:[NSNumber numberWithInt:dashPattern1], [NSNumber numberWithInt:dashPattern2], nil];
    _shapeLayer.lineCap = kCALineCapRound;
    
    //_shapeLayer is added as a sublayer of the view, the border is visible
    [view.layer addSublayer:_shapeLayer];
    view.layer.cornerRadius = cornerRadius;
}

- (void)finishDownloadingToken:(NSNotification*)noti
{
    /* {
     "access_token": "9T5TqEAy8H4PY8fKC3RMAywHWFFHtvJHt1QeVW3r",
     "token_type": "bearer",
     "expires": 1404100926,
     "expires_in": 604800,
     "refresh_token": "3QiZrXmWD3ScU2V40JAQfhqm7mJxH7PEu8w2ZSFd",
     "user": {
     "id": "3",
     "name": "Ignite",
     "type": "operator"
     }
     } */
    [self JDStatusBarHidden:YES status:@"" duration:0];
    
    NSDictionary* userinfo = (NSDictionary*)noti.object;
    
    [[NSUserDefaults standardUserDefaults] setObject:userinfo forKey:@"userinfo"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    NSString* usertype = userinfo[@"type"];
    if ([usertype isEqualToString:@"operator"]) {
        int userid = [userinfo[@"id"] intValue];
        [[NSUserDefaults standardUserDefaults] setInteger:userid forKey:@"opid"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [(AppDelegate *)[[UIApplication sharedApplication] delegate] setupTabBarController];

    }
    else {
        UIViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SelectOperatorVC"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    //
//    UIViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SelectTicketTypeVC"];
//    [self.navigationController pushViewController:vc animated:YES];


}

- (IBAction)Login:(id)sender {
    
    self.reachability = [Reachability reachabilityForInternetConnection];
    [self.reachability startNotifier];
    self.reachable = [self.reachability currentReachabilityStatus];
    
    if (self.reachable) {
        [self JDStatusBarHidden:NO status:@"Logging in..." duration:0];
        DataFetcher* fetcher = [DataFetcher new];
        [fetcher getAccessToken];

    }
    else {
        [self JDStatusBarHidden:NO status:@"Currently Not connected to internet. Now you are using offline sample mode of this App." duration:3];
        UIViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SelectOperatorVC"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    
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

- (BOOL)isValidIPAddress:(NSString*)iptext
{
    const char *utf8 = [iptext UTF8String];
    int success;
    
    struct in_addr dst;
    success = inet_pton(AF_INET, utf8, &dst);
    if (success != 1) {
        struct in6_addr dst6;
        success = inet_pton(AF_INET6, utf8, &dst6);
    }
    
    return (success == 1 ? TRUE : FALSE);
}



- (IBAction)Register:(id)sender {
}

- (IBAction)Changeip:(id)sender {
    
    BOOL isValid = [self isValidIPAddress:_txtip.text];
    
    if (isValid) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"http://%@/", _txtip.text] forKey:@"ip"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self JDStatusBarHidden:NO status:@"Successfully changed." duration:3.0f];
    }
    
}
@end
