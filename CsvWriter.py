import csv

def get_row(line_contents, column_names):
    row = []
    for column_name in column_names:
        val = getattr(line_contents, column_name, '0')
        row.append(val)
    return row

def write_csv(file_path, file_contents, column_names):
    """Create and write a csv file given file_contents of our json dataset file and column names."""
    csv_file = csv.writer(open('file_path', 'wb+'))
    with open(file_path, 'wb+') as fin:
        csv_file = csv.writer(fin)
        for line_contents in file_contents:
            csv_file.writerow(get_row(line_contents, column_names))

