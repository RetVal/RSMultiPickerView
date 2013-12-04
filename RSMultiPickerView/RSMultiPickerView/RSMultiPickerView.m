//
//  RSMultiPickerView.m
//  RSMultiPickerView
//
//  Created by Closure on 12/4/13.
//  Copyright (c) 2013 RetVal. All rights reserved.
//

#import "RSMultiPickerView.h"
#include <objc/runtime.h>

@interface RSMultiPickerView() <UIPickerViewDataSource, UIPickerViewDelegate>
{
    @private
    NSMutableArray *_selectedItems;
}
@property (assign, nonatomic) BOOL iOS7;
@property (strong, nonatomic) UIPickerView *pickerView;
@end

@implementation RSMultiPickerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _selectedItems = [[NSMutableArray alloc] init];
        _pickerView = [[UIPickerView alloc] initWithFrame:frame];
        _iOS7 = [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 ? YES : NO;
        if (_iOS7) {
            UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleSelection:)];
            singleTapGestureRecognizer.numberOfTapsRequired = 1;
            [_pickerView addGestureRecognizer:singleTapGestureRecognizer];
        }
        [_pickerView setDelegate:self];
        [_pickerView setDataSource:self];
        [self addSubview:_pickerView];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        
        _selectedItems = [[NSMutableArray alloc] init];
        _pickerView = [[UIPickerView alloc] init];
        _iOS7 = [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 ? YES : NO;
        if (_iOS7) {
            UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleSelection:)];
            singleTapGestureRecognizer.numberOfTapsRequired = 1;
            [_pickerView addGestureRecognizer:singleTapGestureRecognizer];
        }
        [_pickerView setDelegate:self];
        [_pickerView setDataSource:self];
        [self addSubview:_pickerView];
    }
    return self;
}

#pragma mark - 
#pragma mark UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    assert([[self dataSource] numberOfComponentsInPickerView:self] == 1);
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSInteger count = [[self dataSource] pickerView:self numberOfRowsInComponent:component] + 1;
    return count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (row == 0) return _checkAllTitle ? : @"Check All";
    NSInteger realRow = row - 1;
    return [[self delegate] pickerView:self titleForRow:realRow forComponent:component];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if ([[self delegate] respondsToSelector:@selector(pickerView:didSelectRow:inComponent:)]) {
        return [[self delegate] pickerView:self didSelectRow:row inComponent:component];
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UITableViewCell *cell = (UITableViewCell *)view;
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        [cell setBackgroundColor:[UIColor clearColor]];
        [cell setBounds: CGRectMake(0, 0, cell.frame.size.width -20 , 44)];
        if (YES) {
            if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
                UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellToggleSelection:)];
                singleTapGestureRecognizer.numberOfTapsRequired = 1;
                [cell addGestureRecognizer:singleTapGestureRecognizer];
            }
        }
    } else {
        NSLog(@"");
    }
    
    if (YES) {
        if ([_selectedItems indexOfObject:@(row)] != NSNotFound) {
            [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        } else {
            [cell setAccessoryType:UITableViewCellAccessoryNone];
        }
    }
    cell.textLabel.text = [self pickerView:[self pickerView] titleForRow:row forComponent:component];
    cell.tag = row;
    return cell;
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    if (aSelector == @selector(pickerView:viewForRow:forComponent:reusingView:) && _iOS7) {
        return YES;
    } else if (aSelector == @selector(pickerView:viewForRow:forComponent:reusingView:) && !_iOS7) {
        return NO;
    } else if ([[self dataSource] respondsToSelector:aSelector] || [[self delegate] respondsToSelector:aSelector]) {
        return YES;
    }
    return class_respondsToSelector([self class], aSelector);
}

