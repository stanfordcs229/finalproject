import YelpDataReader
import RestaurantProcessor
import ReviewProcessor
from Review import Review
from CsvWriter import write_csv
import operator

def loadReviews():
    return ReviewProcessor.loadReviews()

def loadRestaurants():
    return RestaurantProcessor.loadRestaurants()

# this method takes a list of reviews and a list of restaurants
# it returns a list of reviews on those restaurants
def merge(reviews, restaurants):
    reviews = aggregateReviewsByBusiness(reviews)
    to_retain = []      # reviews to keep
    for restaurant in restaurants:
        if restaurant.id in reviews:
            to_retain += reviews[restaurant.id]
    return to_retain

# returns a map from user_id to a list of reviews that user has written
def aggregateReviewsByUser(reviews):
    user_to_reviews = {}
    for review in reviews:
        user_id = review.user_id
        if not user_id in user_to_reviews:
            user_to_reviews[user_id] = []
        user_to_reviews[user_id].append(review)
    return user_to_reviews

# returns a map from biz_id to a list of reviews that user has written
def aggregateReviewsByBusiness(reviews):
    restaurant_to_reviews = {}
    for review in reviews:
        biz_id = review.biz_id
        if not biz_id in restaurant_to_reviews:
            restaurant_to_reviews[biz_id] = []
        restaurant_to_reviews[biz_id].append(review)
    return restaurant_to_reviews

# returns a dict of user_id -> list of reviews
# which have been filtered for only reviews of restaurants.
def restrictReviewsToRestaurants():
    all_reviews = loadReviews()
    restaurants = loadRestaurants()
    reviews = merge(all_reviews, restaurants)
    print 'We have %d->%d reviews for %d restaurants' % (len(all_reviews), len(reviews), len(restaurants))
    user_to_reviews = aggregateReviewsByUser(reviews)

    restaurant_map = {}
    for restaurant in restaurants:
        restaurant_map[restaurant.id] = restaurant

    return (user_to_reviews, restaurant_map)

if __name__ == '__main__':
    (user_to_reviews, restaurant_map) = restrictReviewsToRestaurants()
    user_count = {}
    for user_id in user_to_reviews:
        user_count[user_id] = len(user_to_reviews[user_id])
    print 'user_id, count_of_reviews'
    for (user_id, count) in sorted(user_count.items(), key=operator.itemgetter(1), reverse=True):
        print '%s, %d' % (user_id, count)
