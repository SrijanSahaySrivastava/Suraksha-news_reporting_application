import os
import shutil
from fastapi import FastAPI, UploadFile, File
from fastapi.responses import JSONResponse

app = FastAPI()


@app.post("/upload/")
async def upload_file(file: UploadFile = File(...)):
    with open(f"{file.filename}", "wb") as buffer:
        shutil.copyfileobj(file.file, buffer)

    # Open the file
    os.startfile(file.filename)

    return {"filename": file.filename}
