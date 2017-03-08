//
//  RadioViewController.m
//  App
//
//  Created by Amy Kelly on 08/03/2017.
//  Copyright © 2017 Amy Kelly. All rights reserved.
//

#import "RadioViewController.h"

@interface RadioViewController ()

@end

@implementation RadioViewController


- (void) viewDidLoad {
    [super viewDidLoad];
    
    
    
    
}

- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (IBAction)Play:(id)sender {
    
    NSString *stream = @"http://boxuk.danceradiouk.com/";
    NSURL *url = [NSURL URLWithString: stream];
    NSURLRequest *urlrequest = [NSURLRequest requestWithURL: url];
    [Webview loadRequest:urlrequest];
    
}

@end
