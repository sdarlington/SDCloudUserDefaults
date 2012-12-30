//
//  WSLViewController.h
//  TestSDCloudUserDefaults
//
//  Created by Stephen Darlington on 30/12/2012.
//  Copyright (c) 2012 Wandle Software Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WSLViewController : UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *keyNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *valueTextField;

@end
