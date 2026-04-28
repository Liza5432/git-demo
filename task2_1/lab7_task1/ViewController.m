#import "ViewController.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Начальные установки
    self.currentColor = [UIColor blackColor];
    self.currentLineWidth = 5.0f;
}

#pragma mark - Выбор цвета
- (IBAction)Red:(id)sender { self.currentColor = [UIColor redColor]; }
- (IBAction)Brown:(id)sender { self.currentColor = [UIColor brownColor]; }
- (IBAction)Blue:(id)sender { self.currentColor = [UIColor blueColor]; }
- (IBAction)Green:(id)sender { self.currentColor = [UIColor greenColor]; }
- (IBAction)Black:(id)sender { self.currentColor = [UIColor blackColor]; }

#pragma mark - Выбор толщины
- (IBAction)width1:(id)sender { self.currentLineWidth = 1.0f; }
- (IBAction)width3:(id)sender { self.currentLineWidth = 3.0f; }
- (IBAction)width5:(id)sender { self.currentLineWidth = 5.0f; }
- (IBAction)width10:(id)sender { self.currentLineWidth = 10.0f; }
- (IBAction)width15:(id)sender { self.currentLineWidth = 15.0f; }

#pragma mark - Рисование
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    self.lastPoint = [touch locationInView:self.view];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self.view];

    UIGraphicsBeginImageContext(self.view.frame.size);
    [self.canvas.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // ПАРАМЕТРЫ КИС (берем из свойств)
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineWidth(context, self.currentLineWidth);
    
    CGFloat r, g, b, a;
    [self.currentColor getRed:&r green:&g blue:&b alpha:&a];
    CGContextSetRGBStrokeColor(context, r, g, b, a);

    CGContextBeginPath(context);
    CGContextMoveToPoint(context, self.lastPoint.x, self.lastPoint.y);
    CGContextAddLineToPoint(context, currentPoint.x, currentPoint.y);
    CGContextStrokePath(context);

    self.canvas.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.lastPoint = currentPoint;
}

#pragma mark - Сохранение
- (IBAction)saveImageToGallery:(id)sender {
    if (self.canvas.image) {
        UIImageWriteToSavedPhotosAlbum(self.canvas.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSString *msg = error ? @"Ошибка" : @"Сохранено в фотопоток!";
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Статус" message:msg preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
