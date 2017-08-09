//
//  IGCTableViewCell.h
//  IGCTemplate
//
//  Created by Jason Jon E. Carreos on 09/08/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IGCTableViewCell : UITableViewCell

+ (NSString *)identifier;
- (void)configure:(id)object atIndexPath:(NSIndexPath *)indexPath;

@end
