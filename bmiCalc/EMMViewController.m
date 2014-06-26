//
//  EMMViewController.m
//  bmiCalc
//
//  Created by Eric Martin on 6/25/14.
//  Copyright (c) 2014 Martin Developments. All rights reserved.
//

#import "EMMViewController.h"
#import "EMMPatient.h"

@implementation EMMViewController
@synthesize activeField;
@synthesize inputAccessoryView;
@synthesize btnDone;
@synthesize btnNext;
@synthesize btnPrev;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == weightField)
    {
        [heightField becomeFirstResponder];
    }
    [textField resignFirstResponder];
    [self autoCalculateBMI];
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [self autoCalculateBMI];
    if([heightField.text isEqualToString:@""] && [weightField.text isEqualToString:@""])
    {
        bmiLabel.hidden = TRUE;
        bmiScale.hidden = TRUE;
    }
    
    
    return YES;
}


-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    UIToolbar *toolbar = [self createInputAccessoryView];
    [toolbar sizeToFit];
    
    
    
    [textField setInputAccessoryView: toolbar];
    
    activeField = textField;
}


-(void)autoCalculateBMI
{
    if(![weightField.text  isEqual: @""] && ![heightField.text  isEqual: @""])
    {
        bmiLabel.hidden = FALSE;
        bmiScale.hidden = FALSE;
        EMMPatient *patient = [EMMPatient thePatient];
        [patient setHeight:[NSNumber numberWithFloat:[heightField.text floatValue]]];
        [patient setWeight:[NSNumber numberWithFloat:[weightField.text floatValue]]];
        float progessbar = [patient bmi];
        progessbar = progessbar - 15;
        progessbar = progessbar/15;
        bmiScale.progress = progessbar;
        bmiLabel.text = [NSString stringWithFormat:@"BMI: %g",[patient bmi]];
    }
    if (![weightField.text  isEqual: @""] && ![heightField.text  isEqual: @""] && ![ageField.text isEqualToString:@""])
    {
        bmrLabel.hidden = FALSE;
        bmrScale.hidden = FALSE;
        EMMPatient *patient = [EMMPatient thePatient];
        [patient setHeight:[NSNumber numberWithFloat:[heightField.text floatValue]]];
        [patient setWeight:[NSNumber numberWithFloat:[weightField.text floatValue]]];
        [patient setAge:[NSNumber numberWithInt:[ageField.text intValue]]];
        [patient setGender:genderSwitch.on];
        float progressbar = [patient bmr];
        progressbar = progressbar - 1475;
        progressbar = progressbar/1025;
        bmrScale.progress = progressbar;
        bmrLabel.text = [NSString stringWithFormat:@"BMR: %g",[patient bmr]];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [weightField resignFirstResponder];
    [heightField resignFirstResponder];
    [ageField resignFirstResponder];
}

-(void)gotoPrevTextField
{
    if(activeField == heightField)
    {
        [weightField becomeFirstResponder];
    }
}

-(void)gotoNextTextField
{
    if(activeField == weightField)
    {
        [heightField becomeFirstResponder];
    }
}


-(UIToolbar*)createInputAccessoryView
{
    //UIColor* color = [UIColor colorWithRed: 0.812 green: 0.812 blue: 0.812 alpha: 1];
    
    inputAccessoryView = [[UIView alloc]initWithFrame:CGRectMake(10.0, 0.0, 310.0, 40.0)];
    [inputAccessoryView setBackgroundColor:[UIColor lightGrayColor]];
    [inputAccessoryView setAlpha:0.8];
    
    UIBarButtonItem *prevButton = [[UIBarButtonItem alloc]
                                   initWithTitle: @"Previous"
                                   style: UIBarButtonItemStyleDone
                                   target: self
                                   action:@selector(gotoPrevTextField)];
    
    UIBarButtonItem *nextButton = [[UIBarButtonItem alloc]
                                   initWithTitle: @"Next"
                                   style: UIBarButtonItemStyleDone
                                   target: self
                                   action:@selector(gotoNextTextField)];
    
    UIBarButtonItem *flexButton = [[UIBarButtonItem alloc]
                                   initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace
                                   target: self
                                   action: nil];
    
    UIBarButtonItem *doneButton =[[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem: UIBarButtonSystemItemDone
                                  target: self
                                  action:@selector(touchesBegan:withEvent:)];
    
    NSArray *itemsArray = @[prevButton, nextButton, flexButton, doneButton];
    
    UIToolbar *bar = [[UIToolbar alloc]init];
    [bar setItems: itemsArray];
    return bar;
}


-(IBAction)toggleGender:(id)sender
{
    if (genderSwitch.on == NO) {
        genderLabel.text = @"female";
    }
    else
    {
        genderLabel.text = @"male";
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
