//
//  ViewController.m
//  CircleSegment
//
//  Created by Anand on 5/10/14.
//  Copyright (c) 2014 Anand. All rights reserved.
//

#import "ViewController.h"
#import "CustomControl.h"
#import "MyCell.h"
#import "GoViewController.h"

@interface ViewController ()
-(void)navigationButtons;
-(void)showBottomButtons;
@end

NSString *kCellID = @"cellID";// UICollectionViewCell storyboard id

@implementation ViewController

- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"MON_Rectangle-5.png"]];
    
    NSArray  *small    =@[@"small batch",@"kind",@"large batch",@"mass market"];
    NSArray  *savory   =@[@"savory",@"sweet",@"umami",];
    NSArray  *spicy    =@[@"spicy",@"mild"];
    NSArray  *crunchy  =@[@"crunchy",@"mushy",@"smooth"];
    NSArray  *little   =@[@"a little",@"kind"];
    NSArray  *breakfast=@[@"breakfast",@"brunch",@"lunch",@"snack",@"dinner"];
    
    self.circleArchArray = [[NSMutableArray alloc]init];
    [self.circleArchArray addObject:small];
    [self.circleArchArray addObject:savory];
    [self.circleArchArray addObject:spicy];
    [self.circleArchArray addObject:crunchy];
    [self.circleArchArray addObject:little];
    [self.circleArchArray addObject:breakfast];
    
	// Do any additional setup after loading the view, typically from a nib.
    [self navigationButtons];
    [self showBottomButtons];
    
}

- (void)didReceiveMemoryWarning{
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)navigationButtons{
    
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchButton setImage:[UIImage imageNamed:@"MON_searchIcon.png"] forState:UIControlStateNormal];
    [searchButton addTarget:self action:@selector(searchButtonSelected) forControlEvents:UIControlEventTouchUpInside];
    [searchButton setFrame:CGRectMake(0, 0,45,45)];
    
    UIBarButtonItem *searchBtn = [[UIBarButtonItem alloc] initWithCustomView:searchButton];
    
    UIButton *calendarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [calendarButton setImage:[UIImage imageNamed:@"MON_calendarIcon.png"] forState:UIControlStateNormal];
    [calendarButton addTarget:self action:@selector(calendarButtonSelected) forControlEvents:UIControlEventTouchUpInside];
    [calendarButton setFrame:CGRectMake(0, 0,46,46)];
    
    UIButton *compassButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [compassButton setImage:[UIImage imageNamed:@"MON_compassIcon.png"] forState:UIControlStateNormal];
    [compassButton addTarget:self action:@selector(compassButtonSelected) forControlEvents:UIControlEventTouchUpInside];
    [compassButton setFrame:CGRectMake(0, 0,45,44)];
    
    
    UIBarButtonItem *secondBarButton = [[UIBarButtonItem alloc]initWithCustomView:calendarButton];
    UIBarButtonItem *thirdBarButton = [[UIBarButtonItem alloc]initWithCustomView:compassButton];
    
    UIButton *menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [menuButton setImage:[UIImage imageNamed:@"MON_menuIcon.png"] forState:UIControlStateNormal];
    [menuButton addTarget:self action:@selector(menuButtonSelected) forControlEvents:UIControlEventTouchUpInside];
    [menuButton setFrame:CGRectMake(0, 0,46,26)];
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithCustomView:menuButton];
    
    NSArray *navBtnArr = [[NSArray alloc] initWithObjects:searchBtn,secondBarButton,thirdBarButton, nil];
    
    NSArray *navRightBtnArr = [[NSArray alloc] initWithObjects:rightBtn, nil];
    
    self.navigationItem.leftBarButtonItems = navBtnArr;
    self.navigationItem.rightBarButtonItems = navRightBtnArr;

}
-(void)showBottomButtons{
    
    UIImageView *goBackGroundView = [[UIImageView alloc] initWithFrame:CGRectMake(100,460,50,50)];
    goBackGroundView.image = [UIImage imageNamed:@"MON_Ellipse-13-copy.png"];
    [self.view addSubview:goBackGroundView];
    
    UIImageView *goBackGroundView1 = [[UIImageView alloc] initWithFrame:CGRectMake(180,460,50,50)];
    goBackGroundView1.image = [UIImage imageNamed:@"MON_Ellipse-13-copy.png"];
    [self.view addSubview:goBackGroundView1];
    
    UIButton *goButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [goButton setImage:[UIImage imageNamed:@"MON_GO.png"] forState:UIControlStateNormal];
    [goButton addTarget:self action:@selector(goButtonSelected) forControlEvents:UIControlEventTouchUpInside];
    [goButton setFrame:CGRectMake(105, 465,40,40)];
    [self.view addSubview:goButton];
    
    UIButton *shuffleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [shuffleButton setImage:[UIImage imageNamed:@"MON_shuffleIcon.png"] forState:UIControlStateNormal];
    [shuffleButton addTarget:self action:@selector(shuffleButtonSelected) forControlEvents:UIControlEventTouchUpInside];
    [shuffleButton setFrame:CGRectMake(185, 465,40,40)];
    [self.view addSubview:shuffleButton];
}
-(void)searchButtonSelected{
    NSLog(@"Search");
}
-(void)calendarButtonSelected{
    NSLog(@"Calendar");
    
}
-(void)compassButtonSelected{
    NSLog(@"Compass");
}
-(void)menuButtonSelected{
    NSLog(@"Menu");
}
-(void)goButtonSelected{
    
    GoViewController *goView = [[GoViewController alloc] init];
    [[self navigationController] pushViewController:goView animated:NO];
    
}
-(void)shuffleButtonSelected{
    //shuffling archs array
    NSUInteger count = [self.circleArchArray count];
    for (NSUInteger i = 0; i < count; ++i) {
        // Select a random element between i and end of array to swap with.
        int numberElements = count - i;
        int n = (arc4random() % numberElements) + i;
        [self.circleArchArray exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
    [self.collectionView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section{
    
    return 6;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    // we're going to use a custom UICollectionViewCell, which will hold an image and its label
    MyCell *cell = [cv dequeueReusableCellWithReuseIdentifier:kCellID forIndexPath:indexPath];
    [cell.circleSegment  createArcViews:[self.circleArchArray objectAtIndex:indexPath.row]];
    return cell;
}

@end
