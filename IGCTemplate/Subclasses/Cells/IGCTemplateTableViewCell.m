//
//  IGCTemplateTableViewCell.m
//  IGCTemplate
//
//  Created by Jason Jon E. Carreos on 09/08/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "IGCTemplateTableViewCell.h"

@implementation IGCTemplateTableViewCell

+ (NSString *)identifier {
    // NOTE Implementation is per subclass.
    //      Should return the identifier indicated in cell's corresponding XIB file
    
    return nil;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configure:(id)object atIndexPath:(NSIndexPath *)indexPath {
    // NOTE Implementation is per subclass
    //      This is where the cell content is filled in, along with its logic and data handling
}

@end
