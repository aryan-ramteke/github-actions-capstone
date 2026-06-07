from fastapi import FastAPI
from routes import metrics,aws_usage

app = FastAPI(title="Internal DevOps API Utility", description="This is an internal api utility for monitoring metrics, AWS Usage and log analysis", version="1.0.0", doc_url="/docs", redoc_url="/redoc") #creating api application with fastapi class
app.include_router(metrics.router)
app.include_router(aws_usage.router)

@app.get("/")
def hello():
    """This is the hello API for testing"""
    return {"message": "Hello from hello api"}