- (void)cellToggleSelection:(UITapGestureRecognizer *)recognizer {
    NSNumber *row = @(recognizer.view.tag);
    if ([row integerValue] == [_pickerView selectedRowInComponent:0]) {
        if ([row integerValue] == 0) {
            // 全选
            if ([_selectedItems count] != [[self dataSource] pickerView:self numberOfRowsInComponent:0]) {
                [_selectedItems removeAllObjects];
                for (NSUInteger idx = 0; idx < [[self dataSource] pickerView:self numberOfRowsInComponent:0]; idx++) {
                    _selectedItems[idx] = @(idx);
                }
            } else {
                [_selectedItems removeAllObjects];
            }
            [_pickerView reloadComponent:0];
            return;
        }
        
        NSUInteger index = [_selectedItems indexOfObject:row];
        if (index != NSNotFound) {
            [_selectedItems removeObjectAtIndex:index];
            [_selectedItems removeObject:@(0)];
            [(UITableViewCell *)[_pickerView viewForRow:0 forComponent:0] setAccessoryType:UITableViewCellAccessoryNone];
            [[_pickerView viewForRow:0 forComponent:0] setNeedsDisplay];
            [(UITableViewCell *)(recognizer.view) setAccessoryType:UITableViewCellAccessoryNone];
        } else {
            [_selectedItems addObject:row];
            if ([_selectedItems count] + 1 == [[self dataSource] pickerView:self numberOfRowsInComponent:0]) {
                [_selectedItems removeAllObjects];
                for (NSUInteger idx = 0; idx < [[self dataSource] pickerView:self numberOfRowsInComponent:0]; idx++) {
                    _selectedItems[idx] = @(idx);
                }
                [(UITableViewCell *)[_pickerView viewForRow:0 forComponent:0] setAccessoryType:UITableViewCellAccessoryCheckmark];
                [[_pickerView viewForRow:0 forComponent:0] setNeedsDisplay];
            }
            [(UITableViewCell *)(recognizer.view) setAccessoryType:UITableViewCellAccessoryCheckmark];
        }
    }
    else {
        [_pickerView selectRow:[row integerValue] inComponent:0 animated:YES];
    }
}

- (void)toggleSelection:(UITapGestureRecognizer *)recognizer {
    UIView * view = [_pickerView viewForRow:[_pickerView selectedRowInComponent:0] forComponent:0];
    CGRect bounds = [view bounds];
    CGPoint point = [recognizer locationInView:view];
    if (0 <= point.y && point.y <= bounds.size.height) {
        NSNumber *row = @([view tag]);
        if ([row integerValue] == 0) {
            if ([_selectedItems count] != [self pickerView:[self pickerView] numberOfRowsInComponent:0]) {
                [_selectedItems removeAllObjects];
                for (NSUInteger idx = 0; idx < [self pickerView:[self pickerView] numberOfRowsInComponent:0]; idx++) {
                    _selectedItems[idx] = @(idx);
                }
            } else {
                [_selectedItems removeAllObjects];
            }
            [_pickerView reloadComponent:0];
            return;
        }
        NSUInteger index = [_selectedItems indexOfObject:row];
        if (index != NSNotFound) {
            [_selectedItems removeObjectAtIndex:index];
            [_selectedItems removeObject:@(0)];
            [(UITableViewCell *)[_pickerView viewForRow:0 forComponent:0] setAccessoryType:UITableViewCellAccessoryNone];
            [[_pickerView viewForRow:0 forComponent:0] setNeedsDisplay];
            [(UITableViewCell *)(view) setAccessoryType:UITableViewCellAccessoryNone];
            [view setNeedsDisplay];
        } else {
            [_selectedItems addObject:row];
            if ([_selectedItems count] + 1 == [self pickerView:[self pickerView] numberOfRowsInComponent:0]) {
                [_selectedItems removeAllObjects];
                for (NSUInteger idx = 0; idx < [self pickerView:[self pickerView] numberOfRowsInComponent:0]; idx++) {
                    _selectedItems[idx] = @(idx);
                }
                [(UITableViewCell *)[_pickerView viewForRow:0 forComponent:0] setAccessoryType:UITableViewCellAccessoryCheckmark];
                [[_pickerView viewForRow:0 forComponent:0] setNeedsDisplay];
            }
            [(UITableViewCell *)(view) setAccessoryType:UITableViewCellAccessoryCheckmark];
            [view setNeedsDisplay];
        }
        [[recognizer view] setNeedsDisplay];
        [[recognizer view] setNeedsLayout];
    } else {
        NSInteger (^calculatePoint)(float fVal) = ^NSInteger(float fVal) {
            int i = (int)fVal;
            NSInteger val = i;
            if (fVal >= 0) {
                if ((fVal - i) > 0.5f) val++;
                else if (val == 2 && (fVal - i) >= 0.11f) val++;
            }
            else {
                val--;
                if ((i - fVal) > 0.32f) val--;
                else if (val == -2 && (i - fVal) > 0.19f) val--;
            }
            return val;
        };
        UIPickerView *currentPickerView = (UIPickerView *)[recognizer view];
        NSUInteger currentSelectRow = [_pickerView selectedRowInComponent:0];
        NSInteger row = 0;
        float rawCalc = (point.y) / bounds.size.height;
        NSInteger calcRow = calculatePoint(rawCalc);
        row = calcRow + currentSelectRow;
        row = row >= 0 ? row : 0;
        if (row >= 0) [currentPickerView selectRow:row inComponent:0 animated:YES];
    }
    return;
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    if ([[self dataSource] respondsToSelector:aSelector]) return [self dataSource];
    if ([[self delegate] respondsToSelector:aSelector]) return [self delegate];
    if ([_pickerView respondsToSelector:aSelector]) return _pickerView;
    return nil;
}
@end
