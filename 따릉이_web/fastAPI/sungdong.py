from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
import pandas as pd
import requests
from urllib.parse import quote 
import os


app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

API_KEY = "785551435a726c613131314569565551"

# 성동구 대여소 ID 로드
BASE_DIR = os.path.dirname(os.path.abspath(__file__))
CSV_PATH = os.path.join(BASE_DIR, "Data", "따릉이_성동구_대여소.csv")

# CSV 파일 불러오기
sungdong_df = pd.read_csv(CSV_PATH)
sungdong_station_ids = sungdong_df['대여소_ID'].astype(str).tolist()

@app.get("/bike/sungdong")
def get_sungdong_bikes():
    url = f"http://openapi.seoul.go.kr:8088/{API_KEY}/json/bikeList/1/1000"
    response = requests.get(url)

    if response.status_code != 200:
        return {"error": "API 요청 실패"}

    try:
        data = response.json()
        stations = data["rentBikeStatus"]["row"]

        #  성동구 stationId 와 일치하는 데이터만 필터링
        filtered = [
        s for s in stations if s["stationId"] in sungdong_station_ids
                ]

        return filtered

    except Exception as e:
        return {"error": str(e)}
    

@app.get("/weather/seoul")
def get_weather():
    url = f"http://openapi.seoul.go.kr:8088/785551435a726c613131314569565551/json/citydata/1/1000"
    response = requests.get(url)

    if response.status_code != 200:
        return {"error": f"API 호출 실패: {response.status_code}"}

    try:
        data = response.json()
        weather = data["SeoulRtd.citydata"]["WEATHER_STTS"]
        return weather
    except Exception as e:
        return {"error": f"데이터 파싱 실패: {e}"}



if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app,host='127.0.0.1',port=8000)