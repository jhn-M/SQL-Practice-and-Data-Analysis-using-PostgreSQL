# -*- coding: utf-8 -*-
"""
Created on Wed Jul  8 00:44:57 2026

@author: Marry Bless Magat
"""


import pandas as pd
from sqlalchemy import create_engine

engine = create_engine('mysql+pymysql://root:lenon03@localhost/hr_project')

query = """
SELECT 
    performance_rating,
    SUM(CASE WHEN status = 'Active' THEN 1 ELSE 0 END) AS active,
    SUM(CASE WHEN status = 'Resigned' THEN 1 ELSE 0 END) AS resigned,
    SUM(CASE WHEN status = 'Terminated' THEN 1 ELSE 0 END) AS 'terminated'
FROM hr_data
WHERE status != 'Retired'
GROUP BY performance_rating;
"""

contingency_df = pd.read_sql(query, engine)
contingency_df = contingency_df.set_index('performance_rating')
print(contingency_df)