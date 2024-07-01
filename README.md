# K8S_Basic
Follow the instructions below to deploy a K8S cluster from scratch 

# Prerequisites 
1. Must have Github and Dockerhub accounts.


# Write a demo Web-app using Fast API framework
## Initial setup 
1. Install Python3
    ```bash
    sudo apt -y install python3 \
                        python3-pip \
                        python3-venv
    ```
2. Crete a Python virtual environemnt `venv`
    ```bash
    python3 -m venv venv
    ```
3. Activate `venv`
    ```bash
    source venv/bin/activate
    ```
4. Update `pip` within the `venv`
    ```bash
    pip3 install --upgrade pip
    ```
5. Install nessesary packages 
   ```bash
    pip3 install fastapi \    # web-framework
                 uvicorn      # web-server
    ``` 
6. Create a `requirements.txt` file from the `venv` environment
    ```bash
    pip3 freeze > requirements.txt
    ```
## Web Application
Create a `app.py` file with the following code. 
```python
from fastapi import FastAPI, Request
import datetime
import uvicorn

app = FastAPI()


@app.get("/")
async def root(request:Request):
    return {'time_stamp': str(datetime.datetime.now()), # prints current datetime
             'client_ip': request.client.host,          # prints client's IP    
             'message': 'hello'                         # Message
           }


if __name__ == '__main__':
    uvicorn.run(app=app, host='0.0.0.0', port=5000)     # runs the app on web server
```

Run the app with python
```bash
python3 app.py
```

# Containerise the Web App
Write a docker file `dockerfile`
```dockerfile
FROM python:3.12
ADD requirements.txt .
ADD app.py .
RUN pip3 install -r requirements.txt
EXPOSE 5000
CMD ["python3","app.py"]
```

Write a `builder.sh` file. Recommanded to use a token.

```bash
DHUB_UNAME=$1
DHUB_PW=$2
VER=$3

docker build $DHUB_UNAME/fastapi-test:$VER .
docker login -u $DHUB_UNAME -p $DHUB_PW
docker push $DHUB_UNAME/fastapi-test:$VER
```
Container will be pushed to Dockerhub. 


