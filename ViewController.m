//
//  ViewController.m
//  Localization
//
//  Created by prasanthi on 1/21/15.
//  Copyright (c) 2015 prasanthi. All rights reserved.
//

#import "ViewController.h"
#import "Localizationfiles.h"

@interface ViewController ()

@end

@implementation ViewController
NSString *banknamelabel;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(localize) name:LocalizationfileLanguageDidChangeNotification object:nil];
    
    [self localize];

}

- (void)localize
{
    _banknamelabel
    = [Localizationfile stringForKey:@"AED"];
     _banknamelabel = [Localizationfile stringForKey:@"Agricultural Bank"];
     _banknamelabel  = [Localizationfile stringForKey:@"Yes Bank"];
    _banknamelabel = [Localizationfile stringForKey:@"An Express"];
     _banknamelabel = [Localizationfile stringForKey:@"Andhra Bank"];
     _banknamelabel = [Localizationfile stringForKey:@"ATM Cash"];
    _banknamelabel = [Localizationfile stringForKey:@"Banamex"];
}

- (IBAction)Spanish:(id)sender {
    [Localizationfile sharedInstance].language = @"Sp";
}

    



- (IBAction)English:(id)sender {
    [Localizationfile sharedInstance].language = @"en";

}

- (IBAction)Chinese:(id)sender {
    [Localizationfile sharedInstance].language = @"Ch";

}

- (IBAction)Philipinnes:(id)sender {
    [Localizationfile sharedInstance].language = @"Fi";

}
@end
