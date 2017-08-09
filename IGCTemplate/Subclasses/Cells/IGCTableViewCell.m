//
//  IGCTableViewCell.m
//  IGCTemplate
//
//  Created by Jason Jon E. Carreos on 09/08/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "IGCTableViewCell.h"

#pragma mark - Private Constants

// NOTE Put your private constants here

#pragma mark - Class Extension

@interface IGCTableViewCell ()

// NOTE Put your attributes here

@end

@implementation IGCTableViewCell

#pragma mark - Lifecycle

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Public Methods

+ (NSString *)identifier {
    // NOTE Implementation is per subclass.
    //      Should return the identifier indicated in cell's corresponding XIB file
    
    return nil;
}

- (void)configure:(id)object atIndexPath:(NSIndexPath *)indexPath {
    // NOTE Implementation is per subclass
    //      This is where the cell content is filled in, along with its logic and data handling
}

@end
