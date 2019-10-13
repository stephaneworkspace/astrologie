cd python
rm -rf astro_py
git clone https://github.com/stephaneworkspace/astro_py.git
cd astro_py
mv exemple.py run.py
cd flatlib
python3 setup.py install
cd ..
python3 setup.py install