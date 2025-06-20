import pandas as pd
from pygtrans import Translate, Null


def translate_column_name(pd: pd.DataFrame) -> pd.DataFrame:
    """Translate the column names of a DataFrame.
    
    Args:
        pd: The DataFrame whose column names are to be translated.
        
    Returns:
        A DataFrame with translated column names.
    """
    client = Translate(target='en')

    for column in pd.columns:
        try:
            result = client.translate(column)
            # Process the translation result: if it's a list, take the first element; otherwise, use the object directly.
            if isinstance(result, list) and len(result) > 0:
                translated_text = result[0].translatedText
            else:
                translated_text = result.translatedText
            pd.rename(columns={column: translated_text}, inplace=True)
        except Exception as e:
            print(f"Error translating column name '{column}': {e}")
            # If translation fails, keep the original column name.
            continue

    return pd


def translate_column(pd: pd.DataFrame, column: str) -> pd.DataFrame:
    """Translate the values of a specified column in a DataFrame.
    
    Args:
        pd: The DataFrame to be translated.
        column: The name of the column to be translated.
        
    Returns:
        The translated DataFrame.
    """
    client = Translate(target='en')

    unique_values = pd[column].unique()
    mapping = {}
    for value in unique_values:
        print(value)
        try:
            result = client.translate(str(value))
            # Process the translation result: if it's a list, take the first element; otherwise, use the object directly.
            if isinstance(result, list) and len(result) > 0:
                translated_text = result[0].translatedText
            else:
                translated_text = result.translatedText
            mapping[value] = translated_text
        except Exception as e:
            print(f"Error translating value '{value}': {e}")
            # If translation fails, keep the original value.
            mapping[value] = str(value)

    pd[column] = pd[column].map(mapping)
    return pd



