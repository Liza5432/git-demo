#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIImageView *canvas;
@property (nonatomic) CGPoint lastPoint;
@property (strong, nonatomic) UIColor *currentColor;
@property (nonatomic) CGFloat currentLineWidth;

// Методы для Storyboard
- (IBAction)Red:(id)sender;
- (IBAction)Brown:(id)sender;
- (IBAction)Blue:(id)sender;
- (IBAction)Green:(id)sender;
- (IBAction)Black:(id)sender;

- (IBAction)width1:(id)sender;
- (IBAction)width3:(id)sender;
- (IBAction)width5:(id)sender;
- (IBAction)width10:(id)sender;
- (IBAction)width15:(id)sender;

- (IBAction)saveImageToGallery:(id)sender;

@end
