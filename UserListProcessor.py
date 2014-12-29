from RestrictReviewsToRestaurants import restrictReviewsToRestaurants
import CsvWriter
import RestaurantProcessor
import datetime
import os

DIRECTORY_PREFIX = 'generatedData/output_'

class Feature:
    def __init__(self):
        self.dummy = 'dummy'
        
class Label:
    def __init__(self, rating):
        self.rating = rating
        self.label = 1 if int(rating) > 3 else 0

def readFile(file_path):
    """Read in the list of in-scope users and return them as a python list. Expect file to have one user_id per line."""
    file_contents = []
    with open(file_path, 'r') as fin:
        for line in fin:
            file_contents.append(line.rstrip())
    return file_contents

def generateUserFeatureFile(directory, filename, reviews, restaurant_map, feature_list):
    restaurants = []
    for review in reviews:
        restaurant = restaurant_map[review.biz_id]
        user_review_count = getattr(restaurant, 'user_review_count', 0)
        setattr(restaurant, 'user_review_count', user_review_count+1)
        date_of_last_review = getattr(restaurant, 'date_of_last_review', 0)
        date_of_last_review = max(date_of_last_review, review.date)
        setattr(restaurant, 'date_of_last_review', date_of_last_review)
        if date_of_last_review == review.date:
            setattr(restaurant, 'latest_rating', review.rating)
        restaurants.append(restaurant)
    filepath = directory + '/features_for_' + filename + '.csv'
    RestaurantProcessor.writeFeatureMatrixCsvFile(restaurants, filepath, feature_list)
    # reset dodgy static data
    for restaurant in restaurants:
        setattr(restaurant, 'user_review_count', 0)
        setattr(restaurant, 'date_of_last_review', 0)
        setattr(restaurant, 'latest_rating', 0)
    
# reviews is a list
def generateUserLabelFile(directory, filename, reviews):
    labels = []
    for review in reviews:
        labels.append(Label(review.rating))
    filepath = directory + '/labels_for_' + filename + '.csv'
    CsvWriter.write_csv(filepath, labels, ['rating'])

# creates directory for writing files, if it does not already exist.
# naming convention is generatedData/output_YYYYMMDD
def createOutputDirectory():
    intdate = datetime.datetime.now().strftime('%Y%m%d')
    directory = DIRECTORY_PREFIX + intdate
    if not os.path.exists(directory):
        print 'creating directory: ', directory
        os.makedirs(directory)
    return directory

def readListOfFeatures():
    feature_list = readFile('config/list_of_features.txt')
    features = []
    for line in feature_list:
        # ignore empty lines and comments
        index = line.find('#')
        if index > -1:
            line = line[:index]
        line = line.strip()
        if not line:
            continue
        features.append(line)
    print 'Number of columns: ', len(features)
    print 'Column names:', features
    return features


if __name__ == '__main__':
    if not os.path.exists('in_scope_users.txt'):
        print 'Usage: Create a file with user ids on each line, named in_scope_users.txt and place in the same directory as this script.\nThen run: python UserListProccessory.py\nThis will create feature matrix and label vector for each user_id in the file.'
    user_list = readFile('config/in_scope_users.txt')
    feature_list = readListOfFeatures()
    (user_to_reviews, restaurant_map) = restrictReviewsToRestaurants()
    directory = createOutputDirectory()
    for user_id in user_list:
        generateUserFeatureFile(directory, user_id, user_to_reviews[user_id], restaurant_map, feature_list)
        generateUserLabelFile(directory, user_id, user_to_reviews[user_id])
