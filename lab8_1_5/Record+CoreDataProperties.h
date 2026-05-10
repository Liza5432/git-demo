//
//  Record+CoreDataProperties.h
//  lab8_1_5
//
//  Created by анус on 5/9/26.
//
//

#import "Record+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Record (CoreDataProperties)

+ (NSFetchRequest<Record *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *aviaCompany;
@property (nullable, nonatomic, copy) NSString *cityFrom;
@property (nullable, nonatomic, copy) NSString *cityTo;
@property (nonatomic) float price;

@end

NS_ASSUME_NONNULL_END
