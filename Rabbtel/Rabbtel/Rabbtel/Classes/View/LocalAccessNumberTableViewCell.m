//
//  LocalAccessNumberTableViewCell.m
//  Rabbtel
//
//  Created by WangYing on 2018/9/4.
//  Copyright © 2018 Teleclub. All rights reserved.
//

#import "LocalAccessNumberTableViewCell.h"

@implementation LocalAccessNumberTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellTitle:(NSString*)title
{
    [self.lblCellTitle setText:title];
}

- (void)setCellChecked:(BOOL)checked
{
    self.ivCellImage.hidden = !checked;
}

@end
