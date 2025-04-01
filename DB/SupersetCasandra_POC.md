Install os dependencies

sudo apt-get install build-essential libssl-dev libffi-dev python3-dev python3-pip libsasl2-dev libldap2-dev default-libmysqlclient-dev

pip install virtualenv

sudo apt install python3.8-venv

python3 -m venv venv

. venv/bin/activate

pip install apache-superset

openssl rand -hex 32

echo "export SUPERSET_SECRET_KEY=1f15599c884dff5ff9eee9c630ee88a7c64a0c8243652f8737def0ca322b84e2" >> ~/.bashrc

source ~/.bashrc

. venv/bin/activate

export FLASK_APP=superset

export SUPERSET_SECRET_KEY=xxxxxxxxxxxxxxx

pip install "flask<2.3"

deactivate

source /home/ubuntu/venv/bin/activate

pip install marshmallow_enum

python -c "import marshmallow_enum; print('Module installed successfully')"

superset db upgrade

superset fab create-admin

superset init

superset run -h 0.0.0.0 -p 8088 --with-threads --reload --debugger

Installing Database Drivers

Presto

pip install pyhive
