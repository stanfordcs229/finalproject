import simplejson as json
from Restaurant import Restaurant
from Review import Review

BUSINESS_ID = 'business_id'
CATEGORIES = 'categories'
CITY = 'city'
AVERAGE_RATING = 'stars'
NAME = 'name'
OPEN = 'open' # as opposed to closed/shutdown
TRUE = 'true'
FALSE = 'false'
NO_LIMIT = -1
RATING = 'stars'
USER_ID = 'user_id'
REVIEW_ID = 'review_id'

def convert(line, dataset_type):
    if 'biz' == dataset_type:
        return convertRestaurant(line)
    elif 'review' == dataset_type:
        return convertReview(line)

def convertRestaurant(line):
    line_contents = json.loads(line)
    if OPEN not in line_contents or line_contents[OPEN] == FALSE:
        return None
    categories = line_contents[CATEGORIES]
    if not 'Restaurants' in categories:
        return None
    if not 'attributes' in line_contents:
        return None
    if not 'Price Range' in line_contents['attributes']:
        return None
    if not 'Ambience' in line_contents['attributes']:
        return None
    id = line_contents[BUSINESS_ID]
    categories.remove('Restaurants')
    city = line_contents[CITY]
    average_rating = line_contents[AVERAGE_RATING]
    name = line_contents[NAME]
    price_range = line_contents['attributes']['Price Range']
    ambience = line_contents['attributes']['Ambience']
    review_count = line_contents['review_count'] if line_contents['review_count'] else 0
    return Restaurant(id, name, categories, city, average_rating, ambience, price_range, review_count)

def convertReview(line):
    line_contents = json.loads(line)
    review_id = line_contents[REVIEW_ID]
    biz_id = line_contents[BUSINESS_ID]
    user_id = line_contents[USER_ID]
    rating = line_contents[RATING]
    date = line_contents['date']
    return Review(review_id, biz_id, user_id, rating, date)

def read_file(file_path, dataset_type, limit):
    """Read in the json dataset file and return a list of python dicts."""
    file_contents = []
    column_names = set()
    with open(file_path) as fin:
        for line in fin:
            datum = convert(line, dataset_type)
            if datum is not None:
                file_contents.append(datum)
            if limit == 0:
                break
            else:
                limit -= 1
    return file_contents

if __name__ == '__main__':
    biz_data = read_file('yelp_dataset/json/yelp_academic_dataset_business.json', 'biz', 5)
    print 'We have %d restaurants.' % len(biz_data)
    review_data = read_file('yelp_dataset/json/yelp_academic_dataset_review.json', 'review', 5)
    print   'We have %d reviews' % len(review_data)
