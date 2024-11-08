import os
from googleapiclient.discovery import build
import json


def get_search_results(query: str, api_key: str, cse_id: str, **kwargs):
    if not api_key or not cse_id:
        print("Please set your Google Search Engine API keys in the environment variables.")
        return

    service = build("customsearch", "v1", developerKey=api_key)
    res = service.cse().list(q=query, cx=cse_id, **kwargs).execute()
    return res.get('items', [])


def get_json_results(results):
    formatted_results = []
    for result in results:
        formatted_results.append({
            'title': result.get('title'),
            'snippet': result.get('snippet'),
            'link': result.get('link')
        })
    return formatted_results

def export_results_to_json(results, filename='search_results.json'):
    with open(filename, 'w', encoding='utf-8') as f:
        json.dump(results, f, indent=2)


def search_google(query: str):
    """
    Search the web for a query and return the results in JSON format.
    """
    google_api_key = os.environ.get('GOOGLE_API_KEY')
    google_cse_id = os.environ.get('GOOGLE_CSE_ID')

    print(f"Searching for {query}")

    results = get_search_results(
        query, google_api_key, google_cse_id, num=5)

    return get_json_results(results)


if __name__ == "__main__":
    results = search_google("espn")
    export_results_to_json(results)
    print(results)
