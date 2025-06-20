import pandas as pd
import json
from utils import translate_column_name,translate_column
def encode_patient_ids(df,label:str):
    with open(f'patient_id_mapping_{label}.json', 'r') as f:
        id_mapping = json.load(f)
    df['Medical record number'] = df['Medical record number'].astype(str)
    df['Medical record number'] = df['Medical record number'].map(id_mapping)

    return df

def encode_time_offset(df,label:str):
    with open(f'patient_time_offset_mapping_{label}.json', 'r') as f:
        time_offset_mapping = json.load(f)
    # Get time offset based on medical record number
    
    df['Medical record number'] = df['Medical record number'].astype(str)
    print(df['Medical record number'])
    df['time_offset'] = df['Medical record number'].map(time_offset_mapping)
    print(df['time_offset'])
  
    
    df['Admission time'] = df['Admission time'] + pd.to_timedelta(df['time_offset'],unit='d')
    df['Discharge time'] = df['Discharge time'] + pd.to_timedelta(df['time_offset'],unit='d')
    df.drop(columns=['time_offset'],inplace=True)

    return df




def split_visit_record_csv(visit_record_df,label:str):
    # Read patient_info.csv file

    # Anonymize medical record number
    
    visit_record_df = encode_time_offset(visit_record_df,label)
    visit_record_df = encode_patient_ids(visit_record_df,label)
    # save to csv
    return visit_record_df

def select_df(df:pd.DataFrame):
    df = df[['病案号','入院时间','出院时间','入院科室','出院科室']]
    df = translate_column(df,'入院科室')
    df = translate_column(df,'出院科室')
    df = translate_column_name(df)
    print(df.head())
    return df


split_visit_record_csv(select_df(pd.read_csv('./data/final_preprocessed_data.csv',
                                             parse_dates=['入院时间','出院时间'])),'old').to_csv('visit_record_old.csv', index=False)
split_visit_record_csv(select_df(pd.read_csv('./data/final_preprocessed_data_new.csv',
                                             parse_dates=['入院时间','出院时间'])),'new').to_csv('visit_record_new.csv', index=False)