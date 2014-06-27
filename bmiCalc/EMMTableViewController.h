//
//  EMMTableViewController.h
//  bmiCalc
//
//  Created by Eric Martin on 6/26/14.
//  Copyright (c) 2014 Martin Developments. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EMMTableViewController : UITableViewController
<UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate>

{
    IBOutlet UITextField *weightField;
    IBOutlet UITextField *heightField;
    IBOutlet UITextField *ageField;
    IBOutlet UITextField *genderField;
    
    IBOutlet UILabel *bmiLabel;
    IBOutlet UILabel *bmrLabel;
    
    IBOutlet UIProgressView *bmiScale;
    IBOutlet UIProgressView *bmrScale;
    
    IBOutlet UILabel *weightUnits;
    IBOutlet UILabel *heightUnits;
    
    IBOutlet UISegmentedControl *unitsControl;
    
    IBOutlet UITableViewCell *imperialHeight;
    IBOutlet UITableViewCell *metricHeight;
}

@property (strong,nonatomic) NSArray *genderArray;
@property (strong,nonatomic) NSArray *textFieldArray;


@property (nonatomic, retain) UITextField *activeField;
@property (nonatomic, retain) UIButton *btnDone;
@property (nonatomic, retain) UIButton *btnNext;
@property (nonatomic, retain) UIButton *btnPrev;

@property(readwrite, retain) UIView *inputAccessoryView;

-(void)outputBMI;
-(void)outputBMR;
-(void)checkBoth;

-(void)clearBMI;
-(void)clearBMR;

-(UIToolbar*)createInputAccessoryView;

-(void)gotoPrevTextField;
-(void)gotoNextTextField;

-(IBAction)switchUnits:(id)sender;



@end
