//
//  WSLViewController.m
//  TestSDCloudUserDefaults
//
//  Created by Stephen Darlington on 30/12/2012.
//  Copyright (c) 2012 Wandle Software Limited. All rights reserved.
//

#import "WSLViewController.h"
#import "SDCloudUserDefaults.h"

@implementation WSLViewController

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
