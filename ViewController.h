//
//  ViewController.h
//  Localization
//
//  Created by prasanthi on 1/21/15.
//  Copyright (c) 2015 prasanthi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (strong, nonatomic) IBOutletCollection(UILabel) NSString *banknamelabel;

- (IBAction)Spanish:(id)sender;
- (IBAction)English:(id)sender;
- (IBAction)Chinese:(id)sender;
- (IBAction)Philipinnes:(id)sender;


@end

