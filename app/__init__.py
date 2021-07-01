import os
from flask import Flask, render_template, send_from_directory, request, redirect
from dotenv import load_dotenv
from . import db
from werkzeug.security import check_password_hash, generate_password_hash
from app.db import get_db

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

@app.route('/register', methods=('GET', 'POST'))
def register():
    if request.method == 'POST':
        username = request.form.get('username')
        password = request.form.get('password')
        db = get_db()
        error = None

        if not username:
            error = 'Username is required.'
        elif not password:
            error = 'Password is required.'
        elif db.execute(
            'SELECT id FROM user WHERE username = ?', (username,)
        ).fetchone() is not None:
            error = f"User {username} is already registered."

        if error is None:
            db.execute(
                'INSERT INTO user (username, password) VALUES (?, ?)',
                (username, generate_password_hash(password))
            )
            db.commit()
            return f"User {username} created successfully"
        else:
            return error, 418

    # TODO: Return a restister page
    return "Register Page not yet implemented", 501

@app.route('/login', methods=('GET', 'POST'))
def login():
    if request.method == 'POST':
        username = request.form.get('username')
        password = request.form.get('password')
        db = get_db()
        error = None
        user = db.execute(
            'SELECT * FROM user WHERE username = ?', (username,)
        ).fetchone()

        if user is None:
            error = 'Incorrect username.'
        elif not check_password_hash(user['password'], password):
            error = 'Incorrect password.'

        if error is None:
            return "Login Successful", 200 
        else:
            return error, 418
    
    ## TODO: Return a login page
    return "Login Page not yet implemented", 501