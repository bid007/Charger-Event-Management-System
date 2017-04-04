
from bottle import run
# import Organization
import routes

def main():
	run(host='localhost', port=8080, reloader=True, debug=True)

if __name__ == '__main__':
	main()