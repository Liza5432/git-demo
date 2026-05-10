//
//  Record+CoreDataProperties.m
//  lab8_1_5
//
//  Created by анус on 5/9/26.
//
//

#import "Record+CoreDataProperties.h"

@implementation Record (CoreDataProperties)

+ (NSFetchRequest<Record *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Record"];
}

@dynamic aviaCompany;
@dynamic cityFrom;
@dynamic cityTo;
@dynamic price;

@end
