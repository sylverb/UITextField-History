//
//  ViewController.m
//  Demo
//
//  Created by DamonDing on 15/5/26.
//  Copyright (c) 2015年 morenotepad. All rights reserved.
//

#import "ViewController.h"
#import "UITextField+History.h"

#define TEXT_ID @"TEXT_ID"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.textfield.identify = TEXT_ID;

    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)hide:(id)sender {
    [self.textfield hideHistroy];
}

- (IBAction)show:(id)sender {
    [self.textfield showHistory];
}

- (IBAction)save:(id)sender {
    [self.textfield synchronize];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField;{
    if (textField == self.textfield) {
        [textField showHistory];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField; {
    if (textField == self.textfield) {
        [textField hideHistroy];
    }
}

@end
