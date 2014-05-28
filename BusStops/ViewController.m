//
//  ViewController.m
//  BusStops
//
//  Created by dan rudolf on 5/28/14.
//  Copyright (c) 2014 Dan Rudolf. All rights reserved.
//

#import "ViewController.h"
#import "BusStop.h"

@interface ViewController ()<MKMapViewDelegate,UITableViewDataSource, UITableViewDelegate>
@property NSArray *trainstops;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UITableView *tableViewOutlet;
@property (weak, nonatomic) IBOutlet UILabel *directionLable;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(41.883174, -87.6287302), 600, 6000);
    [self.mapView setRegion:region];
    [self getData];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)getData{
    NSURLRequest *dataRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://s3.amazonaws.com/mobile-makers-lib/bus.json"]];
    [NSURLConnection sendAsynchronousRequest:dataRequest
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
    {
        NSDictionary *dictionaryData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&connectionError];
        NSArray *stopDictionaries = [dictionaryData objectForKey:@"row"];
        
        //**BusStop is of Type MKPointAnnotation so all of the properties can be accesed and set in this for loop**
        for (NSDictionary *dictionary in stopDictionaries) {
            BusStop *stop = [[BusStop alloc] initWithStopName:[dictionary objectForKey:@"cta_stop_name"]
                                                     latitude:[dictionary objectForKey:@"latitude"]
                                                    longetude:[dictionary objectForKey:@"longitude"]
                                                    direction:[dictionary objectForKey:@"direction"]];
            [stop addStops:[dictionary objectForKey:@"routes"]];
            
            float lat = [stop.latitude floatValue];
            float lon = [stop.longetude floatValue];
            stop.coordinate = CLLocationCoordinate2DMake(lat, lon);
            stop.title = stop.name;
            
//**This method call adds the actual location to the Mapview, does not need a Reload call after updates are made**
            [self.mapView addAnnotation:stop];
        }
        
    }];
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    MKPinAnnotationView *pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:nil];
    pin.canShowCallout = YES;
    pin.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    return pin;
}


//***Similar method to 'didSelectRowAtindexPath" MKAnnotationView is the object, so data modeled and properties accest through this method should be set in an Object of Type "MKPointAnimation" which carries associated content similiar to a TableView Cell***

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
    BusStop *stop = (BusStop *)view.annotation;
    self.trainstops = stop.stops;
    self.directionLable.text = stop.direction;
    [self.tableViewOutlet reloadData];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.trainstops.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    NSString *stopName = [self.trainstops objectAtIndex:indexPath.row];
    cell.textLabel.text = stopName;
    return cell;
}






@end
