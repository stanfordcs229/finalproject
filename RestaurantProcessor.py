import YelpDataReader
from YelpDataReader import read_file
from Restaurant import Restaurant
from CsvWriter import write_csv

CITY_INDEX = 'city_index'

# returns a list of Restaurant objects
def loadRestaurants(limit=YelpDataReader.NO_LIMIT):
    return read_file('yelp_dataset/json/yelp_academic_dataset_business5.json', 'biz', limit)

def processCuisines(restaurants):
    cuisines = set()
    for restaurant in restaurants:
        for cuisine in restaurant.cuisines:
            cuisines.add(cuisine)
    for restaurant in restaurants:
        for cuisine in cuisines:
            val = 1 if cuisine in restaurant.cuisines else 0
            setattr(restaurant, cuisine, val)
    return list(cuisines)

def processCities(restaurants):
    cities = set()
    for restaurant in restaurants:
        cities.add(restaurant.city)
    cities = list(cities)
    for restaurant in restaurants:
        for city in cities:
            val = 1 if city == restaurant.city else 0
            setattr(restaurant, city, val)
    return cities

def processAmbiences(restaurants):
    ambiences = set()
    for restaurant in restaurants:
        for ambience in restaurant.ambienceList.keys():
            ambiences.add(ambience)
    for restaurant in restaurants:
        for ambience in ambiences:
            val = 1 if (ambience in restaurant.ambienceList.keys() and restaurant.ambienceList[ambience]) else 0
            setattr(restaurant, ambience, val)
    return list(ambiences)

# filters the list of 'restaurants' for only those with 'restaurant_ids'
def filter(restaurants, restaurant_ids):
    filteredRestaurants = []
    for restaurant in restaurants:
        if restaurant.id in restaurant_ids:
            filteredRestaurants.append(restaurant)
    return filteredRestaurants

# loads restaurants from JSON file and filters those that have 'restaurant_ids'
def filterP(restaurant_ids):
    restaurants = loadRestaurants()
    restaurants = filter(restaurants, restaurant_ids)
    print 'We have %d restaurants.' % len(restaurants)

    cuisines = processCuisines(restaurants)
    print 'List of cuisines(', len(cuisines), ') :', cuisines,
    cities = processCities(restaurants)
    print 'List of cities:', cities
    column_names = cuisines + ['average_rating', CITY_INDEX, 'id' ]
    print 'Number of columns: ', len(column_names)
    write_csv('v1_features_filtered.csv', restaurants, column_names)

def writeFeatureMatrixCsvFile(restaurants, filename='v3_features.csv', column_names=[]):
    cuisines = processCuisines(restaurants)
    #print 'List of cuisines(', len(cuisines), ') :', cuisines,
    cities = processCities(restaurants)
    #print 'List of cities:', cities
    ambiences = processAmbiences(restaurants)
    #print 'List of ambiences:', ambiences
    if not column_names:
        column_names = cuisines + ambiences + cities + ['average_rating' ]
    #print 'Number of columns: ', len(column_names)
    #print 'Column Names' , column_names
    write_csv(filename, restaurants, column_names)
    #print ''

    

if __name__ == '__main__':
    restaurants = loadRestaurants()
    print 'We have %d restaurants.' % len(restaurants)
    writeFeatureMatrixCsvFile(restaurants)
