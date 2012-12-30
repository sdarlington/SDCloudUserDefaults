//
//  WSLViewController.m
//  TestSDCloudUserDefaults
//
//  Created by Stephen Darlington on 30/12/2012.
//  Copyright (c) 2012 Wandle Software Limited. All rights reserved.
//

#import "WSLViewController.h"
#import "SDCloudUserDefaults.h"

@interface WSLViewController ()

@end

@implementation WSLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextFieldDelegate

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@"\n"]) {
        [textField resignFirstResponder];
        return NO;
    }
    else {
        return YES;
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == self.keyNameTextField) {
        self.valueTextField.text = [SDCloudUserDefaults objectForKey:textField.text];
    }
    else if (textField == self.valueTextField) {
        [SDCloudUserDefaults setObject:textField.text forKey:self.keyNameTextField.text];
    }
}

@end
