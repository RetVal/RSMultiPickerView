//
//  RSMultiPickerView.h
//  RSMultiPickerView
//
//  Created by Closure on 12/4/13.
//  Copyright (c) 2013 RetVal. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol RSMultiPickerViewDelegate, RSMultiPickerViewDataSource;
@interface RSMultiPickerView : UIView
@property (weak, nonatomic) IBOutlet id<RSMultiPickerViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet id<RSMultiPickerViewDataSource> dataSource;
@property (strong, nonatomic) NSArray *selectedItems;

@property (strong, nonatomic) NSString *checkAllTitle; // default as "Check All"
@end

@protocol RSMultiPickerViewDelegate <NSObject>
@required
- (NSString *)pickerView:(RSMultiPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;

@optional
- (CGFloat)pickerView:(RSMultiPickerView *)pickerView widthForComponent:(NSInteger)component;
- (CGFloat)pickerView:(RSMultiPickerView *)pickerView rowHeightForComponent:(NSInteger)component;
- (UIView *)pickerView:(RSMultiPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view;

- (void)pickerView:(RSMultiPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component;
@end

@protocol RSMultiPickerViewDataSource <NSObject>
@required
- (NSInteger)numberOfComponentsInPickerView:(RSMultiPickerView *)pickerView; // must be 1
- (NSInteger)pickerView:(RSMultiPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
@end
