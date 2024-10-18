from flask import Flask, request

app = Flask(__name__)

access_token = None

@app.route('/callback', methods=['GET', 'POST'])
def capture():
    global access_token
    if request.method == 'POST':
        access_token = request.form.get('access_token') or request.json.get('access_token')
    else:
        access_token = request.args.get('access_token')
    
    return "Token Captured", 200

@app.route('/get_token', methods=['GET'])
def get_token():
    if access_token:
        return access_token, 200
    return "No Token Available", 404

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)