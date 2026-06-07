from fastapi import APIRouter,HTTPException
import os
import sys


dir = os.path.dirname(os.path.dirname(__file__))
sys.path.append(dir)

from services.aws_usage import aws_usage 


router = APIRouter()

@router.get("/aws_usage",status_code=200)
def get_aws_usage():
    try:
        usage = aws_usage()
        # print(usage)
        return usage
    except Exception as e:
        print(f"Error: {e}")
        raise HTTPException(status_code=500,detail="Internal Server Error!!")
 