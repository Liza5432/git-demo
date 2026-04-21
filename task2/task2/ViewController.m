#import "ViewController.h"

@interface ViewController ()


@property (weak, nonatomic) IBOutlet UIButton *Button;
@property (weak, nonatomic) IBOutlet UITextField *cityInput;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UILabel *adressLabel;
@property (weak, nonatomic) IBOutlet UIImageView *hospitalImage;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)Button:(id)sender {
    NSDictionary *citiesData = @{
        @"Kiev":   @{@"temp": @15, @"img": @"p3.jpg", @"addr": @"hosp_kiev_addr"},
        @"Odessa": @{@"temp": @18, @"img": @"p2.jpg", @"addr": @"hosp_odessa_addr"},
        @"Minsk":  @{@"temp": @12, @"img": @"p1.jpg", @"addr": @"hosp_minsk_addr"},
        @"Brest":  @{@"temp": @14, @"img": @"p4.jpg", @"addr": @"hosp_brest_addr"},
        @"Warsaw": @{@"temp": @17, @"img": @"p5.jpg", @"addr": @"hosp_warsaw_addr"},
        @"Krakow": @{@"temp": @9,  @"img": @"p6.jpg", @"addr": @"hosp_krakow_addr"}
    };

    NSDictionary *inputToKey = @{
        @"Киев": @"Kiev", @"Киеў": @"Kiev", @"Kiev": @"Kiev",
        @"Одесса": @"Odessa", @"Адэсса": @"Odessa", @"Odessa": @"Odessa",
        @"Минск": @"Minsk", @"Мінск": @"Minsk", @"Minsk": @"Minsk",
        @"Брест": @"Brest", @"Брэст": @"Brest", @"Brest": @"Brest",
        @"Варшава": @"Warsaw", @"Варшава": @"Warsaw", @"Warsaw": @"Warsaw",
        @"Краков": @"Krakow", @"Кракаў": @"Krakow", @"Krakow": @"Krakow"
    };

    NSString *userInput = [self.cityInput.text capitalizedString];
    NSString *cityKey = inputToKey[userInput];

    if (cityKey) {
        NSDictionary *details = citiesData[cityKey];
        int temp = [details[@"temp"] intValue];

        NSString *localizedCity = NSLocalizedString(cityKey, nil);
        NSString *format = NSLocalizedString(@"weather_report", nil);
        NSString *fullText = [NSString stringWithFormat:format, localizedCity, temp];

        UIColor *textColor;
        if (temp < 10) {
            textColor = [UIColor blueColor];
        } else if (temp <= 20) {
            textColor = [UIColor greenColor];
        } else {
            textColor = [UIColor redColor];
        }

        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:fullText];
        [attrStr addAttribute:NSForegroundColorAttributeName value:textColor range:NSMakeRange(0, fullText.length)];
        
        [self.infoLabel setAttributedText:attrStr];
        self.hospitalImage.image = [UIImage imageNamed:details[@"img"]];
        self.adressLabel.text = NSLocalizedString(details[@"addr"], nil);

    } else {
        self.infoLabel.text = NSLocalizedString(@"unknown_city", nil);
        self.hospitalImage.image = nil;
        self.adressLabel.text = @"";
    }
    
    [self.view endEditing:YES];
}

@end
