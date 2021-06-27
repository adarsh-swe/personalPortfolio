import os
from flask import Flask, render_template, send_from_directory, request, redirect
from dotenv import load_dotenv
from . import db

load_dotenv()
app = Flask(__name__)
app.config['DATABASE'] = os.path.join(os.getcwd(), 'flask.sqlite')
db.init_app(app)

@app.route('/')
def index():
   return render_template('aboutPage.html', title="Adarsh Patel", url=os.getenv("URL"))

@app.route('/about')
def about():
    return render_template('aboutPage.html', title="Adarsh Patel" , url=os.getenv("URL"))

@app.route('/blog')
def blog():
    return render_template('blogPage.html', title="Adarsh Patel", url=os.getenv("URL"))

@app.route('/projects')
def projects():
    return render_template('projectsPage.html', title="Adarsh Patel", url=os.getenv("URL"))

@app.route('/health')
def health():
    return "app running properly...", 200

