import requests


def main():
    print("Fetching example.com...")
    res = requests.get("https://example.com")
    print(f"Response code: {res.status_code}")


if __name__ == "__main__":
    main()
