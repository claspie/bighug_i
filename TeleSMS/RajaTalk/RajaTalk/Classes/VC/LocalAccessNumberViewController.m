//
//  LocalAccessNumberViewController.m
//  RajaTalk
//
//  Created by WangYing on 2018/9/4.
//  Copyright © 2018 Teleclub. All rights reserved.
//

#import "LocalAccessNumberViewController.h"
#import "LocalAccessNumberTableViewCell.h"
#import "Util.h"

@interface LocalAccessNumberViewController () <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) NSArray *localAccessAddresses;
@property (strong, nonatomic) NSArray *localAccessNumbers;

@end

@implementation LocalAccessNumberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.localAccessAddresses = [NSArray arrayWithObjects:
                                 @"Calgary",
                                 @"Ontario",
                                 @"Sasktoon",
                                 @"Regina",
                                 @"Edmonton",
                                 @"UK (national # )",
                                 @"Ottawa",
                                 @"Montreal Quebec",
                                 @"Vancouver",
                                 @"France",
                                 @"New Zealand",
                                 @"Mexico Cancun",
                                 @"Isreal",
                                 @"HongKong",
                                 @"Australia Melbourne",
                                 @"Australia Sydney",
                                 @"Hamilton (In Canada)",
                                 @"USA",
                                 @"Chicago",
                                 nil];

    self.localAccessNumbers = [NSArray arrayWithObjects:
                               @"587-288-0662",
                               @"416-477-0053",
                               @"306-803-5965",
                               @"306-993-4657",
                               @"780-851-1777",
                               @"03300270193",
                               @"613-693-1286",
                               @"438-788-1530",
                               @"778-783-0022",
                               @"0975122807",
                               @"036694781",
                               @"09982876739",
                               @"0772200053",
                               @"39733713",
                               @"386580564",
                               @"280730557",
                               @"(289)309-5505",
                               @"(469)283-2773",
                               @"773-897-9819",
                               nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.localAccessAddresses.count;
}

#pragma mark - UITableView Delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LocalAccessNumberTableViewCell* cell = (LocalAccessNumberTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"localAccessNumberCell" forIndexPath:indexPath];
    if (!cell) {
        cell = (LocalAccessNumberTableViewCell*)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"localAccessNumberCell"];
    }
    
    NSString *title = [NSString stringWithFormat:@"%@, %@", self.localAccessAddresses[indexPath.row], self.localAccessNumbers[indexPath.row]];
    [cell setCellTitle:title];
    
    NSInteger currentIndex = [Util getLocalAccessNumber];
    if (currentIndex >= 0 && currentIndex < self.localAccessAddresses.count && currentIndex == indexPath.row) {
        [cell setCellChecked:YES];
    } else {
        [cell setCellChecked:NO];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [Util setLocalAccessNumber:indexPath.row];
    [self.tblAcessNumber reloadData];
}

- (IBAction)onBack:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}


@end
