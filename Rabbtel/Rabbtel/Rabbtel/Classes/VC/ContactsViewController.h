//
//  ContactsViewController.h
//  Rabbtel
//
//  Created by WangYing on 2018/7/23.
//  Copyright © 2018 Teleclub. All rights reserved.
//

#import "BaseViewController.h"

@protocol ContactsViewControllerDelegate <NSObject>
- (void)selectContactNumber:(NSString*)number;
@end

@interface ContactsViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UITableView *tblContacts;
@property (nonatomic, weak) id <ContactsViewControllerDelegate> delegate;

@end
