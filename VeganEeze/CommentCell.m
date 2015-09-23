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
- (void)updateCellWithComments:(NSString*)usersScreenName userComment:(NSString*)usersComment usersRating:(NSString *)usersRating {
    
    //Set items in cell to items passed into method
    username.text = usersScreenName;
    comment.text = usersComment;
    
    if ((usersRating != nil)) {
        
        //Add rating to cell
        NSString *ratingStr = [NSString stringWithFormat:@"Rating: %@ Stars", usersRating];
        
        rating.text = ratingStr;
        
    } else {
        //Hide rating label
        rating.hidden = TRUE;
    }
    
    
}

//Update event cells
-(void)updateCellWithEventComments:(NSString*)usersScreenName userComment:(NSString*)usersComment {
    
    username.text = usersScreenName;
    comment.text = usersComment;
    rating.hidden = TRUE;
}

@end
