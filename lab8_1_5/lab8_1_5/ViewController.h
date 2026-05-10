//
//  ViewController.h
//  lab8_1_5
//
//  Created by анус on 5/9/26.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@interface ViewController : UIViewController <UITextFieldDelegate, MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *cityFrom;
@property (weak, nonatomic) IBOutlet UITextField *cityTo;
- (IBAction)showFlights:(id)sender;


@end

