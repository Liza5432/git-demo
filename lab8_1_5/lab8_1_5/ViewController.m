#import "ViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "FlightsViewController.h"

@interface ViewController ()
{
    int isCity;
    MKPointAnnotation *annotationFrom;
    MKPointAnnotation *annotationTo;
}
@property (weak, nonatomic) IBOutlet MKMapView *map;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)];
    [self.map addGestureRecognizer:longPressGesture];
   
    self.cityFrom.delegate = self;
    self.cityTo.delegate = self;
    self.map.delegate = self;
}
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithPolyline:(MKPolyline *)overlay];
        renderer.strokeColor = [UIColor systemBlueColor];
        renderer.lineWidth = 4.0;
        return renderer;
    }
    return nil;
}

-(void)handleLongPressGesture:(UIGestureRecognizer*)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        CGPoint point = [sender locationInView:self.map];
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        CLLocationCoordinate2D coord = [self.map convertPoint:point toCoordinateFromView:self.map];
        
        CLLocation *location = [[CLLocation alloc] initWithLatitude:coord.latitude longitude:coord.longitude];
        [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
            if (error) {
                NSLog(@"Geocode failed with error: %@", error); return;
            }
            for (CLPlacemark * placemark in placemarks) {
                [self setAnnotationToMap: self->isCity :placemark.locality :coord];
            }
        }];
    }
}
-(void)setAnnotationToMap:(int)type : (NSString *)title : (CLLocationCoordinate2D)coordinate {
    if (type == 0) {
        [self.map removeAnnotation:annotationFrom];
        annotationFrom = [[MKPointAnnotation alloc] init];
        annotationFrom.title = title;
        annotationFrom.coordinate = coordinate;
        [self.map addAnnotation:annotationFrom];
        self.cityFrom.text = title;
    }
    else {
        [self.map removeAnnotation:annotationTo];
        annotationTo = [[MKPointAnnotation alloc] init];
        annotationTo.title = title;
        annotationTo.coordinate = coordinate;
        [self.map addAnnotation:annotationTo];
        self.cityTo.text = title;
    }
    [self calculateRoute];
}
- (void)calculateRoute {
    if (!annotationFrom || !annotationTo) return; 

    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    request.source = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:annotationFrom.coordinate]];
    request.destination = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:annotationTo.coordinate]];
    request.transportType = MKDirectionsTransportTypeAutomobile;

    MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
        if (!error) {
            for (MKRoute *route in response.routes) {
                [self.map addOverlay:route.polyline level:MKOverlayLevelAboveRoads];
            }
        }
    }];
}

-(void)textFieldDidBeginEditing:(UITextField * )textField {
    if (textField == self.cityFrom)
        isCity = 0;
    else if (textField == self.cityTo)
        isCity = 1;
    
    [textField resignFirstResponder];
}

- (IBAction)showFlights:(id)sender {
    // ИСПРАВЛЕНО: заменено self.textFrom на self.cityFrom (как в вашем коде выше)
    FlightsViewController *flights = [[FlightsViewController alloc] initWithBothCity:self.cityFrom.text :self.cityTo.text];
    [self presentViewController:flights animated:YES completion:nil];
}
@end
