import YelpDataReader
import RestaurantProcessor
from Review import Review
from CsvWriter import write_csv

# review_id, biz_id, user_id, rating:
def loadReviews(limit=YelpDataReader.NO_LIMIT):
    return YelpDataReader.read_file('yelp_dataset/json/yelp_academic_dataset_review.json', 'review', limit)

if __name__ == '__main__':
    reviews = loadReviews()
    print 'We have %d reviews.' % len(reviews)

    filteredReviews = []
    business_ids = []
    for review in reviews:
        if review.user_id == 'FcjwXnuDuN8not6PoHID3w':
            filteredReviews.append(review)
            business_ids.append(review.biz_id)
    

    print 'We have %d filtered reviews.' % len(filteredReviews)
    column_names = [ 'user_id', 'biz_id', 'rating' ]
    print 'Number of columns: ', len(column_names)
    print 'Column names:', column_names
    write_csv('v1_labels_for_FcjwXnuDuN8not6PoHID3w.csv', filteredReviews, column_names)

    RestaurantProcessor.filterP(business_ids)
