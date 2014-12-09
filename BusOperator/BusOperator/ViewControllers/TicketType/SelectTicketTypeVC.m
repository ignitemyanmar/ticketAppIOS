//
//  SelectTicketTypeVC.m
//  BusOperator
//
//  Created by Macbook Pro on 6/12/14.
//  Copyright (c) 2014 Ignite Software Solution. All rights reserved.
//

#import "SelectTicketTypeVC.h"
#import "TicketTypeCell.h"
#import "DataFetcher.h"
#import "JDStatusBarNotification.h"
#import "AppDelegate.h"

@interface SelectTicketTypeVC () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray* dataFiller;
@property (strong, nonatomic) IBOutlet UITableView *tbTicketTypeList;


@end

@implementation SelectTicketTypeVC

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
    
    self.title = @"Select Ticket Type";
    
    [[NSUserDefaults standardUserDefaults] setObject:@"selecttickettypevc" forKey:@"currentvc"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishGetTicketTypeList:) name:@"finishGetTicketTypeList" object:nil];
    
    [self JDStatusBarHidden:NO status:@"Retrieving data..." duration:0];
    DataFetcher* fetcher = [DataFetcher new];
    [fetcher getTicketTypeList];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)finishGetTicketTypeList:(NSNotification*)noti
{
    [self JDStatusBarHidden:YES status:@"" duration:0];
    NSArray* tempArr = (NSArray*)noti.object;
    _dataFiller = [tempArr copy];
    
    [_tbTicketTypeList reloadData];
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


# pragma mark - UITableview Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataFiller.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* cellid = @"tickettypeCell";
    TicketTypeCell* cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    NSDictionary* dict = _dataFiller[indexPath.row];
    cell.cellLabel.text = dict[@"name"];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    TicketTypeCell* customCell = (TicketTypeCell*)cell;
    customCell.cellBkgView.layer.cornerRadius = 5;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* dict = _dataFiller[indexPath.row];
    [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"tickettype"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSDictionary* userinfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"userinfo"];
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

//    UIViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginVC"];
//    [self.navigationController pushViewController:vc animated:YES];
    
}

@end
