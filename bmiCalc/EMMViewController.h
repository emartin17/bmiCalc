//
//  EMMViewController.h
//  bmiCalc
//
//  Created by Eric Martin on 6/25/14.
//  Copyright (c) 2014 Martin Developments. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EMMViewController : UIViewController <UITextFieldDelegate>

{
    IBOutlet UITextField *weightField;
    IBOutlet UITextField *heightField;
    IBOutlet UITextField *ageField;
    IBOutlet UILabel *genderLabel;
    IBOutlet UISwitch *genderSwitch;

    IBOutlet UILabel *bmiLabel;
    IBOutlet UILabel *bmrLabel;

    IBOutlet UIProgressView *bmiScale;
    IBOutlet UIProgressView *bmrScale;
}

@property (nonatomic, retain) UITextField *activeField;
@property (nonatomic, retain) UIButton *btnDone;
@property (nonatomic, retain) UIButton *btnNext;
@property (nonatomic, retain) UIButton *btnPrev;

@property(readwrite, retain) UIView *inputAccessoryView;

-(void)autoCalculateBMI;
-(void)autoCalculateBMR;

-(UIToolbar*)createInputAccessoryView;

-(void)gotoPrevTextField;
-(void)gotoNextTextField;

-(IBAction)toggleGender:(id)sender;

@end
