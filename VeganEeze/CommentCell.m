//
//  CommentCell.m
//  VeganEeze
//
//  Created by Brandon Ruger on 8/24/15.
//  Copyright (c) 2015 Brandon Ruger. All rights reserved.
//

#import "CommentCell.h"

@implementation CommentCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//Method to update custom cell with comments
- (void)updateCellWithComments:(NSString*)usersScreenName userComment:(NSString*)usersComment {
    
    //Set items in cell to items passed into method
    username.text = usersScreenName;
    comment.text = usersComment;
}

@end
