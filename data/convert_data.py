import pandas as pd
import os

for file in os.listdir('.'):
    filename = os.fsdecode(file)
    if filename.endswith(".xlsx"):
        file = pd.read_excel(filename)
        file.to_csv('./' + os.path.splitext(filename)[0] + '.csv', sep=',', encoding='utf-8', index=False)
        # print(os.path.join(directory, filename))
        os.remove(filename)
        continue
    else:
        continue

