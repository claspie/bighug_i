//
//  ContactsViewController.m
//  Rabbtel
//
//  Created by WangYing on 2018/7/23.
//  Copyright © 2018 Teleclub. All rights reserved.
//

#import "ContactsViewController.h"
#import <ContactsWrapper.h>
#import <MBProgressHUD.h>

@interface ContactsViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic) NSMutableArray<CNContact *> *contacts;
@end

@implementation ContactsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[ContactsWrapper sharedInstance] getContactsWithContainerId:nil completionBlock:^(NSArray<CNContact *> * _Nullable contacts, NSError * _Nullable error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if (contacts)
        {
            self.contacts = [NSMutableArray arrayWithArray:contacts];
            [self.tblContacts reloadData];
        }
        else
        {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onBack:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.contacts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContactsCell" forIndexPath:indexPath];
    CNContact *contact = self.contacts[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", contact.givenName, contact.familyName];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        CNContact *selectedContact = self.contacts[indexPath.row];
        [[ContactsWrapper sharedInstance] deleteContact:selectedContact completionBlock:^(BOOL isSuccess, NSError * _Nullable error) {
            if (isSuccess)
            {
                [self.contacts removeObject:selectedContact];
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }
            else
            {
                NSLog(@"Delete contact failed with error : %@", error.localizedDescription);
            }
        }];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert)
    {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CNContact *selectedContact = self.contacts[indexPath.row];
    if (selectedContact.phoneNumbers.count > 0) {
        NSString* phoneNumber = [selectedContact.phoneNumbers objectAtIndex:0].value.stringValue;
        phoneNumber = [phoneNumber stringByAppendingString:@""];
        
        [self.delegate selectContactNumber:phoneNumber];
        [self onBack:nil];
    }
}

@end
