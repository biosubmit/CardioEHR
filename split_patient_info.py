import pandas as pd
import json
import random
import datetime
from typing import Dict, Any
from utils import translate_column_name
from pygtrans import Translate, Null


def encode_addresses(df: pd.DataFrame) -> pd.DataFrame:
    """Simple address encoding: replace addresses with numerical codes.
    
    Args:
        df: DataFrame containing the '省市级地址' column.
        
    Returns:
        The processed DataFrame, with addresses encoded in ADDR_XXX format.
    """
    unique_addresses = df['省市级地址'].unique()
    address_mapping = {addr: f"ADDR_{i+1:03d}" for i, addr in enumerate(unique_addresses)}
    df['省市级地址'] = df['省市级地址'].map(address_mapping)
    return df


def encode_patient_ids(df: pd.DataFrame,label:str) -> pd.DataFrame:
    """Anonymize patient IDs: map original patient IDs to new codes and generate time offsets.
    
    Args:
        df: DataFrame containing the '病案号' column.
        
    Returns:
        The processed DataFrame, with patient IDs encoded in PID_XXXXXX format.
        
    Side Effects:
        Generates patient_id_mapping.json to store the patient ID mapping.
        Generates patient_time_offset_mapping.json to store the time offset mapping.
    """
    unique_ids = df['病案号'].unique()
    
    # Patient ID mapping: convert keys to strings to avoid JSON serialization errors.
    id_mapping: Dict[str, str] = {str(old_id): f"PID_{i+1:06d}" for i, old_id in enumerate(unique_ids)}
    
    # Time offset mapping: generate a random offset from -36500 to +36500 days for each patient ID.
    time_offset_mapping: Dict[str, int] = {}
    for old_id in unique_ids:
        # Generate a random offset from -36500 to +36500 days (unit: days).
        offset_days = random.randint(-36500, 36500)
        time_offset_mapping[str(old_id)] = offset_days
    
    # Apply patient ID mapping.
    df['病案号'] = df['病案号'].astype(str).map(id_mapping)

    # Save patient ID mapping.
    with open(f'patient_id_mapping_{label}.json', 'w', encoding='utf-8') as f:
        json.dump(id_mapping, f, ensure_ascii=False, indent=2)
    
    # Save time offset mapping.
    with open(f'patient_time_offset_mapping_{label}.json', 'w', encoding='utf-8') as f:
        json.dump(time_offset_mapping, f, ensure_ascii=False, indent=2)
    
    print(f"Generated time offsets for {len(unique_ids)} patient IDs, range: -36500 to +36500 days")
    return df


def split_patient_info_csv_old(patient_info: str) -> None:
    """Process the old version of the patient information CSV file.
    
    Args:
        patient_info: Path to the CSV file.
    """
    # Read the patient_info.csv file.
    patient_info_df = pd.read_csv(patient_info)
    # Select columns.
    patient_info_df = patient_info_df[['病案号', '年龄', '性别', '省市级地址']]

    # Anonymize patient IDs.
    patient_info_df = encode_patient_ids(patient_info_df,'old')
    
    # Encode addresses.
    patient_info_df = encode_addresses(patient_info_df)

    # Translate column names.
    patient_info_df = translate_column_name(patient_info_df)
    # save to csv
    patient_info_df.to_csv('patient_info_old.csv', index=False)

def split_patient_info_csv_new(patient_info: str) -> None:
    """Process the new version of the patient information CSV file.
    
    Args:
        patient_info: Path to the CSV file.
    """
    # Read the patient_info.csv file.
    patient_info_df = pd.read_csv(patient_info, parse_dates=['检查时间','出生日期'])
    # Calculate age.
    patient_info_df['年龄'] = patient_info_df['检查时间'].dt.year - patient_info_df['出生日期'].dt.year
    patient_info_df = patient_info_df[['病案号', '年龄', '性别', '省市级地址']]

    # Anonymize patient IDs.
    patient_info_df = encode_patient_ids(patient_info_df,'new')
    
    # Encode addresses.
    patient_info_df = encode_addresses(patient_info_df)

    # Translate column names.
    patient_info_df = translate_column_name(patient_info_df)
    # save to csv
    patient_info_df.to_csv('patient_info_new.csv', index=False)


if __name__ == "__main__":
    split_patient_info_csv_old('./data/final_preprocessed_data.csv')
    split_patient_info_csv_new('./data/final_preprocessed_data_new.csv')


