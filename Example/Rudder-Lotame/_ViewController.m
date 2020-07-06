//
//  _ViewController.m
//  Rudder-Lotame
//
//  Created by dhawal-rudder on 06/12/2020.
//  Copyright (c) 2020 dhawal-rudder. All rights reserved.
//

#import "_ViewController.h"
#import <Rudder/Rudder.h>

@interface _ViewController ()

@end

@implementation _ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [[RSClient sharedInstance] identify:@"new user"];
    [[RSClient sharedInstance] track:@"new event"];
    [[RSClient sharedInstance] screen:@"new screen"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
