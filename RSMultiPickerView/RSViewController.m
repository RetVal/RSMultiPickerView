//
//  RSViewController.m
//  RSMultiPickerView
//
//  Created by Closure on 12/4/13.
//  Copyright (c) 2013 RetVal. All rights reserved.
//

#import "RSViewController.h"
#import "RSMultiPickerView.h"
@interface RSViewController () <RSMultiPickerViewDataSource, RSMultiPickerViewDelegate>
@property (strong, nonatomic) NSArray *data;
@end

@implementation RSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _data = @[@"1", @"2", @"3", @"4", @"5"];
	// Do any additional setup after loading the view, typically from a nib.
}

#pragma mark - 
#pragma mark RSMultiPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(RSMultiPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(RSMultiPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [_data count];
}

#pragma mark - 
#pragma mark RSMultiPickerViewDelegate
- (NSString *)pickerView:(RSMultiPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return _data[row];
}

- (void)pickerView:(RSMultiPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSLog(@"hehe");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
