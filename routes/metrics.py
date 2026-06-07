from fastapi import APIRouter,HTTPException
import os
import sys


dir = os.path.dirname(os.path.dirname(__file__))
sys.path.append(dir)

from services.metric_service import get_system_metrics


router = APIRouter()

@router.get("/health",status_code=200)
def get_metrics():
    try:
        metrics = get_system_metrics()
        return metrics
    except: 
        raise HTTPException(status_code=500,default="Internal Server Error!!")
        

