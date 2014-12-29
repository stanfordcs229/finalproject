class Review:

    def __init__(self, review_id, biz_id, user_id, rating, date):
        self.id = review_id
        self.biz_id = biz_id
        self.user_id = user_id
        self.rating = rating
        self.date = int(date.replace('-', ''))
