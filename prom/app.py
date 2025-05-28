


from flask import Flask, render_template, request, redirect, url_for
import sqlite3
import os
from prometheus_flask_exporter import PrometheusMetrics


app = Flask(__name__)
metrics = PrometheusMetrics(app)

# Database setup
DB_NAME = '/app/data/users.db'

def init_db():
    db_dir = os.path.dirname(DB_NAME)
    if db_dir and not os.path.exists(db_dir):
        os.makedirs(db_dir)
    if not os.path.exists(DB_NAME):
        conn = sqlite3.connect(DB_NAME)
        c = conn.cursor()
        c.execute('''CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT NOT NULL,
            email TEXT NOT NULL
        )''')
        conn.commit()
        conn.close()


def get_db_connection():
    conn = sqlite3.connect(DB_NAME)
    conn.row_factory = sqlite3.Row
    return conn


@app.route('/register', methods=['GET', 'POST'])
def register():
    if request.method == 'POST':
        username = request.form.get('username')
        email = request.form.get('email')
        if username and email:
            conn = get_db_connection()
            conn.execute('INSERT INTO users (username, email) VALUES (?, ?)', (username, email))
            conn.commit()
            conn.close()
            return redirect(url_for('view_users'))
    return render_template('register.html')


@app.route('/view')
def view_users():
    conn = get_db_connection()
    users = conn.execute('SELECT username, email FROM users').fetchall()
    conn.close()
    return render_template('view.html', users=users)


if __name__ == '__main__':
    init_db()
    app.run(host='0.0.0.0')
