//
//  LocalAccessNumberViewController.m
//  Rabbtel
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
                                 @"Toronto, Ontario",
                                 @"Kitchener, Ontario",
                                 @"Waterloo, Ontario",
                                 @"Vancouver, BC",
                                 @"Calgary, AB",
                                 @"Edmonton, AB",
                                 @"Regina, SK",
                                 @"Sasktoon",
                                 @"Quebec City, QC",
                                 @"California, USA",
                                 @"Seattle USA",
                                 nil];

    self.localAccessNumbers = [NSArray arrayWithObjects:
                               @"647-258-9522",
                               @"519-489-1258",
                               @"519-804-1500",
                               @"778-785-2088",
                               @"403-775-9675",
                               @"780-669-4412",
                               @"306-206-0428",
                               @"306-500-0282",
                               @"418-263-4479",
                               @"213-289-5005",
                               @"206-582-0797",
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
