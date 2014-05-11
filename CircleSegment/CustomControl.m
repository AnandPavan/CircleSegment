//
//  CustomControl.m
//  CustomButton
//
//  Created by Anand on 5/7/14.
//  Copyright (c) 2014 Anand. All rights reserved.
//

#import "CustomControl.h"
// pi is approximately equal to 3.14159265359.
#define  DEGREES_TO_RADIANS(degrees)  ((3.14159265359 * degrees)/ 180)
#define  ARC_START_POSITION 10
#define  ANGLE_SPACE 20
#define  SQUARE_HEIGHT 100
#define  CIRCLE_ANGLE 360
#define  ARC_WIDTH 3.0
#define  DARK_RED  [UIColor colorWithRed:(102/255.0) green:(0/255) blue:(0/255.0) alpha:1.0]

@interface CustomControl()

@property(nonatomic,strong)NSMutableArray *arcPathArray;
@property(nonatomic,strong)NSMutableArray *informationArray;

@end

@implementation CustomControl

- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        _arcPathArray = [[NSMutableArray alloc] init];
        _informationArray  = [[NSMutableArray alloc] init];
        self.isFromTapEvent = NO;
    }
    return self;
}
//creating archs for circle
- (void)createArcViews:(NSArray*)aInformationArray{
    
    _arcPathArray = [[NSMutableArray alloc] init];
    _informationArray  = [[NSMutableArray alloc] init];
    [_informationArray removeAllObjects];
    [_informationArray setArray:aInformationArray];
    [_arcPathArray removeAllObjects];
    [self setNeedsDisplay];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapEvent:)];
    tapGesture.numberOfTapsRequired = 1;
    [tapGesture setDelegate:self];
    [self addGestureRecognizer:tapGesture];
}
//finding selected arch
- (NSInteger)findselectedArcIndex:(CGPoint )point{
    
    int i = 0;
    for (UIBezierPath *tempPath in _arcPathArray) {
        BOOL lResult = [self containsPoint:point onPath:tempPath inFillArea:YES];
        i++;
        if(lResult)
        return i;
    }
    return -1;
}

- (void)tapEvent:(UIGestureRecognizer *)gestureRecognizer{
    
    CGPoint touchPoint = [(UITapGestureRecognizer*)gestureRecognizer locationInView:self];
    NSInteger selectedArc = [self findselectedArcIndex:touchPoint];
    
    self.isFromTapEvent = YES;
    if(selectedArc >= 0){
        self.selectedString = [self.informationArray objectAtIndex:(selectedArc-1)];
    }
    
    [self setNeedsDisplay];
    NSLog(@"selectedArc = %ld",(long)selectedArc);
}

- (UIBezierPath *)createArcPathStartAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle radius:(CGFloat)radius{
    
    UIBezierPath *aPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(75,64)
                                                         radius:radius
                                                     startAngle:DEGREES_TO_RADIANS(startAngle)
                                                       endAngle:DEGREES_TO_RADIANS(endAngle) //DEGREES_TO_RADIANS(180)
                                                      clockwise:YES];
    return aPath;
}



// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect{
    
    CGFloat pointX;
    CGFloat pointY;
    CGFloat radius;
    CGFloat heightOffset = (self.bounds.size.height - self.bounds.size.width)-(ARC_START_POSITION*2);
    CGFloat sqareHeight = self.bounds.size.width-(ARC_START_POSITION*2);
    //Create a Square and calcuate radius
    radius = sqareHeight/2;
    pointX = ARC_START_POSITION+radius;
    pointY = (heightOffset/2)+radius;
    UIBezierPath *circle = [UIBezierPath bezierPathWithArcCenter:CGPointMake(75,64)                                                                       radius:50
                                                      startAngle:0
                                                        endAngle:360
                                                       clockwise:YES];
    [[UIColor blackColor] set];
    [circle fill];
    [circle closePath];
    
    [self drawArchs:_informationArray];
    if(!self.isFromTapEvent){
        self.selectedString = [_informationArray objectAtIndex:0];
    }
    if(self.selectedString != nil && [self.selectedString length] > 0){
        [self titleOfCircle:[self.selectedString uppercaseString]];
    }
}

-(void)drawArchs:(NSArray *)archsArray{
    
    if([archsArray count] > 0){
        CGFloat startAngle = 0;
        CGFloat endAngleOffset = (CIRCLE_ANGLE-([archsArray count]*ANGLE_SPACE))/[_informationArray count];
        
        for (int i=0; i<[archsArray count];i++) {
            if(i==0){
                startAngle = 0;
            }
            else{
                startAngle = (endAngleOffset*i)+(ANGLE_SPACE*i);
            }
            CGFloat endAngle = endAngleOffset+startAngle;
            
            UIBezierPath *arcPath = [self createArcPathStartAngle:startAngle endAngle:endAngle radius:53];
            arcPath.lineWidth = 1;
            if(i==1){
                [[UIColor redColor] set];
            }
            else{
                [DARK_RED set];
            }
            [arcPath stroke];
            [arcPath closePath];
            
            [_arcPathArray addObject:arcPath];
        }
    }
}
//to display title of circle
-(void)titleOfCircle:(NSString *)string{
    
    //self.label.text = Nil;
    /// Make a copy of the default paragraph style
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    /// Set line break mode
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    /// Set text alignment
    paragraphStyle.alignment = NSTextAlignmentCenter;
    UIFont *font = [UIFont fontWithName:@"Helvetica Neue" size:11.0];
    if(font != nil){
    NSDictionary *attributes = @{NSFontAttributeName: font,
                                 NSParagraphStyleAttributeName: paragraphStyle, NSForegroundColorAttributeName:[UIColor whiteColor]};
    [string drawInRect:CGRectMake(10.0, 57.0, self.frame.size.width-40 , self.frame.size.height-40) withAttributes:attributes];
    }

}
//Determine the hit point
- (BOOL)containsPoint:(CGPoint)point onPath:(UIBezierPath *)path inFillArea:(BOOL)inFill{
    
    UIGraphicsBeginImageContext(self.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGPathRef cgPath = path.CGPath;
    BOOL    isHit = NO;
    
    // Determine the drawing mode to use. Default to
    // detecting hits on the stroked portion of the path.
    CGPathDrawingMode mode = kCGPathStroke;
    if (inFill){
        
        // Look for hits in the fill area of the path instead.
        if (path.usesEvenOddFillRule)
            mode = kCGPathEOFill;
        else
            mode = kCGPathFill;
    }
    // Save the graphics state so that the path can be
    // removed later.
    CGContextSaveGState(context);
    CGContextAddPath(context, cgPath);
    // Do the hit detection.
    isHit = CGContextPathContainsPoint(context, point, mode);
    //NSLog(@"isHit = %d",isHit);
    return isHit;
}


@end
