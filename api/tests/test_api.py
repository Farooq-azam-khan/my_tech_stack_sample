from api import __version__

def test_version():
    assert __version__ == '0.1.0'



def test_read_main(test_app):
    response = test_app.get('/')
    assert response.status_code == 200 
    assert response.json() == {'hello': 'world'}
