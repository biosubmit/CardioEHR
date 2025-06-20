import pandas as pd
import json
from utils import translate_column,translate_column_name
def encode_patient_ids(df,label:str):
    with open(f'patient_id_mapping_{label}.json', 'r') as f:
        id_mapping = json.load(f)
    df['Medical record number'] = df['Medical record number'].astype(str)
    df['Medical record number'] = df['Medical record number'].map(id_mapping)

    return df

def split_dignosis_csv(dignosis_df,label:str):
    # Read patient_info.csv file

    # Anonymize medical record number
    dignosis_df = encode_patient_ids(dignosis_df,label)
    
    # save to csv
    return dignosis_df

def select_df(df:pd.DataFrame):
    df = df[['病案号','主要诊断']]
    df = translate_column(df,'主要诊断')
    df = translate_column_name(df)
    print(df.head())
    return df


split_dignosis_csv(select_df(pd.read_csv('./data/final_preprocessed_data.csv')),'old').to_csv('diagnosis_old.csv', index=False)
split_dignosis_csv(select_df(pd.read_csv('./data/final_preprocessed_data_new.csv')),'new').to_csv('diagnosis_new.csv', index=False)