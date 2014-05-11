//
//  CustomControl.h
//  CustomButton
//
//  Created by Anand on 5/7/14.
//  Copyright (c) 2014 Anand. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomControl : UIControl <UIGestureRecognizerDelegate>

@property(nonatomic,assign)BOOL      isFromTapEvent;
@property(nonatomic,strong)NSString  *selectedString;

- (void)createArcViews:(NSArray*)aInformationArray;

@end
