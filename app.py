from fastapi import FastAPI, Request
import datetime
import uvicorn

app = FastAPI()


@app.get("/")
async def root(request:Request):
    return {'time_stamp': str(datetime.datetime.now()),
             'client_ip': request.client.host,
             'message': 'hello'
           }


if __name__ == '__main__':
    uvicorn.run(app=app, host='0.0.0.0', port=5000)

