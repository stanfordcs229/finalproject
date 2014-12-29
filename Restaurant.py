class Restaurant:
    'A class with all the attributes we need for a Restaurant'
    def __init__(self, id, name, cuisines, city, average_rating, ambience, price_range, review_count):
        self.id = id
        self.name = name
        self.cuisines = cuisines
        self.city = city
        self.average_rating = average_rating
        self.ambienceList = ambience
        self.price_range = price_range
        self.review_count = review_count
