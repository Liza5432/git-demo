#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>


@interface FlightsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSString *cityFromStr;
@property (strong, nonatomic) NSString *cityToStr;
@property (strong, nonatomic) NSArray *flightsArray;
@property (strong, nonatomic) UITableView *tableView;

// Метод теперь возвращает сам объект (instancetype), чтобы работала цепочка вызовов
- (instancetype)initWithBothCity:(NSString *)fromCity :(NSString *)toCity;

@end
