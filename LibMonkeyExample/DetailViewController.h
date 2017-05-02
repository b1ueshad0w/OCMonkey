//
//  DetailViewController.h
//  LibMonkeyExample
//
//  Created by gogleyin on 02/05/2017.
//
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) NSDate *detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

