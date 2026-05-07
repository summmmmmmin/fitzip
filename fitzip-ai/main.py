from fastapi import FastAPI
from app.routers import analysis

app = FastAPI(title="FitZip AI Service", version="1.0.0")

app.include_router(analysis.router, prefix="/analysis", tags=["analysis"])


@app.get("/health")
def health_check():
    return {"status": "ok"}
