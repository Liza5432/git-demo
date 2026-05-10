#import "FlightsViewController.h"
#import "AppDelegate.h" // Обязательно для работы с persistentContainer

@implementation FlightsViewController

- (instancetype)initWithBothCity:(NSString *)fromCity :(NSString *)toCity {
    self = [super init];
    if (self) {
        _cityFromStr = fromCity;
        _cityToStr = toCity;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    // Таблица (создаем программно, так как в Storyboard ее больше нет)
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    [self loadDataFromCoreData];
}

- (void)loadDataFromCoreData {
    // 1. Получаем AppDelegate
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    // 2. Используем твой контекст (managedObjectContext вместо persistentContainer)
    NSManagedObjectContext *context = appDelegate.managedObjectContext;
    
    // Проверка на случай, если контекст не инициализирован
    if (!context) {
        NSLog(@"Ошибка: Managed Object Context равен nil!");
        return;
    }
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Record"];
    
    // Фильтр по городам
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"cityFrom == %@ AND cityTo == %@", self.cityFromStr, self.cityToStr];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    self.flightsArray = [context executeFetchRequest:fetchRequest error:&error];
    
    if (error) {
        NSLog(@"Ошибка загрузки данных: %@", error.localizedDescription);
    }
    
    [self.tableView reloadData];
}

#pragma mark - UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.flightsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    }
    
    NSManagedObject *record = [self.flightsArray objectAtIndex:indexPath.row];
    
    // Заполняем данными из вашей модели (aviaCompany и price)
    cell.textLabel.text = [record valueForKey:@"aviaCompany"];
    
    float priceValue = [[record valueForKey:@"price"] floatValue];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Цена: %.2f руб.", priceValue];
    
    return cell;
}

@end
